import bearer from "@elysiajs/bearer";
import elysiaJwt from "@elysiajs/jwt";
import { isAxiosError } from "axios";
import { sql } from "drizzle-orm";
import { Elysia, t } from "elysia";
import { CountryCode, Products } from "plaid";
import { z } from "zod";
import { Database } from "./db";
import { plaidClient } from "./plaid";
import { plaidItems, users } from "./schema";
import { ItemId, SyncService } from "./sync_service";

const encoder = new TextEncoder();

const AuthMethod = z.enum(["email", "apple"]);
const PlaidItemStatus = z.enum(["success", "error"]);

function makeJWTPayload(userId: string) {
  return {
    sub: userId,
    aud: "finny",
    iat: Date.now(),
  };
}

async function main() {
  const database = new Database();
  await database.connect();

  const app = new Elysia()
    .use(bearer())
    .use(
      elysiaJwt({
        name: "jwt",
        secret: "Dennis von Baron Whaler",
        exp: "7d",
      }),
    )
    .onError(({ code, error, set }) => {
      if (code === "NOT_FOUND") {
        set.status = 404;
        return {
          message: "Not found",
        };
      } else if (code === "INTERNAL_SERVER_ERROR") {
        console.error(code, error.message ?? error.toString());
        set.status = 500;
        return {
          message: "Internal server error",
        };
      } else if (code === "INVALID_COOKIE_SIGNATURE") {
        set.status = 401;
        return {
          message: "Invalid cookie signature",
        };
      } else if (code === "PARSE") {
        set.status = 400;
        return {
          message: "Failed to parse request",
        };
      } else if (code === "UNKNOWN") {
        console.error(code, error.message ?? error.toString());
        set.status = 500;
        return {
          message: "Unknown error",
        };
      } else if (code === "VALIDATION") {
        set.status = 400;
        return error.toResponse();
      }

      console.error("unknown error", code, error);

      return {
        message: "Unknown error",
      };
    })
    .mapResponse(({ response, set }) => {
      const isJson = typeof response === "object";

      const text = isJson
        ? JSON.stringify(response)
        : response?.toString() ?? "";

      set.headers["Content-Encoding"] = "gzip";

      return new Response(Bun.gzipSync(encoder.encode(text)), {
        headers: {
          "Content-Type": `${
            isJson ? "application/json" : "text/plain"
          }; charset=utf-8`,
        },
      });
    })
    .decorate("db", database.db)
    .get("/", async ({ db }) => {
      const {
        rows: [row],
      } = await db.execute<{ total: number }>(sql`select 5 + 20 as total`);
      return `Hello Elysia: ${row.total}`;
    })
    .group("api", (apiR) => {
      return apiR
        .group("users", (usersR) => {
          return usersR
            .post(
              "register",
              async ({ db, jwt, body: { email, password, method } }) => {
                if (method === "email") {
                  let existing = await db.query.users.findFirst({
                    where: (users, { eq }) => eq(users.email, email),
                  });

                  if (existing) {
                    throw new Error("Email already exists");
                  }

                  const passwordHash = await Bun.password.hash(password);

                  const [user] = await db
                    .insert(users)
                    .values({
                      email,
                      password_hash: passwordHash,
                    })
                    .returning({
                      id: users.id,
                    });

                  const accessToken = await jwt.sign(makeJWTPayload(user.id));

                  return {
                    data: {
                      id: user.id,
                      session_token: accessToken,
                    },
                  };
                } else if (method === "apple") {
                  throw new Error("Not implemented");
                } else {
                  throw new Error("Invalid method");
                }
              },
              {
                body: t.Object({
                  method: t.Enum(AuthMethod.Values),
                  email: t.String(),
                  password: t.String(),
                }),
              },
            )
            .post(
              "login",
              async ({ db, jwt, body: { email, password, method } }) => {
                if (method === "email") {
                  const user = await db.query.users.findFirst({
                    where: (users, { eq }) => eq(users.email, email),
                  });

                  if (!user) {
                    throw new Error("User not found");
                  }

                  if (!user.password_hash) {
                    throw new Error("User has no password");
                  }

                  const valid = await Bun.password.verify(
                    password,
                    user.password_hash,
                  );

                  if (!valid) {
                    throw new Error("Invalid password");
                  }

                  const accessToken = await jwt.sign(makeJWTPayload(user.id));

                  return {
                    data: {
                      id: user.id,
                      session_token: accessToken,
                    },
                  };
                } else if (method === "apple") {
                  throw new Error("Not implemented");
                } else {
                  throw new Error("Invalid method");
                }
              },
              {
                body: t.Object({
                  method: t.Enum(AuthMethod.Values),
                  email: t.String(),
                  password: t.String(),
                }),
              },
            );
        })
        .derive(async ({ bearer, jwt, set, db }) => {
          if (!bearer) {
            set.status = 400;
            set.headers["WWW-Authenticate"] =
              `Bearer realm='sign', error="invalid_request"`;

            throw new Error("Unauthorized");
          }

          const verified = await jwt.verify(bearer);
          if (!verified) {
            set.status = 401;
            throw new Error("Unauthorized");
          }

          if (verified.sub === undefined) {
            throw new Error("Invalid token");
          }

          const user = await db.query.users.findFirst({
            where: (users, { eq }) => eq(users.id, verified.sub!),
          });

          if (!user) {
            throw new Error("User not found");
          }

          return {
            userId: user.id,
          };
        })
        .group("plaid-items", (plaidItemsR) => {
          return plaidItemsR.post(
            "link",
            async ({ db, userId, body: { public_token } }) => {
              try {
                const tokenResponse = await plaidClient.itemPublicTokenExchange(
                  {
                    public_token: public_token,
                  },
                );

                const item = await plaidClient.itemGet({
                  access_token: tokenResponse.data.access_token,
                });

                const [itemDb] = await db
                  .insert(plaidItems)
                  .values({
                    plaid_access_token: tokenResponse.data.access_token,
                    plaid_item_id: item.data.item.item_id,
                    plaid_institution_id: z
                      .string()
                      .parse(item.data.item.institution_id),
                    status: PlaidItemStatus.Enum.success,
                    user_id: userId,
                  })
                  .returning()
                  .execute();

                SyncService.syncAccountsAndTransactions(
                  db,
                  plaidClient,
                  ItemId(itemDb.id),
                );

                return {
                  data: {
                    id: itemDb.id,
                    status: itemDb.status,
                    institution_id: itemDb.plaid_institution_id,
                    plaid_item_id: itemDb.plaid_item_id,
                  },
                };
              } catch (error) {
                if (isAxiosError(error)) {
                  console.log(error.response?.data);
                  throw new Error(JSON.stringify(error.response?.data));
                } else {
                  throw error;
                }
              }
            },
            {
              body: t.Object({
                public_token: t.String(),
              }),
            },
          );
        })
        .group("plaid-links", (plaidLinksR) => {
          return plaidLinksR.post("create", async ({ userId }) => {
            try {
              const linkTokenResponse = await plaidClient.linkTokenCreate({
                user: {
                  client_user_id: userId,
                },
                client_name: "Elysia",
                products: [
                  Products.Transactions,
                  Products.Investments,
                  Products.Liabilities,
                ],
                country_codes: [CountryCode.Us],
                language: "en",
              });

              return {
                data: {
                  link_token: linkTokenResponse.data.link_token,
                },
              };
            } catch (error) {
              if (isAxiosError(error)) {
                throw new Error(JSON.stringify(error.response?.data));
              } else {
                throw error;
              }
            }
          });
        });
    })
    .listen({
      hostname: "0.0.0.0",
      port: 8080,
    });

  console.log(
    `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`,
  );
}

main();
