use hailmary::finalytics::{Finalytics, FutureValueInput, PaymentFromFutureValueInput};

#[test]
fn test_payment_from_future_value() {
    let fin = Finalytics::new();

    // Test case 1
    let input = PaymentFromFutureValueInput {
        fv: 230_000.0,
        pv: -10_000.0,
        rate: 0.02,
        years: 30,
    };
    let result = fin.payment_from_future_value(input);
    assert_eq!(result, -6115.981350416703);
}

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
    assert_eq!(result, 272_986.1958887072);

    // Test case 2
    let input = FutureValueInput {
        pmt: 2_000.0,
        pv: 10_000.0,
        rate: 0.02,
        years: 15,
    };
    let result = fin.future_value(input);
    assert_eq!(result, -48045.51721565421);

    // Test case 3
    let input = FutureValueInput {
        pmt: -6_115.98,
        pv: 10_000.0,
        rate: 0.02,
        years: 30,
    };
    let result = fin.future_value(input);
    assert_eq!(result, 229999.94521618786);
}
