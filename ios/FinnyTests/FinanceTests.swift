import Testing

@testable import Finny

struct FinanceTests {

  struct PmtTestCase {
    let rate: Double
    let numPeriods: Int
    let pv: Double
    let fv: Double
    let expectedPmt: Double
  }

  @Test(
    "Pmt calculation",
    arguments: [
      PmtTestCase(
        rate: 0.02, numPeriods: 30, pv: -10_000.0, fv: 230_000.0, expectedPmt: -5222.982904548644),
      PmtTestCase(
        rate: 0.08, numPeriods: 35, pv: -80_000.0, fv: 3_000_000.0, expectedPmt: -10545.532517185009
      ),
    ])
  func testPmt(input: PmtTestCase) async throws {
    let pmt = Finance.pmt(
      rate: input.rate,
      numPeriods: input.numPeriods,
      pv: input.pv,
      fv: input.fv
    )
    #expect(pmt == input.expectedPmt)
  }

  struct NperTestCase {
    let rate: Double
    let pmt: Double
    let pv: Double
    let fv: Double
    let expectedNper: Double
  }

  @Test(
    "Nper calculation",
    arguments: [
      NperTestCase(rate: 0.0, pmt: -48_000.0, pv: -80_000.0, fv: 230_000.0, expectedNper: 3.125),
      NperTestCase(
        rate: 0.045, pmt: 0.0, pv: -10_000.0, fv: 230_000.0, expectedNper: 71.23389549807297),
    ])
  func testNper(input: NperTestCase) async throws {
    let nper = Finance.nper(
      rate: input.rate,
      pmt: input.pmt,
      pv: input.pv,
      fv: input.fv
    )
    #expect(nper == input.expectedNper)
  }

  struct FvTestCase {
    let rate: Double
    let pmt: Double
    let pv: Double
    let numPeriods: Int
    let expectedFv: Double
  }

  @Test(
    "Fv calculation",
    arguments: [
      FvTestCase(
        rate: 0.02, pmt: -5222.0, pv: -10_000.0, numPeriods: 30, expectedFv: 229960.12545041912),
      FvTestCase(
        rate: 0.045, pmt: 0.0, pv: -10_000.0, numPeriods: 35, expectedFv: 46673.47810024524),
    ])
  func testFv(input: FvTestCase) async throws {
    let fv = Finance.fv(
      pv: input.pv,
      pmt: input.pmt,
      rate: input.rate,
      numPeriods: input.numPeriods
    )
    #expect(fv == input.expectedFv)
  }
}
