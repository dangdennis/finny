import FluentPostgresDriver
import Foundation
import Vapor

struct PowerSync {}

struct DatabaseConfiguration {
    let hostname: String
    let port: Int
    let database: String
    let user: String
    let password: String
    let tls: TLSConfiguration
}

func applyDatabaseConfig(app: Application) throws {
    guard let databaseUrl = Environment.get("DATABASE_URL") else {
        fatalError("DATABASE_URL environment variable not set")
    }

    if app.environment == .production {
        let config = try makeProdConfig(
            env: app.environment,
            url: databaseUrl
        )
        app.databases.use(
            DatabaseConfigurationFactory.postgres(
                configuration: SQLPostgresConfiguration(
                    hostname: config.hostname,
                    port: config.port,
                    username: config.user,
                    password: config.password,
                    database: config.database,
                    tls: try .require(NIOSSLContext(configuration: config.tls))
                )
            ),
            as: .psql
        )
    } else {
        app.databases.use(
            DatabaseConfigurationFactory.postgres(
                configuration: try SQLPostgresConfiguration(
                    url: databaseUrl
                )
            ),
            as: .psql
        )
    }
}

private func makeProdConfig(env: Environment, url: String) throws -> DatabaseConfiguration
{
    guard let url = URL(string: url),
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
        let host = components.host,
        let port = components.port,
        let user = components.user,
        let password = components.password
    else {
        throw Abort(.internalServerError, reason: "Invalid database URL")
    }

    let database = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    let tls = try {
        let certData = Data(supabaseCert.utf8)
        let certificate = try NIOSSLCertificate(bytes: [UInt8](certData), format: .pem)
        var tlsConfiguration = TLSConfiguration.makeClientConfiguration()
        tlsConfiguration.certificateVerification = .fullVerification
        tlsConfiguration.trustRoots = .certificates([certificate])
        return tlsConfiguration
    }()

    return DatabaseConfiguration(
        hostname: host,
        port: port,
        database: database,
        user: user,
        password: password,
        tls: tls
    )
}

let supabaseCert =
    """
    -----BEGIN CERTIFICATE-----
    MIIDxDCCAqygAwIBAgIUbLxMod62P2ktCiAkxnKJwtE9VPYwDQYJKoZIhvcNAQEL
    BQAwazELMAkGA1UEBhMCVVMxEDAOBgNVBAgMB0RlbHdhcmUxEzARBgNVBAcMCk5l
    dyBDYXN0bGUxFTATBgNVBAoMDFN1cGFiYXNlIEluYzEeMBwGA1UEAwwVU3VwYWJh
    c2UgUm9vdCAyMDIxIENBMB4XDTIxMDQyODEwNTY1M1oXDTMxMDQyNjEwNTY1M1ow
    azELMAkGA1UEBhMCVVMxEDAOBgNVBAgMB0RlbHdhcmUxEzARBgNVBAcMCk5ldyBD
    YXN0bGUxFTATBgNVBAoMDFN1cGFiYXNlIEluYzEeMBwGA1UEAwwVU3VwYWJhc2Ug
    Um9vdCAyMDIxIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqQXW
    QyHOB+qR2GJobCq/CBmQ40G0oDmCC3mzVnn8sv4XNeWtE5XcEL0uVih7Jo4Dkx1Q
    DmGHBH1zDfgs2qXiLb6xpw/CKQPypZW1JssOTMIfQppNQ87K75Ya0p25Y3ePS2t2
    GtvHxNjUV6kjOZjEn2yWEcBdpOVCUYBVFBNMB4YBHkNRDa/+S4uywAoaTWnCJLUi
    cvTlHmMw6xSQQn1UfRQHk50DMCEJ7Cy1RxrZJrkXXRP3LqQL2ijJ6F4yMfh+Gyb4
    O4XajoVj/+R4GwywKYrrS8PrSNtwxr5StlQO8zIQUSMiq26wM8mgELFlS/32Uclt
    NaQ1xBRizkzpZct9DwIDAQABo2AwXjALBgNVHQ8EBAMCAQYwHQYDVR0OBBYEFKjX
    uXY32CztkhImng4yJNUtaUYsMB8GA1UdIwQYMBaAFKjXuXY32CztkhImng4yJNUt
    aUYsMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBAB8spzNn+4VU
    tVxbdMaX+39Z50sc7uATmus16jmmHjhIHz+l/9GlJ5KqAMOx26mPZgfzG7oneL2b
    VW+WgYUkTT3XEPFWnTp2RJwQao8/tYPXWEJDc0WVQHrpmnWOFKU/d3MqBgBm5y+6
    jB81TU/RG2rVerPDWP+1MMcNNy0491CTL5XQZ7JfDJJ9CCmXSdtTl4uUQnSuv/Qx
    Cea13BX2ZgJc7Au30vihLhub52De4P/4gonKsNHYdbWjg7OWKwNv/zitGDVDB9Y2
    CMTyZKG3XEu5Ghl1LEnI3QmEKsqaCLv12BnVjbkSeZsMnevJPs1Ye6TjjJwdik5P
    o/bKiIz+Fq8=
    -----END CERTIFICATE-----
    """
