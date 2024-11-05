package api.repositories

import api.common.AppError
import api.common.Logger
import api.models.FireProfile
import api.models.Profile
import api.models.RiskProfile
import api.models.UserId
import io.circe.parser.*
import scalasql.*
import scalasql.PostgresDialect.*
import scalikejdbc.*

import java.time.Instant
import java.time.LocalDate
import java.util.UUID
import scala.util.Failure
import scala.util.Success
import scala.util.Try

case class ProfileTable[T[_]](
    id: T[UUID],
    date_of_birth: T[Option[LocalDate]],
    retirement_age: T[Option[Int]],
    risk_profile: T[Option[String]],
    fire_profile: T[Option[String]],
    deleted_at: T[Option[Instant]]
)

object ProfileTable extends Table[ProfileTable]() {
  override def tableName: String = "profiles"
}

object ProfileRepository:
  def getProfiles(): Either[AppError.DatabaseError, List[Profile]] = Try(
    DB.readOnly { implicit session =>
      sql"select id, date_of_birth, retirement_age, risk_profile, fire_profile, deleted_at from profiles"
        .map(rs =>
          Profile(
            id = UUID.fromString(rs.string("id")),
            dateOfBirth = rs.localDateOpt("date_of_birth"),
            retirementAge = rs.intOpt("retirement_age"),
            riskProfile = rs
              .stringOpt("risk_profile")
              .flatMap(s => decode[RiskProfile](s).toOption),
            fireProfile = rs
              .stringOpt("fire_profile")
              .flatMap(s => decode[FireProfile](s).toOption),
            deletedAt = rs.timestampOpt("deleted_at").map(_.toInstant)
          )
        )
        .list
        .apply()
    }
  ).toEither.left.map(ex => AppError.DatabaseError(ex.getMessage))

  def getProfile(userId: UserId)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Profile] =
    val query =
      ProfileTable.select.filter(r => r.id === UserId.toUUID(userId))

    val result = Try(dbClient.transaction: db =>
      db.run(query).headOption)

    result match
      case Success(maybeProfile) =>
        maybeProfile match
          case Some(p) =>
            Right(
              Profile(
                id = p.id,
                dateOfBirth = p.date_of_birth,
                retirementAge = p.retirement_age,
                riskProfile =
                  p.risk_profile.flatMap(f => decode[RiskProfile](f).toOption),
                fireProfile =
                  p.fire_profile.flatMap(f => decode[FireProfile](f).toOption),
                deletedAt = p.deleted_at
              )
            )
          case None => Left(AppError.NotFoundError("Profile not found"))
      case Failure(ex) =>
        Left(AppError.DatabaseError(ex.getMessage()))

  case class ProfileUpdate(
      userId: UserId,
      age: Option[Int],
      dateOfBirth: Option[LocalDate],
      riskProfile: Option[RiskProfile],
      fireProfile: Option[FireProfile],
      retirementAge: Option[Int]
  )

  def updateProfile(
      profileUpdate: ProfileUpdate
  ): Either[AppError.DatabaseError, Int] = Try(
    DB localTx { implicit session =>
      Logger.root.info(s"Updating profile: ${profileUpdate}")
      val setClause =
        Seq(
          profileUpdate.age.map(age => sqls"age = $age"),
          profileUpdate.dateOfBirth.map(dob => sqls"date_of_birth = $dob"),
          profileUpdate.retirementAge.map(ra => sqls"retirement_age = $ra"),
          profileUpdate.riskProfile.map(rp => sqls"risk_profile = ${rp.value}"),
          profileUpdate.fireProfile.map(fp => sqls"fire_profile = ${fp.value}")
        ).flatten

      sql"""
                update profiles
                set $setClause
                where id = ${profileUpdate.userId}
            """.update.apply()
    }
  ).toEither.left.map(ex => AppError.DatabaseError(ex.getMessage))
