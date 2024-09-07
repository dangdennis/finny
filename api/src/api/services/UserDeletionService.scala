package api.services

import api.common.AppError
import api.common.Logger
import api.models.Profile
import api.models.UserId
import api.repositories.AccountRepository
import api.repositories.PlaidItemRepository
import api.repositories.ProfileRepository
import api.repositories.TransactionRepository
import scalikejdbc.*

import scala.util.Try

object UserDeletionService:
  def deleteUserEverything(userId: UserId): Either[AppError, Boolean] =
    ProfileRepository
      .getProfile(userId)
      .flatMap(userOpt =>
        userOpt match
          case Some(user) =>
            deleteItemsAndProfile(user)
          case None =>
            Logger.root.error(s"User with id $userId not found")
            Left(AppError.NotFoundError(s"User with id $userId not found"))
      )

  private def deleteItemsAndProfile(user: Profile): Either[AppError, Boolean] =
    for
      items <- PlaidItemRepository.getItemsByUserId(user.id)
      _ = items.foreach { item =>
        Try(
          DB.localTx { implicit session =>
            TransactionRepository.deleteTransactionsByItemId(item.id, user.id)
            AccountRepository.deleteAccountsByItemId(item.id, user.id)
            PlaidItemRepository.deleteItemById(item.id, user.id)
          }
        ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))
      }
      _ <- Try(
        DB.autoCommit { implicit session =>
          sql"delete from goals where user_id = ${user.id}".update.apply()
          sql"delete from assets where user_id = ${user.id}".update.apply()
          sql"delete from profiles where id = ${user.id}".update.apply()
        }
      ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))
      deletionRes <- AuthService.deleteUser(user.id, shouldSoftDelete = false)
    yield deletionRes
