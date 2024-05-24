import time
from textual.app import App, ComposeResult
from textual.widgets import Header, Footer
import duckdb
from schema import schema
import plaid
from plaid.api import plaid_api
from plaid.model.item_public_token_exchange_request import (
    ItemPublicTokenExchangeRequest,
)
from plaid.model.item_public_token_exchange_response import (
    ItemPublicTokenExchangeResponse,
)
from plaid.model.sandbox_public_token_create_request import (
    SandboxPublicTokenCreateRequest,
)
from plaid.model.sandbox_public_token_create_response import (
    SandboxPublicTokenCreateResponse,
)
from plaid.model.products import Products
from plaid.model.transactions_sync_request import TransactionsSyncRequest
from plaid.model.transactions_sync_response import TransactionsSyncResponse
from dotenv import load_dotenv
import os
import certifi

# Set the environment variable to the certifi certificate bundle
os.environ["SSL_CERT_FILE"] = certifi.where()


def main() -> None:
    load_dotenv()

    api_client = plaid.ApiClient(
        plaid.Configuration(
            host=plaid.Environment.Sandbox,
            api_key={
                "clientId": "x",
                "secret": "x",
            },
        )
    )
    plaid_client = plaid_api.PlaidApi(api_client)
    public_token_resp: SandboxPublicTokenCreateResponse = (
        plaid_client.sandbox_public_token_create(
            SandboxPublicTokenCreateRequest(
                institution_id="ins_20", initial_products=[
                    Products("transactions")
                ]
            )
        )
    )
    print(f"public_token {public_token_resp.public_token}")
    exchange_public_token_resp: ItemPublicTokenExchangeResponse = (
        plaid_client.item_public_token_exchange(
            ItemPublicTokenExchangeRequest(
                public_token=public_token_resp.public_token,
            )
        )
    )

    time.sleep(10)
    
    print(f"access_token {exchange_public_token_resp.access_token}")
    transactions_resp: TransactionsSyncResponse = plaid_client.transactions_sync(TransactionsSyncRequest(
        access_token=exchange_public_token_resp.access_token,
        count=500
    ))

    print(transactions_resp)

    print(transactions_resp.accounts)
    print(transactions_resp.added)
    print(transactions_resp.modified)
    print(transactions_resp.removed)
    print(transactions_resp.has_more)
    print(transactions_resp.next_cursor)

    # db = duckdb.connect(database=":memory:")
    # db.execute(schema)
    # print(db.execute("SELECT 42").fetchall())
    # db.query("select * from users").show()

    # app = Finny()
    # app.run()


class Finny(App):
    """A Textual app to manage stopwatches."""

    BINDINGS = [("d", "toggle_dark", "Toggle dark mode")]

    def compose(self) -> ComposeResult:
        """Create child widgets for the app."""
        yield Header()
        yield Footer()

    def action_toggle_dark(self) -> None:
        """An action to toggle dark mode."""
        self.dark = not self.dark


if __name__ == "__main__":
    main()
