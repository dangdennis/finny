use hailmary::finalytics::{
    Finalytics, FutureValueInput, PaymentFromFutureValueInput, PeriodFromFutureValueInput,
};

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
    let result = fin.pmt(input);
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
    let result = fin.fv(input);
    assert_eq!(result, 272_986.1958887072);

    // Test case 2
    let input = FutureValueInput {
        pmt: 2_000.0,
        pv: 10_000.0,
        rate: 0.02,
        years: 15,
    };
    let result = fin.fv(input);
    assert_eq!(result, -48045.51721565421);

    // Test case 3
    let input = FutureValueInput {
        pmt: -6_115.98,
        pv: 10_000.0,
        rate: 0.02,
        years: 30,
    };
    let result = fin.fv(input);
    assert_eq!(result, 229999.94521618786);
}

#[test]
fn test_period_from_future_value() {
    let fin = Finalytics::new();

    // Test case 1: payment with zero interest
    let input = PeriodFromFutureValueInput {
        fv: 230_000.0,
        pv: -80_000.0,
        pmt: -48000.0,
        rate: 0.0,
    };
    let result = fin.nper(input);
    assert_eq!(result, 3.125);

    // Test case 2: zero payment with growth
    let input = PeriodFromFutureValueInput {
        fv: 230_000.0,
        pv: -10_000.0,
        pmt: 0.0,
        rate: 0.045,
    };
    let result = fin.nper(input);
    assert_eq!(result, 71.23389549807297);

    // Test case 3: 0 nper if no periodic pmts and no initial investment
    let input = PeriodFromFutureValueInput {
        fv: 230_000.0,
        pv: 0.0,
        pmt: 0.0,
        rate: 0.03,
    };
    let result = fin.nper(input);
    assert_eq!(result, 0.0);

    // Test case 4: initial investment, no pmt, zero interest
    let input = PeriodFromFutureValueInput {
        fv: 230_000.0,
        pv: -10000.0,
        pmt: 0.0,
        rate: 0.00,
    };
    let result = fin.nper(input);
    assert_eq!(result, 0.0);
}
