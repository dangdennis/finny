package api.repositories

import api.common.AppError
import api.models.Profile
import api.models.UserId
import scalikejdbc.*

import java.util.UUID
import scala.util.Try
import java.time.LocalDate
import io.circe.parser.decode
import api.models.RiskProfile
import api.models.FireProfile
import api.common.Logger

object ProfileRepository:
    def getProfiles(): Either[AppError.DatabaseError, List[Profile]] = Try(
        DB.readOnly { implicit session =>
            sql"select id, age, date_of_birth, retirement_age, risk_profile, fire_profile, deleted_at from profiles"
                .map(rs =>
                    Profile(
                        id = UUID.fromString(rs.string("id")),
                        age = rs.intOpt("age"),
                        dateOfBirth = rs.localDateOpt("date_of_birth"),
                        retirementAge = rs.intOpt("retirement_age"),
                        riskProfile = rs.stringOpt("risk_profile").flatMap(s => decode[RiskProfile](s).toOption),
                        fireProfile = rs.stringOpt("fire_profile").flatMap(s => decode[FireProfile](s).toOption),
                        deletedAt = rs.timestampOpt("deleted_at").map(_.toInstant)
                    )
                )
                .list
                .apply()
        }
    ).toEither.left.map(ex => AppError.DatabaseError(ex.getMessage))

    def getProfile(userId: UserId): Either[AppError.DatabaseError, Option[Profile]] = Try(
        DB.readOnly { implicit session =>
            sql"select id, age, date_of_birth, retirement_age, risk_profile, fire_profile, deleted_at from profiles where id = ${userId}"
                .map(rs =>
                    Profile(
                        id = UUID.fromString(rs.string("id")),
                        age = rs.intOpt("age"),
                        dateOfBirth = rs.localDateOpt("date_of_birth"),
                        retirementAge = rs.intOpt("retirement_age"),
                        riskProfile = rs.stringOpt("risk_profile").flatMap(s => decode[RiskProfile](s).toOption),
                        fireProfile = rs.stringOpt("fire_profile").flatMap(s => decode[FireProfile](s).toOption),
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
        riskProfile: Option[RiskProfile],
        fireProfile: Option[FireProfile],
        retirementAge: Option[Int]
    )

    def updateProfile(profileUpdate: ProfileUpdate): Either[AppError.DatabaseError, Int] = Try(
        DB localTx { implicit session =>
            Logger.root.info(s"Updating profile: ${profileUpdate}")
            val setClause =
                Seq(
                    profileUpdate.age.map(age => sqls"age = $age"),
                    profileUpdate.dateOfBirth.map(dob => sqls"date_of_birth = $dob"),
                    profileUpdate.retirementAge.map(ra => sqls"retirement_age = $ra"),
                    profileUpdate.riskProfile.map(rp => sqls"risk_profile = ${(RiskProfile.toString(rp))}"),
                    profileUpdate.fireProfile.map(fp => sqls"fire_profile = ${FireProfile.toString(fp)}")
                ).flatten

            sql"""
                update profiles
                set $setClause
                where id = ${profileUpdate.userId}
            """.update.apply()
        }
    ).toEither.left.map(ex => AppError.DatabaseError(ex.getMessage))
