
package app

import app.Endpoints._
import org.scalatest.EitherValues
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import sttp.client3._
import sttp.client3.testing.SttpBackendStub
import sttp.tapir.server.stub.TapirStubInterpreter

class EndpointsSpec extends AnyFlatSpec with Matchers with EitherValues:

  it should "return hello world" in {
    // given
    val backendStub = TapirStubInterpreter(SttpBackendStub.synchronous)
      .whenServerEndpointRunLogic(indexServerEndpoint)
      .backend()

    // when
    val response = basicRequest
      .get(uri"http://test.com/")
      .send(backendStub)

    // then
    response.body.value shouldBe "Hello world!"
  }
