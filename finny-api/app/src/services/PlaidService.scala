package app.services

import com.plaid.client.ApiClient
import com.plaid.client.model.Institution
import com.plaid.client.request.PlaidApi
import upickle.default._

import scala.collection.JavaConverters._

def makePlaidClient() = {
  val apiClient = new ApiClient(
    Map(
      "clientId" -> "661ac9375307a3001ba2ea46",
      "secret" -> "57ebac97c0bcf92f35878135d68793",
      "plaidVersion" -> "2020-09-14"
    ).asJava
  )

  apiClient.setPlaidAdapter(ApiClient.Sandbox)

  apiClient.createService(classOf[PlaidApi])
}

case class InstitutionWrapper(id: String, name: String, url: Option[String])
object InstitutionWrapper {
  implicit val rw: ReadWriter[InstitutionWrapper] = macroRW

  def fromPlaidInstitution(inst: Institution): InstitutionWrapper = {
    InstitutionWrapper(
      id = inst.getInstitutionId,
      name = inst.getName,
      url = Option(inst.getUrl)
    )
  }
}
