import bearer from "@elysiajs/bearer";
import elysiaJwt from "@elysiajs/jwt";
import { sql } from "drizzle-orm";
import { Elysia, t } from "elysia";
import { Configuration, CountryCode, PlaidApi, PlaidEnvironments } from "plaid";
import { z } from "zod";
import { Database } from "./db";
import { users } from "./schema";

const configuration = new Configuration({
  basePath: PlaidEnvironments.sandbox,
  baseOptions: {
    headers: {
      "PLAID-CLIENT-ID": process.env.PLAID_CLIENT_ID,
      "PLAID-SECRET": process.env.PLAID_SECRET_SANDBOX,
      "Plaid-Version": "2020-09-14",
    },
  },
});

const encoder = new TextEncoder();

const plaidClient = new PlaidApi(configuration);

const AuthMethod = z.enum(["email", "apple"]);

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
        console.error(code, error);
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
        console.error(code, error);
        set.status = 500;
        return {
          message: "Unknown error",
        };
      } else if (code === "VALIDATION") {
        set.status = 400;
        return error.toResponse();
      }

      console.error(code, error);

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
                      user_id: user.id,
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
                      user_id: user.id,
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
        .guard(
          {
            async beforeHandle({ bearer, set, jwt }) {
              if (!bearer) {
                set.status = 400;
                set.headers["WWW-Authenticate"] =
                  `Bearer realm='sign', error="invalid_request"`;

                return "Unauthorized";
              }

              const verified = await jwt.verify(bearer);
              if (!verified) {
                set.status = 401;
                return "Unauthorized";
              }
            },
          },
          (protectedApiR) => {
            return protectedApiR
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
                    const tokenResponse =
                      await plaidClient.itemPublicTokenExchange({
                        public_token: public_token,
                      });

                    console.log("tokenResponse", tokenResponse.data);

                    const item = await plaidClient.itemGet({
                      access_token: tokenResponse.data.access_token,
                    });

                    console.log(item.data);

                    const institution = await plaidClient.institutionsGetById({
                      institution_id: item.data.item.institution_id!,
                      country_codes: [CountryCode.Us],
                    });

                    console.log(institution.data);

                    return {
                      data: {},
                    };
                  },
                  {
                    body: t.Object({
                      public_token: t.String(),
                    }),
                  },
                );
              });
          },
        );
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
