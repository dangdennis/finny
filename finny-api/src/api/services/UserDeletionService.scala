package api.services

import api.common.AppError
import api.common.Logger
import api.models.Profile
import api.models.UserId
import api.repositories.AccountRepository
import api.repositories.GoalRepository
import api.repositories.PlaidItemRepository
import api.repositories.ProfileRepository
import api.repositories.TransactionRepository
import scalikejdbc.*

import scala.util.Try
import scalasql.core.DbClient

object UserDeletionService:
  def deleteUserEverything(userId: UserId)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Boolean] =
    ProfileRepository
      .getProfile(userId) match
      case Left(AppError.NotFoundError(msg)) =>
        Logger.root.error(s"User with id $userId not found", msg)
        Left(AppError.NotFoundError(s"User with id $userId not found"))
      case Right(profile) =>
        deleteItemsAndProfile(profile)

  private def deleteItemsAndProfile(user: Profile): Either[AppError, Boolean] =
    for
      items <- PlaidItemRepository.getItemsByUserId(user.id)
      _ = items.foreach { item =>
        PlaidService
          .deleteItem(PlaidService.makePlaidClientFromEnv(), item.id, user.id)
          .map { _ =>
            Try:
              DB.localTx { implicit session =>
                val accounts =
                  AccountRepository.getAccounts(user.id).getOrElse(List())
                sql"delete from investment_holdings where account_id IN (${accounts
                    .map(_.id)})".update.apply()
                sql"delete from investment_holdings_daily where account_id IN (${accounts
                    .map(_.id)})".update.apply()
                val goals =
                  GoalRepository.getGoalsByUserId(user.id).getOrElse(List())
                sql"delete from goal_accounts where goal_id IN (${goals.map(_.id)})".update
                  .apply()
                sql"DELETE FROM account_balances WHERE account_id IN (${accounts
                    .map(_.id)})".update.apply()
                TransactionRepository.deleteTransactionsByItemId(
                  item.id,
                  user.id
                )
                AccountRepository.deleteAccountsByItemId(item.id, user.id)
                PlaidItemRepository.deleteItemById(item.id, user.id)
              }
            .toEither.left
              .map(e => AppError.DatabaseError(e.getMessage))
          }
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
