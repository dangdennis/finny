package test.repositories

import api.repositories.ProfileRepository
import org.scalatest.flatspec.AnyFlatSpec
import test.helpers.*
import scalasql.*
import api.database.DatabaseScalaSql
import api.common.Environment

class ProfileRepositorySpec extends TestInfra:
  override protected def beforeAll(): Unit = super.beforeAll()
  override protected def beforeEach(): Unit = super.beforeEach()

  "getProfileByUserId" should "find profile record" in {
    given dbClient: DbClient.DataSource = DatabaseScalaSql
      .init(Environment.getDatabaseConfig)
      .value

    val profile = AuthServiceHelper.createUser()
    val gotProfile = ProfileRepository.getProfile(profile.id).value
    gotProfile.id should be(profile.id)
  }
