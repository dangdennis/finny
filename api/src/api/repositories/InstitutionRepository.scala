package api.repositories

import com.plaid.client.model.{Institution as PlaidInstitution}
import api.models.Institution
import scalikejdbc.*
import scala.util.Try
import api.common.AppError

object InstitutionRepository:
    def createInstitution(institution: PlaidInstitution)(using session: DBSession): Either[AppError, Institution] =
        val result = Try(
            sql"INSERT INTO institutions (institution_id, name, oauth, logo, primary_color, url, country_codes, dtc_numbers, products, routing_numbers) VALUES (${institution
                    .institutionId}, ${institution.name}, ${institution.oauth}, ${institution
                    .logo}, ${institution.primaryColor}, ${institution.url}, ${institution.countryCodes}, ${institution
                    .dtcNumbers}, ${institution.products}, ${institution.routingNumbers})".update.apply()
        ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

        for
            _ <- result
            institutionId <- Option(institution.getInstitutionId())
                .toRight(AppError.NotFoundError("Institution not found"))
            institution <- getInstitutionById(institutionId)
                .flatMap(_.toRight(AppError.NotFoundError("Institution not found after creation")))
        yield institution

    def getInstitutionById(
        institutionId: String
    )(using session: DBSession): Either[AppError.DatabaseError, Option[Institution]] = Try(
        sql"SELECT * FROM institutions WHERE institution_id = ${institutionId}"
            .map(rs =>
                Institution(
                    institutionId = rs.string("institution_id"),
                    name = rs.string("name"),
                    oauth = rs.boolean("oauth"),
                    logo = rs.stringOpt("logo"),
                    primaryColor = rs.stringOpt("primary_color"),
                    url = rs.stringOpt("url"),
                    countryCodes = List(), // rs.array("country_codes"),
                    dtcNumbers = List(), // rs.stringArray("dtc_numbers"),
                    products = List(), // rs.stringArray("products"),
                    routingNumbers = List() // rs.stringArray("routing_numbers")
                )
            )
            .single
            .apply()
    ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))
