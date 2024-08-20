package api.repositories

import api.common.AppError
import api.models.Profile
import api.models.UserId
import scalikejdbc.*

import java.util.UUID
import scala.util.Try
import java.time.LocalDate

object ProfileRepository:
    def getProfiles(): Either[AppError.DatabaseError, List[Profile]] = Try(
        DB.readOnly { implicit session =>
            sql"select id, age, date_of_birth, retirement_age, deleted_at from profiles"
                .map(rs =>
                    Profile(
                        id = UUID.fromString(rs.string("id")),
                        age = rs.intOpt("age"),
                        dateOfBirth = rs.localDateOpt("date_of_birth"),
                        retirementAge = rs.intOpt("retirement_age"),
                        deletedAt = rs.timestampOpt("deleted_at").map(_.toInstant)
                    )
                )
                .list
                .apply()
        }
    ).toEither.left.map(ex => AppError.DatabaseError(ex.getMessage))

    def getProfile(userId: UserId): Either[AppError.DatabaseError, Option[Profile]] = Try(
        DB.readOnly { implicit session =>
            sql"select id, age, date_of_birth, retirement_age, deleted_at from profiles where id = ${userId}"
                .map(rs =>
                    Profile(
                        id = UUID.fromString(rs.string("id")),
                        age = rs.intOpt("age"),
                        dateOfBirth = rs.localDateOpt("date_of_birth"),
                        retirementAge = rs.intOpt("retirement_age"),
                        deletedAt = rs.timestampOpt("deleted_at").map(_.toInstant)
                    )
                )
                .single
                .apply()
        }
    ).toEither.left.map(ex => AppError.DatabaseError(ex.getMessage))

    case class ProfileUpdate(
        userId: UserId,
        age: Option[Int],
        dateOfBirth: Option[LocalDate],
        retirementAge: Option[Int]
    )

    def updateProfile(profileUpdate: ProfileUpdate): Either[AppError.DatabaseError, Int] = Try(
        DB localTx { implicit session =>
            val setClause = Seq(
                profileUpdate.age.map(age => sqls"age = $age"),
                profileUpdate.dateOfBirth.map(dob => sqls"date_of_birth = $dob"),
                profileUpdate.retirementAge.map(ra => sqls"retirement_age = $ra")
            ).flatten

            sql"""
                update profiles 
                set $setClause
                where id = ${profileUpdate.userId}
            """.update.apply()
        }
    ).toEither.left.map(ex => AppError.DatabaseError(ex.getMessage))