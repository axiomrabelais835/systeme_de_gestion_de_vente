import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from 'react';

import {
  api,
  apiPost,
  type ApiEnvelope,
  ApiError,
  SESSION_EXPIRED_EVENT,
  TOKEN_STORAGE_KEY,
  USER_STORAGE_KEY,
} from './api';
import type { AuthUser } from './types';

interface LoginResponse {
  user: AuthUser;
  token: string;
}

interface AuthContextValue {
  /** Utilisateur connecté, ou null. */
  user: AuthUser | null;
  /** Vrai pendant la vérification du token au démarrage de l'application. */
  initializing: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextValue | null>(null);

function readStoredUser(): AuthUser | null {
  try {
    const raw = localStorage.getItem(USER_STORAGE_KEY);
    return raw ? (JSON.parse(raw) as AuthUser) : null;
  } catch {
    return null;
  }
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const hasToken = Boolean(localStorage.getItem(TOKEN_STORAGE_KEY));
  const [user, setUser] = useState<AuthUser | null>(() => readStoredUser());
  const [initializing, setInitializing] = useState(hasToken);

  // Au démarrage : on revalide le token stocké auprès de /auth/me.
  useEffect(() => {
    if (!hasToken) {
      return;
    }

    let cancelled = false;

    api
      .get<ApiEnvelope<AuthUser>>('/auth/me')
      .then(({ data }) => {
        if (!cancelled) {
          setUser(data.data);
          localStorage.setItem(USER_STORAGE_KEY, JSON.stringify(data.data));
        }
      })
      .catch(() => {
        if (!cancelled) {
          setUser(null);
        }
      })
      .finally(() => {
        if (!cancelled) {
          setInitializing(false);
        }
      });

    return () => {
      cancelled = true;
    };
  }, [hasToken]);

  // Session expirée (401 reçu par intercepteur axios).
  useEffect(() => {
    const onExpired = () => setUser(null);
    window.addEventListener(SESSION_EXPIRED_EVENT, onExpired);
    return () => window.removeEventListener(SESSION_EXPIRED_EVENT, onExpired);
  }, []);

  const login = useCallback(async (email: string, password: string): Promise<void> => {
    try {
      const data = await apiPost<LoginResponse>('/auth/login', {
        email,
        password,
        device_name: 'salesstock-web',
      });
      localStorage.setItem(TOKEN_STORAGE_KEY, data.token);
      localStorage.setItem(USER_STORAGE_KEY, JSON.stringify(data.user));
      setUser(data.user);
    } catch (error) {
      if (error instanceof ApiError) {
        throw error;
      }
      throw new ApiError('Une erreur est survenue lors de la connexion.', 0);
    }
  }, []);

  const logout = useCallback(async (): Promise<void> => {
    try {
      await apiPost('/auth/logout');
    } catch {
      // Le token peut déjà être révoqué : on purge dans tous les cas.
    }
    localStorage.removeItem(TOKEN_STORAGE_KEY);
    localStorage.removeItem(USER_STORAGE_KEY);
    setUser(null);
  }, []);

  const value = useMemo(
    () => ({ user, initializing, login, logout }),
    [user, initializing, login, logout],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth doit être utilisé dans un <AuthProvider>.');
  }
  return context;
}
