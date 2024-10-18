import Image from 'next/image'
import FinnyLogo from '@/images/logos/finny-logo.png'

export function Logomark(props: React.ComponentPropsWithoutRef<'svg'>) {
  return <Image src={FinnyLogo} alt="Finny Logo" width="50" height="50" />
}

export function Logo(props: React.ComponentPropsWithoutRef<'svg'>) {
  return (
    <div>
      <Image src={FinnyLogo} alt="Finny Logo" width="50" height="50" />
    </div>
  )
}
