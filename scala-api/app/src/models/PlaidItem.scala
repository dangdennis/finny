package app.models

case class PlaidItem(
    id: String,
    userId: String,
    plaidAccessToken: String,
    plaidItemId: String,
    plaidInstitutionId: String,
    status: String,
    transactionsCursor: Option[String]
)
