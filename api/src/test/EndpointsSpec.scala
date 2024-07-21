// package app

// import app.Endpoints.*
// import org.scalatest.EitherValues
// import org.scalatest.flatspec.AnyFlatSpec
// import org.scalatest.matchers.should.Matchers
// import sttp.client3.*
// import sttp.client3.testing.SttpBackendStub
// import sttp.tapir.server.stub.TapirStubInterpreter

// class EndpointsSpec extends AnyFlatSpec, Matchers, EitherValues:

//     it should "return hello world" in {
//         // given
//         val endpoints = Endpoints.createEndpoints()
//         val backendStub = TapirStubInterpreter(SttpBackendStub.synchronous)
//             .whenServerEndpointRunLogic(endpoints.indexServerEndpoint)
//             .backend()

//         // when
//         val response = basicRequest
//             .get(uri"http://test.com/")
//             .send(backendStub)

//         // then
//         response.body.value shouldBe "Hello world!"
//     }
