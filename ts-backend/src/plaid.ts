import { Configuration, PlaidApi, PlaidEnvironments } from "plaid";
import { z } from "zod";

const plaidEnvSchema = z.enum(["sandbox", "development", "production"]);

const PLAID_CLIENT_ID = z.string().parse(process.env.PLAID_CLIENT_ID);
const PLAID_ENV = plaidEnvSchema.parse(process.env.PLAID_ENV);

let PLAID_SECRET: string;
let plaidBasePath: string;
export let PLAID_REDIRECT_URI: string;
switch (PLAID_ENV) {
  case "sandbox":
    PLAID_SECRET = z.string().parse(process.env.PLAID_SECRET_SANDBOX);
    PLAID_REDIRECT_URI = z.string().parse(process.env.PLAID_SANDBOX_REDIRECT_URI);
    plaidBasePath = PlaidEnvironments.sandbox;
    break;
  case "development":
    PLAID_SECRET = z.string().parse(process.env.PLAID_SECRET_DEVELOPMENT);
    PLAID_REDIRECT_URI = z.string().parse(process.env.PLAID_DEVELOPMENT_REDIRECT_URI);
    plaidBasePath = PlaidEnvironments.development;
    break;
  case "production":
    PLAID_SECRET = z.string().parse(process.env.PLAID_SECRET_PRODUCTION);
    PLAID_REDIRECT_URI = z.string().parse(process.env.PLAID_DEVELOPMENT_REDIRECT_URI);
    plaidBasePath = PlaidEnvironments.production;
    break;
}

const configuration = new Configuration({
  basePath: plaidBasePath,
  baseOptions: {
    headers: {
      "PLAID-CLIENT-ID": PLAID_CLIENT_ID,
      "PLAID-SECRET": PLAID_SECRET,
      "Plaid-Version": "2020-09-14",
    },
  },
});

export const plaidClient = new PlaidApi(configuration);
