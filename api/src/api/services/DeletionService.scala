package api.services

import api.models.UserId
import api.repositories.AccountRepository
import api.repositories.PlaidItemRepository
import api.repositories.ProfileRepository
import api.repositories.TransactionRepository
import scalikejdbc.*

import scala.util.Try

object DeletionService:
    def deleteUserEverything(userId: UserId) = ProfileRepository
        .getProfileByUserId(userId)
        .map { profileOpt =>
            profileOpt.map { profile =>
                PlaidItemRepository
                    .getItemsByUserId(profile.id)
                    .map { items =>
                        Try(
                            DB.localTx(implicit session =>
                                items.foreach(item =>
                                    DB.autoCommit(implicit session =>
                                        TransactionRepository.deleteTransactionsByItemId(item.id)
                                    )
                                )
                            )
                        ).map { _ =>
                            Try(
                                DB.localTx(implicit session =>
                                    items.foreach(item =>
                                        DB.autoCommit(implicit session =>
                                            AccountRepository.deleteAccountsByItemId(item.id)
                                        )
                                    )
                                )
                            ).map { _ =>
                                Try(
                                    DB.localTx(implicit session =>
                                        items.foreach(item => PlaidItemRepository.deleteItemById(item.id))
                                    )
                                ).map { _ =>
                                    Try(DB.autoCommit(implicit session => sql"""
                                        delete from goals where user_id = $userId
                                        """.update.apply())).map { _ =>
                                        Try(DB.autoCommit(implicit session => sql"""
                                            delete from assets where user_id = $userId
                                            """.update.apply())).map { _ =>
                                            Try(DB.autoCommit(implicit session => sql"""
                                                delete from profiles where id = $userId
                                                """.update.apply())).map { _ =>
                                                AuthService.deleteUser(userId, shouldSoftDelete = false)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
        }
