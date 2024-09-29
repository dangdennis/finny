package test.repositories

import api.repositories.ProfileRepository
import org.scalatest.flatspec.AnyFlatSpec
import test.helpers.*

class ProfileRepositorySpec extends TestInfra:
  override protected def beforeAll(): Unit = super.beforeAll()
  override protected def beforeEach(): Unit = super.beforeEach()

  "getProfileByUserId" should "find profile record" in {
    val profile = AuthServiceHelper.createUser()
    val gotProfile = ProfileRepository.getProfile(profile.id).value.get
    gotProfile.id should be(profile.id)
  }
