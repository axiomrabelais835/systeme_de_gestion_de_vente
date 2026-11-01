import { Toaster as SonnerToaster } from 'sonner';

import { useTheme } from '@/lib/theme';

/** Toaster synchronisé avec le thème clair / sombre de l'application. */
export function Toaster() {
  const { theme } = useTheme();

  return <SonnerToaster richColors closeButton position="top-right" theme={theme} />;
}
