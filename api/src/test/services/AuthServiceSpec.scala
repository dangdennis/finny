package test.services

import api.services.AuthService
import org.scalatest.BeforeAndAfterAll
import org.scalatest.BeforeAndAfterEach
import org.scalatest.EitherValues
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import repositories.AuthUserRepository
import test.helpers.*

import java.util.UUID

class AuthServiceSpec extends AnyFlatSpec, Matchers, EitherValues, BeforeAndAfterAll, BeforeAndAfterEach:
    override protected def beforeAll(): Unit = TestHelper.beforeAll()
    override protected def afterEach(): Unit = TestHelper.afterEach()

    "deleteUser" should "soft delete user" in {
        // given
        val user = AuthServiceHelper.createUserViaSupabaseAuth(email = "dennis@mail.com", password = "password").value
        val userId = UUID.fromString(user.id)

        // when
        AuthService.deleteUser(userId, shouldSoftDelete = true)

        // then
        val deletedUser = AuthUserRepository.getUser(userId).get.get
        deletedUser.deletedAt should not be empty
    }
