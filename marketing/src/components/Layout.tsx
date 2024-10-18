import { Footer } from '@/components/Footer'
import { Header } from '@/components/Header'
import { Analytics } from '@vercel/analytics/react'

export function Layout({ children }: { children: React.ReactNode }) {
  return (
    <>
      <Analytics />
      <Header />
      <main className="flex-auto">{children}</main>
      <Footer />
    </>
  )
}
