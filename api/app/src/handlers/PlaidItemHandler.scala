package app.handlers

import app.common.*
import app.dtos.*
import app.dtos.DTOs.PlaidItemCreateRequest
import app.dtos.DTOs.PlaidItemSyncRequest
import app.models.*
import app.repositories.PlaidItemRepository
import app.repositories.PlaidItemRepository.CreateItemInput
import app.services.PlaidService
import app.services.PlaidSyncService

import java.util.UUID

object PlaidItemHandler:
    def handlePlaidItemsGet(user: Profile): Either[AuthenticationError, DTOs.PlaidItemsGetResponse] =
        PlaidItemRepository
            .getItemsWithAccountsByUserId(userId = user.id)
            .left
            .map(_ => AuthenticationError(404))
            .map(items =>
                DTOs.PlaidItemsGetResponse(
                    items = items.map(item =>
                        DTOs.PlaidItemDTO(
                            id = item.plaidItem.id.toString(),
                            institutionId = item.plaidItem.plaidInstitutionId,
                            status = item.plaidItem.status.toString(),
                            createdAt = item.plaidItem.createdAt.toString(),
                            lastSyncedAt = item.plaidItem.lastSyncedAt.map(_.toString()),
                            lastSyncError = item.plaidItem.lastSyncError,
                            lastSyncErrorAt = item.plaidItem.lastSyncErrorAt.map(_.toString()),
                            retryCount = item.plaidItem.retryCount,
                            accounts = item.accounts.map(account =>
                                DTOs.PlaidAccountDTO(
                                    id = account.id.toString(),
                                    itemId = account.itemId.toString(),
                                    name = account.name,
                                    mask = account.mask,
                                    officialName = account.officialName,
                                    currentBalance = account.currentBalance,
                                    availableBalance = account.availableBalance,
                                    isoCurrencyCode = account.isoCurrencyCode,
                                    unofficialCurrencyCode = account.unofficialCurrencyCode,
                                    accountType = account.accountType,
                                    accountSubtype = account.accountSubtype,
                                    createdAt = account.createdAt.toString()
                                )
                            )
                        )
                    )
                )
            )

    def handlePlaidItemsCreate(user: Profile, input: PlaidItemCreateRequest): Either[AuthenticationError, DTOs.PlaidItemCreateResponse] =
        val result = for
            pubTokenData <- PlaidService.exchangePublicToken(
                client = PlaidService.makePlaidClientFromEnv(),
                publicToken = input.publicToken,
                userId = user.id
            )
            itemData <- PlaidService.getItem(
                client = PlaidService.makePlaidClientFromEnv(),
                accessToken = pubTokenData.getAccessToken(),
                userId = user.id
            )
            item <- PlaidItemRepository.getOrCreateItem(
                input = CreateItemInput(
                    userId = user.id,
                    plaidAccessToken = pubTokenData.getAccessToken(),
                    plaidItemId = pubTokenData.getItemId(),
                    plaidInstitutionId = itemData.getItem().getInstitutionId(),
                    status = PlaidItemStatus.Good,
                    transactionsCursor = None
                )
            )
        yield item

        result match
            case Left(error) =>
                Logger.root.error(s"Error creating Plaid item", error)
                Left(AuthenticationError(400))
            case Right(item) =>
                PlaidSyncService.sync(item.id)

                Right(
                    DTOs.PlaidItemCreateResponse(
                        itemId = item.id.toString(),
                        institutionId = item.plaidInstitutionId,
                        status = item.status.toString(),
                        createdAt = item.createdAt.toString()
                    )
                )

    def handlePlaidItemsSync(user: Profile, input: PlaidItemSyncRequest): Either[AuthenticationError, Unit] =
        PlaidItemRepository
            .getById(id = UUID.fromString(input.itemId))
            .left
            .map(_ => AuthenticationError(404))
            .map(item =>
                PlaidSyncService.sync(item.id)
                Right(())
            )
