import { X } from 'lucide-react';
import { NavLink } from 'react-router-dom';

import { Button } from '@/components/ui/button';
import { useAuth } from '@/lib/auth';
import { cn } from '@/lib/utils';

import { NAV_ITEMS } from './nav';

interface SidebarProps {
  open: boolean;
  onClose: () => void;
}

/** Barre latérale fixe de 260 px (tiroir en mobile). */
export function Sidebar({ open, onClose }: SidebarProps) {
  const { user } = useAuth();
  const items = NAV_ITEMS.filter((item) => !item.adminOnly || user?.role === 'admin');

  return (
    <>
      {/* Fond flouté en mobile */}
      <div
        className={cn(
          'fixed inset-0 z-40 bg-black/50 backdrop-blur-sm transition-opacity lg:hidden',
          open ? 'opacity-100' : 'pointer-events-none opacity-0',
        )}
        onClick={onClose}
        aria-hidden="true"
      />

      <aside
        className={cn(
          'fixed inset-y-0 left-0 z-50 flex w-[260px] flex-col border-r border-sidebar-border bg-sidebar transition-transform duration-200 lg:translate-x-0',
          open ? 'translate-x-0' : '-translate-x-full',
        )}
        aria-label="Navigation principale"
      >
        {/* Logo */}
        <div className="flex h-16 items-center gap-3 border-b border-sidebar-border px-5">
          <span className="flex h-9 w-9 items-center justify-center rounded-lg bg-gradient-to-br from-indigo-500 to-indigo-700 text-base font-bold text-white shadow-sm">
            S
          </span>
          <div className="leading-tight">
            <p className="text-sm font-semibold text-sidebar-foreground">SalesStock</p>
            <p className="text-xs text-sidebar-foreground/60">Gestion commerciale</p>
          </div>
          <Button
            variant="ghost"
            size="icon-sm"
            className="ml-auto lg:hidden"
            onClick={onClose}
            aria-label="Fermer la navigation"
          >
            <X />
          </Button>
        </div>

        {/* Liens */}
        <nav className="flex-1 space-y-1 overflow-y-auto p-3 scrollbar-thin">
          {items.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              onClick={onClose}
              className={({ isActive }) =>
                cn(
                  'flex items-center gap-3 rounded-md px-3 py-2.5 text-sm font-medium text-sidebar-foreground/80 transition-colors hover:bg-sidebar-accent hover:text-sidebar-foreground',
                  isActive &&
                    'bg-sidebar-accent text-primary shadow-sm dark:text-indigo-300',
                )
              }
            >
              <item.icon className="h-[18px] w-[18px] shrink-0" />
              {item.label}
            </NavLink>
          ))}
        </nav>

        {/* Pied de barre */}
        <div className="border-t border-sidebar-border p-4">
          <p className="text-xs text-sidebar-foreground/50">
            Connecté en tant que
            <span className="font-medium text-sidebar-foreground/80"> {user?.role_label}</span>
          </p>
          <p className="mt-1 text-xs text-sidebar-foreground/40">SalesStock v1.0</p>
        </div>
      </aside>
    </>
  );
}
