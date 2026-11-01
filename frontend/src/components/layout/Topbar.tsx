import { LogOut, Menu, Moon, Sun } from 'lucide-react';
import { useLocation, useNavigate } from 'react-router-dom';
import { toast } from 'sonner';

import { Avatar, AvatarFallback } from '@/components/ui/avatar';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { useAuth } from '@/lib/auth';
import { useTheme } from '@/lib/theme';

import { pageTitle } from './nav';

interface TopbarProps {
  onOpenSidebar: () => void;
}

/** Barre supérieure : titre de page, thème, menu utilisateur. */
export function Topbar({ onOpenSidebar }: TopbarProps) {
  const { user, logout } = useAuth();
  const { theme, toggle } = useTheme();
  const location = useLocation();
  const navigate = useNavigate();

  const initials = (user?.name ?? '?')
    .split(' ')
    .map((part) => part[0])
    .slice(0, 2)
    .join('')
    .toUpperCase();

  const handleLogout = async () => {
    await logout();
    toast.success('Vous êtes déconnecté.');
    navigate('/login', { replace: true });
  };

  return (
    <header className="sticky top-0 z-30 flex h-16 items-center gap-3 border-b bg-background/85 px-4 backdrop-blur-md sm:px-6">
      <Button
        variant="ghost"
        size="icon"
        className="lg:hidden"
        onClick={onOpenSidebar}
        aria-label="Ouvrir la navigation"
      >
        <Menu />
      </Button>

      <h1 className="text-base font-semibold tracking-tight sm:text-lg">
        {pageTitle(location.pathname)}
      </h1>

      <div className="ml-auto flex items-center gap-2">
        <Button
          variant="ghost"
          size="icon"
          onClick={toggle}
          aria-label={theme === 'dark' ? 'Passer en mode clair' : 'Passer en mode sombre'}
        >
          {theme === 'dark' ? <Sun /> : <Moon />}
        </Button>

        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="h-9 gap-2 px-2">
              <Avatar className="h-7 w-7">
                <AvatarFallback className="text-xs">{initials}</AvatarFallback>
              </Avatar>
              <span className="hidden max-w-[160px] truncate text-sm font-medium sm:inline">
                {user?.name}
              </span>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-56">
            <DropdownMenuLabel>
              <p className="truncate text-sm font-medium">{user?.name}</p>
              <p className="truncate text-xs font-normal text-muted-foreground">{user?.email}</p>
            </DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuLabel className="text-xs font-normal text-muted-foreground">
              Rôle : {user?.role_label}
            </DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem
              className="text-destructive focus:text-destructive"
              onSelect={(event) => {
                event.preventDefault();
                void handleLogout();
              }}
            >
              <LogOut />
              Se déconnecter
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  );
}
