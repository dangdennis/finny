import { Elysia, t } from "elysia";
import { Database } from "./db";
import { sql } from "drizzle-orm";
import { users } from "./schema";
import { z } from "zod";
import elysiaJwt, { JWTPayloadSpec } from "@elysiajs/jwt";

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
    .use(
      elysiaJwt({
        name: "jwt",
        secret: "Dennis von Baron Whaler",
        exp: "7d",
      }),
    )
    .decorate("db", database.db)
    .get("/", async ({ db }) => {
      const {
        rows: [row],
      } = await db.execute<{ total: number }>(sql`select 5 + 20 as total`);
      return `Hello Elysia: ${row.total}`;
    })
    .group("api", (apiR) => {
      return apiR.group("users", (usersR) => {
        return usersR
          .post(
            "register",
            async ({ db, jwt, body: { email, password, method } }) => {
              if (method === "email") {
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
