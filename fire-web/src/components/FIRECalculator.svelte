<script>
  const currency = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    maximumFractionDigits: 0
  });
  const percent = new Intl.NumberFormat('en-US', {
    style: 'percent',
    maximumFractionDigits: 1
  });

  let currentAge = 30;
  let retirementAge = 60;
  let currentSavings = 45000;
  let monthlyExpenses = 3000;

  let annualReturnPct = 7;
  let inflationPct = 2.5;
  let taxPct = 15;
  let withdrawalRatePct = 4;

  let method = 'interest';

  const calculateMonthlySavings = (target, principal, rate, months) => {
    if (months <= 0 || !Number.isFinite(target)) {
      return 0;
    }
    if (rate === 0) {
      return Math.max(0, (target - principal) / months);
    }

    const growth = Math.pow(1 + rate, months);
    const pmt = (target - principal * growth) / ((growth - 1) / rate);
    return Math.max(0, pmt);
  };

  const formatCurrency = (value) => {
    if (!Number.isFinite(value)) return 'N/A';
    return currency.format(Math.max(0, Math.round(value)));
  };

  const formatPercent = (value) => {
    if (!Number.isFinite(value)) return 'N/A';
    return percent.format(value);
  };

  $: yearsToRetireRaw = retirementAge - currentAge;
  $: yearsToRetire = Math.max(0, yearsToRetireRaw);
  $: monthsToRetire = yearsToRetire * 12;

  $: annualReturnRate = annualReturnPct / 100;
  $: inflationRate = inflationPct / 100;
  $: taxRate = taxPct / 100;
  $: withdrawalRate = withdrawalRatePct / 100;

  $: afterTaxReturn = annualReturnRate * (1 - taxRate);
  $: realReturn = (1 + afterTaxReturn) / (1 + inflationRate) - 1;
  $: monthlyRealReturn = Math.pow(1 + realReturn, 1 / 12) - 1;

  $: annualExpenses = monthlyExpenses * 12;
  $: interestPortfolio = realReturn > 0 ? annualExpenses / realReturn : Number.NaN;
  $: swrPortfolio = annualExpenses / withdrawalRate;
  $: requiredPortfolio = method === 'interest' ? interestPortfolio : swrPortfolio;

  $: inflationFactor = Math.pow(1 + inflationRate, yearsToRetire);
  $: requiredPortfolioAtRetirement = requiredPortfolio * inflationFactor;

  $: isTimelineValid = yearsToRetireRaw > 0;
  $: isInterestValid = method !== 'interest' || realReturn > 0;
  $: canCompute = isTimelineValid && isInterestValid;

  $: monthlySavingsGoal = canCompute
    ? calculateMonthlySavings(requiredPortfolio, currentSavings, monthlyRealReturn, monthsToRetire)
    : Number.NaN;

  $: growth = monthsToRetire > 0 ? Math.pow(1 + monthlyRealReturn, monthsToRetire) : 1;
  $: projectedPortfolio = canCompute
    ? currentSavings * growth +
      (monthlyRealReturn === 0
        ? monthlySavingsGoal * monthsToRetire
        : monthlySavingsGoal * ((growth - 1) / monthlyRealReturn))
    : Number.NaN;
</script>

<div class="calculator">
  <div class="card stack">
    <div class="section-header">
      <h2>Inputs</h2>
      <p class="muted">
        Tune your current profile and your target retirement age to see the monthly savings goal.
      </p>
    </div>

    <div class="section">
      <h3>Profile</h3>
      <div class="field-grid">
        <label class="field">
          <span>Current age</span>
          <input type="number" min="18" max="80" step="1" bind:value={currentAge} />
        </label>
        <label class="field">
          <span>Retirement age</span>
          <input type="number" min="30" max="90" step="1" bind:value={retirementAge} />
        </label>
        <label class="field">
          <span>Current investments</span>
          <input type="number" min="0" step="1000" bind:value={currentSavings} />
        </label>
        <label class="field">
          <span>Monthly expenses</span>
          <input type="number" min="0" step="100" bind:value={monthlyExpenses} />
        </label>
      </div>
    </div>

    <div class="section">
      <h3>Goal method</h3>
      <div class="radio-grid">
        <label class="radio-card">
          <input type="radio" name="method" value="interest" bind:group={method} />
          <div>
            <div class="radio-title">Perpetual interest</div>
            <p class="muted">Live off real returns without touching principal.</p>
          </div>
        </label>
        <label class="radio-card">
          <input type="radio" name="method" value="swr" bind:group={method} />
          <div>
            <div class="radio-title">4% rule</div>
            <p class="muted">Classic FIRE number using a 4% withdrawal rate.</p>
          </div>
        </label>
      </div>
    </div>

    <div class="section">
      <h3>Assumptions</h3>
      <div class="field-grid">
        <label class="field">
          <span>ETF return (annual)</span>
          <div class="input-suffix">
            <input type="number" min="0" step="0.1" bind:value={annualReturnPct} />
            <span class="suffix">%</span>
          </div>
        </label>
        <label class="field">
          <span>Inflation (annual)</span>
          <div class="input-suffix">
            <input type="number" min="0" step="0.1" bind:value={inflationPct} />
            <span class="suffix">%</span>
          </div>
        </label>
        <label class="field">
          <span>Tax on gains</span>
          <div class="input-suffix">
            <input type="number" min="0" max="50" step="0.5" bind:value={taxPct} />
            <span class="suffix">%</span>
          </div>
        </label>
        <label class="field">
          <span>Withdrawal rate</span>
          <div class="input-suffix">
            <input type="number" min="1" max="8" step="0.1" bind:value={withdrawalRatePct} />
            <span class="suffix">%</span>
          </div>
        </label>
      </div>
    </div>
  </div>

  <div class="stack results">
    <div class="card highlight">
      <p class="eyebrow">Monthly savings goal</p>
      <h2>{formatCurrency(monthlySavingsGoal)}</h2>
      <p class="muted">In today's dollars, based on your selected method.</p>
    </div>

    <div class="card">
      <p class="eyebrow">FIRE number (perpetual interest)</p>
      <h3>{formatCurrency(interestPortfolio)}</h3>
      <p class="muted">Covers {formatCurrency(annualExpenses)} per year without principal drawdown.</p>
    </div>

    <div class="card">
      <p class="eyebrow">Target portfolio</p>
      <h3>{formatCurrency(requiredPortfolio)}</h3>
      <p class="muted">Future value at retirement: {formatCurrency(requiredPortfolioAtRetirement)}.</p>
    </div>

    <div class="card">
      <p class="eyebrow">Retirement window</p>
      <h3>{yearsToRetire} years</h3>
      <p class="muted">
        Real return after taxes: {formatPercent(realReturn)}. Projected portfolio with this savings
        plan: {formatCurrency(projectedPortfolio)}.
      </p>
    </div>

    {#if !isTimelineValid}
      <div class="notice error">
        Retirement age must be greater than your current age.
      </div>
    {/if}
    {#if !isInterestValid}
      <div class="notice error">
        After-tax returns do not beat inflation. Perpetual interest is not feasible with these
        assumptions.
      </div>
    {/if}

    <div class="card subtle">
      <p class="muted">
        This calculator uses simplified assumptions for illustration. Adjust the rates to match
        your situation and review with a qualified advisor.
      </p>
    </div>
  </div>
</div>
