//
//  Finance.swift
//  Finny
//
//  Created by Dennis Dang on 11/6/24.
//

import Foundation

struct Finance {
  enum PaymentType {
    case end
    // Add .beginning if needed later
  }

  // Calculates number of periods needed
  static func nper(rate: Double, pmt: Double, pv: Double, fv: Double) -> Double {
    // For payments at end of period
    let num = fv + pmt * (1.0 + rate) / rate
    let den = pv + pmt * (1.0 + rate) / rate

    return log(num / den) / log(1.0 + rate)
  }

  // Calculates payment amount
  static func pmt(rate: Double, numPeriods: Int, pv: Double, fv: Double) -> Double {
    assert(rate > 0 && rate <= 1, "Rate must be between 0 and 1")
    assert(numPeriods >= 0, "Number of periods must be non-negative")
    assert(pv <= 0, "Present value must be non-negative")
    assert(fv >= 0, "Future value must be non-negative")
    let pvFactor = pow(1.0 + rate, Double(numPeriods))
    let payment = rate * (fv + pv * pvFactor) / (pvFactor - 1.0)
    return payment > 0 ? -payment : payment
  }

  // Calculates future value
  static func fv(pv: Double, pmt: Double, rate: Double, numPeriods: Int) -> Double {
    let pvFactor = pow(1.0 + rate, Double(numPeriods))
    return -pv * pvFactor - pmt * (pvFactor - 1.0) / rate
  }
}
