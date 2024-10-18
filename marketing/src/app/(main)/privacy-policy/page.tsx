import { Container } from '@/components/Container'

export default function PrivacyPolicy() {
  return (
    <div className="overflow-hidden">
      <Container>
        <div className="mx-auto max-w-2xl lg:mx-0">
          <h1 className="text-4xl font-medium tracking-tight text-gray-900">
            Privacy Policy
          </h1>
          <p className="mt-4 text-lg text-gray-600">
            Effective Date: Oct 17, 2024
          </p>
        </div>
        <div className="mx-auto mt-16 max-w-2xl lg:mx-0 lg:max-w-none">
          <div className="prose prose-lg prose-indigo">
            <p className="mb-8">
              At Finny, we prioritize the privacy and security of your personal
              data. This Privacy Policy outlines how we collect, use, store, and
              protect your data, including data obtained through the YNAB API.
              Please take the time to read this policy carefully. By using
              Finny, you agree to the terms outlined below.
            </p>

            <h2 className="mb-6 mt-12">1. Data We Collect</h2>
            <ul className="mb-8 space-y-4">
              <li>
                Budget Categories and Balances: Finny collects and stores your
                budget categories and balance data from YNAB through the YNAB
                API to provide you with tailored budgeting insights.
              </li>
              <li>
                OAuth Access Token: Finny uses an OAuth access token to interact
                with YNAB&apos;s API and retrieve your financial data securely.
                We do not store or request any other financial account
                credentials.
              </li>
            </ul>

            <h2 className="mb-6 mt-12">2. How We Use Your Data</h2>
            <ul className="mb-8 space-y-4">
              <li>
                Personal Budget Management: Your budget categories and balances
                are used solely to help you manage and understand your finances
                within Finny. This data will not be used for any other purposes
                beyond what is necessary to provide you with the app&apos;s
                functionality.
              </li>
              <li>
                No Third-Party Sharing: Finny guarantees that your data,
                including data retrieved from YNAB&apos;s API, will not be
                knowingly shared or sold to any third party. We will only use
                the data internally to support Finny&apos;s features.
              </li>
            </ul>

            <h2 className="mb-6 mt-12">
              3. Technologies and Third-Party Services
            </h2>
            <p className="mb-4">
              Finny uses various technologies and third-party services to
              provide and improve our service. These include:
            </p>
            <ul className="mb-8 space-y-4">
              <li>
                <strong>YNAB API:</strong> We use the You Need A Budget (YNAB)
                API to retrieve your budget data. This integration is essential
                for the core functionality of Finny.
              </li>
              <li>
                <strong>Cloud Hosting:</strong> We use Fly and Vercel to host
                our application and website.
              </li>
              <li>
                <strong>Analytics:</strong> We use Vercel Analytics to track
                page visits on our website.
              </li>
              <li>
                <strong>Error Tracking:</strong> We use Sentry on Finny iOS to
                monitor and quickly resolve any issues that may occur in our
                application.
              </li>
            </ul>
            <p className="mb-8">
              These third-party services are carefully selected and are bound by
              contractual obligations to keep any information they process on
              our behalf confidential. We do not share your personal data with
              these third parties for their own purposes.
            </p>
          </div>
        </div>
      </Container>
    </div>
  )
}
