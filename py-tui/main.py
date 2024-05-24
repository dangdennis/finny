from textual.app import App, ComposeResult
from textual.widgets import Header, Footer
import duckdb
from schema import schema
import plaid
from plaid.api import plaid_api
from plaid.model.item_public_token_exchange_request import ItemPublicTokenExchangeRequest
from plaid.model.item_public_token_exchange_response import ItemPublicTokenExchangeResponse
from dotenv import load_dotenv
import os
import certifi
import urllib3

# Set the environment variable to the certifi certificate bundle
os.environ['SSL_CERT_FILE'] = certifi.where()


def main() -> None:
    load_dotenv()

    api_client = plaid.ApiClient(plaid.Configuration(
        host=plaid.Environment.Sandbox,
        api_key={
            "clientId": "x",
            "secret": "x",
        },
    ))
    client = plaid_api.PlaidApi(api_client)
    exchange_request: ItemPublicTokenExchangeResponse = client.item_public_token_exchange(
        ItemPublicTokenExchangeRequest(
            public_token="public-sandbox-e71f3b04-6697-44de-bd50-fb538bc2c8ea",
        )
    )
    print(f"access_token {exchange_request.access_token}")


    db = duckdb.connect(database=":memory:")
    db.execute(schema)
    print(db.execute("SELECT 42").fetchall())
    db.query("select * from users").show()

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
