import { type ReactNode } from 'react';
import { Navigate, useLocation } from 'react-router-dom';

import { useAuth } from '@/lib/auth';

interface ProtectedRouteProps {
  children: ReactNode;
  /** Réservé aux administrateurs. */
  adminOnly?: boolean;
}

/** Garde de route : authentification (et rôle admin si requis). */
export function ProtectedRoute({ children, adminOnly = false }: ProtectedRouteProps) {
  const { user, initializing } = useAuth();
  const location = useLocation();

  if (initializing) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="flex flex-col items-center gap-3">
          <span className="h-9 w-9 animate-spin rounded-full border-2 border-primary border-t-transparent" />
          <p className="text-sm text-muted-foreground">Chargement de votre espace…</p>
        </div>
      </div>
    );
  }

  if (!user) {
    return <Navigate to="/login" replace state={{ from: location.pathname }} />;
  }

  if (adminOnly && user.role !== 'admin') {
    return <Navigate to="/tableau-de-bord" replace />;
  }

  return <>{children}</>;
}
