package test.services

import api.services.AuthService
import org.scalatest.flatspec.AnyFlatSpec
import repositories.AuthUserRepository
import test.helpers.*

import java.util.UUID

class AuthServiceSpec extends TestInfra:
  override protected def beforeAll(): Unit = super.beforeAll()
  override protected def afterEach(): Unit = super.afterEach()

  "deleteUser" should "soft delete user" in {
    // given
    val user = AuthServiceHelper
      .createUserViaSupabaseAuth(
        email = "dennis@mail.com",
        password = "password"
      )
      .value
    val userId = UUID.fromString(user.id)

    // when
    AuthService.deleteUser(userId, shouldSoftDelete = true)

    // then
    val deletedUser = AuthUserRepository.getUser(userId).value.get
    deletedUser.deletedAt should not be empty
  }
