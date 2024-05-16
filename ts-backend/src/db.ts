import { drizzle } from 'drizzle-orm/node-postgres';
import { Client } from 'pg';
import * as schema from './schema'

export const client = new Client({
    connectionString: process.env.DATABASE_URL,
});

// { schema } is used for relational queries
export const db = drizzle(client, { schema });

export class Database {
    db: typeof db
    client: Client

    constructor() {
        this.client = client
        this.db = db
    }

    async connect() {
        await this.client.connect()
    }
}
