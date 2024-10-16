struct Finalytics {}

impl Finalytics {
    fn new() -> Self {
        Finalytics {}
    }
    fn get_current_expense(&self) {}
    fn actual_retirement_age(&self) {}
    fn monthly_savings_goal(&self) {}
    fn contributions_this_month(&self) {}
    fn actual_savings_at_retirement(&self) {}
    fn target_savings_at_retirement(&self) {}
    fn target_retirement_age(&self) {}

    /// If pmt and pv are negative - money is leaving the person because they're investing -
    /// then vf should be positive because money is going back to the person.
    fn future_value(&self, input: FutureValueInput) -> Result<f64, String> {
        if input.pmt.signum() != input.pv.signum() {
            return Err("pmt and pv must share the same sign".to_string());
        }

        let growth_factor = (1.0 + input.rate).powi(input.years as i32);
        let fv = input.pv * growth_factor + input.pmt * (growth_factor - 1.0) / input.rate;

        println!("hi {:?}", fv);

        Ok(-fv)
    }

    fn payment_from_future_value(&self, input: PaymentFromFutureValueInput) -> f64 {
        let payment = if input.rate == 0.0 {
            (input.fv - input.pv) / input.years as f64
        } else {
            let growth_factor = (1.0 + input.rate).powi(input.years as i32);
            (input.fv - input.pv * growth_factor) / (growth_factor - 1.0) / input.rate
        };

        (payment.abs() * input.fv.signum()).trunc()
    }
}

struct PaymentFromFutureValueInput {
    rate: f64,
    fv: f64,
    pv: f64,
    years: i8,
}

struct FutureValueInput {
    pv: f64,
    pmt: f64,
    rate: f64,
    years: i8,
}

#[cfg(test)]
mod tests {
    use crate::finalytics::{Finalytics, FutureValueInput};

    // #[test]
    // fn test_payment_from_future_value() {
    //     let fin = Finalytics::new();

    //     // Test case 1
    //     let result = fin.payment_from_future_value(1000.0, 0.05, 5);
    //     assert!((result - 180.975).abs() < 0.001);

    //     // Test case 2
    //     let result = payment_from_future_value(5000.0, 0.03, 10);
    //     assert!((result - 431.148).abs() < 0.001);

    //     // Add more test cases as needed
    // }

    #[test]
    fn test_future_value() {
        let fin = Finalytics::new();

        // Test case 1
        let input = FutureValueInput {
            pmt: -2_000.0,
            pv: -20_000.0,
            rate: 0.06,
            years: 30,
        };
        let result = fin.future_value(input);
        assert_eq!(
            result,
            Ok(272_986.1958887072),
            "the signage should be correct"
        );

        // Test case 2
        let input = FutureValueInput {
            pmt: 2_000.0,
            pv: 10_000.0,
            rate: 0.02,
            years: 15,
        };
        let result = fin.future_value(input);
        assert_eq!(
            result,
            Ok(-48045.51721565421),
            "the signage should be correct"
        );
    }
}
