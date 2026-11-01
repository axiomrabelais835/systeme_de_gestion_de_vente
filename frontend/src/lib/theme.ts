import { useCallback, useEffect, useState } from 'react';

/** Gestion du thème clair / sombre (persisté, appliquée sur <html class="dark">). */

export type Theme = 'light' | 'dark';

const THEME_STORAGE_KEY = 'salesstock_theme';
const THEME_CHANGED_EVENT = 'salesstock:theme-changed';

export function getTheme(): Theme {
  return document.documentElement.classList.contains('dark') ? 'dark' : 'light';
}

export function applyTheme(theme: Theme): void {
  document.documentElement.classList.toggle('dark', theme === 'dark');
  localStorage.setItem(THEME_STORAGE_KEY, theme);
  window.dispatchEvent(new Event(THEME_CHANGED_EVENT));
}

/**
 * État du thème synchronisé entre les composants (bouton de la barre
 * supérieure, toaster, etc.).
 */
export function useTheme(): { theme: Theme; setTheme: (theme: Theme) => void; toggle: () => void } {
  const [theme, setThemeState] = useState<Theme>(() => getTheme());

  useEffect(() => {
    const onChange = () => setThemeState(getTheme());
    window.addEventListener(THEME_CHANGED_EVENT, onChange);
    return () => window.removeEventListener(THEME_CHANGED_EVENT, onChange);
  }, []);

  const setTheme = useCallback((next: Theme) => applyTheme(next), []);
  const toggle = useCallback(() => applyTheme(getTheme() === 'dark' ? 'light' : 'dark'), []);

  return { theme, setTheme, toggle };
}
