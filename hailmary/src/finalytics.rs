pub struct Finalytics {}

impl Finalytics {
    pub fn new() -> Self {
        Finalytics {}
    }
    // fn get_current_expense(&self) {}
    // fn actual_retirement_age(&self) {}
    // fn monthly_savings_goal(&self) {}
    // fn contributions_this_month(&self) {}
    // fn actual_savings_at_retirement(&self) {}
    // fn target_savings_at_retirement(&self) {}
    // fn target_retirement_age(&self) {}

    /// If pmt and pv are negative - money is leaving the person because they're investing -
    /// then vf should be positive because money is going back to the person.
    pub fn future_value(&self, input: FutureValueInput) -> f64 {
        let growth_factor = (1.0 + input.rate).powi(input.years as i32);
        let fv = input.pv * growth_factor + input.pmt * (growth_factor - 1.0) / input.rate;

        -fv
    }

    pub fn payment_from_future_value(&self, input: PaymentFromFutureValueInput) -> f64 {
        let n = input.years as f64;
        let r = input.rate; // This is already in decimal form (e.g., 0.02 for 2%)
        let fv = input.fv;
        let pv = input.pv;

        let payment = if r.abs() < 1e-10 {
            // When rate is very close to zero
            (fv - pv) / n
        } else {
            let factor = (1.0 + r).powf(n);
            (fv - pv * factor) * r / (factor - 1.0)
        };

        // The payment should have the opposite sign of FV
        -payment.copysign(fv)
    }
}

pub struct PaymentFromFutureValueInput {
    pub rate: f64,
    pub fv: f64,
    pub pv: f64,
    pub years: i8,
}

pub struct FutureValueInput {
    pub pv: f64,
    pub pmt: f64,
    pub rate: f64,
    pub years: i8,
}
