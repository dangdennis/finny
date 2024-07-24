package api.services

import api.common.Logger
import api.models.UserId
import api.repositories.AccountRepository
import api.repositories.PlaidItemRepository
import api.repositories.ProfileRepository
import api.repositories.TransactionRepository
import scalikejdbc.*

import scala.util.Failure
import scala.util.Success
import scala.util.Try

object UserDeletionService:
    def deleteUserEverything(userId: UserId): Either[Throwable, Boolean] =
        (
            for
                profileOpt <- Try(ProfileRepository.getProfileByUserId(userId))
                result <-
                    profileOpt match
                        case Success(profile) =>
                            profile match
                                case Some(profile) =>
                                    deleteItemsAndProfile(userId)
                                case None =>
                                    Success(true)
                        case Failure(exc) =>
                            Logger.root.error(s"Failed to delete user with ID ${userId}. ${exc.getMessage}")
                            Success(false)
            yield result
        ).toEither

    private def deleteItemsAndProfile(userId: UserId): Try[Boolean] =
        for
            items <- Try(PlaidItemRepository.getItemsByUserId(userId))
            _ <- Try(
                items.map { items =>
                    items.foreach { item =>
                        DB.localTx { implicit session =>
                            TransactionRepository.deleteTransactionsByItemId(item.id)
                            AccountRepository.deleteAccountsByItemId(item.id)
                            PlaidItemRepository.deleteItemById(item.id)
                        }
                    }
                }
            )
            _ <- Try(
                DB.autoCommit { implicit session =>
                    sql"delete from goals where user_id = $userId".update.apply()
                    sql"delete from assets where user_id = $userId".update.apply()
                    sql"delete from profiles where id = $userId".update.apply()
                }
            )
            deletionRes <- Try(
                AuthService.deleteUser(userId, shouldSoftDelete = false) match
                    case Right(result) =>
                        result
                    case Left(error) =>
                        throw new Exception(error)
            )
        yield deletionRes
