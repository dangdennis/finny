import { Elysia } from "elysia";
import { Database } from '../drizzle/db'
import { sql } from "drizzle-orm";

async function main() {
  const database = new Database()
  await database.connect()

  const app = new Elysia()
    .decorate("db", database.db)
    .get("/", async ({ db
    }) => {
      const { rows: [row] } = await db.execute<{ total: number }>(sql`select 5 + 5 as total`)
      return `Hello Elysia: ${row.total}`
    })
    .listen(8080);

  console.log(
    `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`,
  );
}


main()