import APISchema
import Plaid
import Vapor

struct PlaidLinkController: Sendable {
    let plaidLinkService: PlaidLinkService

    func createLinkToken(req: Request) async throws -> LinkTokenResponse {
        let userID = try Auth.getUserID(from: req)
        let linkToken = try await plaidLinkService.createLinkToken(userID: userID)
        return .init(data: .init(linkToken: linkToken.link_token))
    }

    func createLinkEvent(req: Request) async throws -> HTTPStatus {
        try PlaidLinkEventCreateRequest.validate(content: req)
        let userID = try Auth.getUserID(from: req)
        let event = try req.content.decode(PlaidLinkEvent.self)
        guard let eventType = PlaidLinkStatus(rawValue: event.type) else {
            throw Abort(.badRequest, reason: "Invalid event type")
        }
        try await plaidLinkService.createLinkEvent(
            userID: userID,
            type: eventType,
            linkSessionID: event.linkSessionID,
            requestID: event.requestID,
            errorType: event.errorType,
            errorCode: event.errorCode,
            status: event.status
        )
        return .ok
    }
}

extension APISchema.PlaidLinkEventCreateRequest: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add(
            "type",
            as: String.self,
            is: .in(
                PlaidLinkStatus.success.rawValue,
                PlaidLinkStatus.error.rawValue
            )
        )
    }
}
