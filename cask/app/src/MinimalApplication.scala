package app

import scala.collection.JavaConverters._
import com.plaid.client.ApiClient;
import com.plaid.client.request.PlaidApi;
import com.plaid.client.model.{InstitutionsGetRequest, Institution}
import scala.concurrent.Future
import com.plaid.client.model.InstitutionsGetResponse
import scala.concurrent.Await
import com.plaid.client.model.CountryCode
import upickle.default._

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

object MinimalApplication extends cask.MainRoutes {
  override def port: Int = 8080
  override def host: String = "0.0.0.0"

  @cask.get("/")
  def hello() = {
    val futureResponse = Future {
      val plaidClient = makePlaidClient()

      val institutionsReq = plaidClient.institutionsGet(
        new InstitutionsGetRequest()
          .count(500)
          .addCountryCodesItem(CountryCode.US)
          .offset(0)
      )

      institutionsReq.execute()
    }

    val result = for {
      response <- futureResponse
    } yield {
      if (response.isSuccessful) {
        Right(response.body())
      } else {
        Left(response.errorBody().string())
      }
    }

    val institutions =
      Await.result(result, scala.concurrent.duration.Duration(10, "seconds"))

    institutions match {
      case Right(institutions) =>
        val insts = institutions.getInstitutions.asScala.map { inst =>
          InstitutionWrapper.fromPlaidInstitution(inst)
        }.toList

        cask.Response(
          write(insts),
          statusCode = 200,
          headers = Seq("Content-Type" -> "application/json")
        )
      case Left(error) =>
        cask.Response(s"Error: $error", statusCode = 500)
    }
  }

  @cask.post("/do-thing")
  def doThing(request: cask.Request) = {
    request.text().reverse
  }

  // Main method to start the application and print the host and port
  override def main(args: Array[String]): Unit = {
    println(s"Server is running on http://$host:$port")
    super.initialize()
    super.main(args)
  }
}
