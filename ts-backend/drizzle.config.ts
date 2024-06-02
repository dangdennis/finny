import { defineConfig } from "drizzle-kit";
import { z } from "zod";

export default defineConfig({
    schemaFilter: ["public"],
    dialect: "postgresql",
    schema: "./src/schema.ts",
    out: "./drizzle",
    dbCredentials: {
        url: z.string().parse(process.env.DATABASE_URL),
    }
});