import {
  ArrowLeftRight,
  LayoutDashboard,
  Package,
  Settings,
  ShoppingCart,
  Tags,
  Users,
  type LucideIcon,
} from 'lucide-react';

export interface NavItem {
  to: string;
  label: string;
  icon: LucideIcon;
  /** Réservé aux administrateurs. */
  adminOnly?: boolean;
}

/** Navigation principale — 100 % en français. */
export const NAV_ITEMS: NavItem[] = [
  { to: '/tableau-de-bord', label: 'Tableau de bord', icon: LayoutDashboard },
  { to: '/produits', label: 'Produits', icon: Package },
  { to: '/ventes', label: 'Ventes', icon: ShoppingCart },
  { to: '/clients', label: 'Clients', icon: Users },
  { to: '/categories', label: 'Catégories', icon: Tags },
  { to: '/mouvements', label: 'Mouvements de stock', icon: ArrowLeftRight },
  { to: '/parametres', label: 'Paramètres', icon: Settings, adminOnly: true },
];

/** Libellé de page pour la barre supérieure. */
export function pageTitle(pathname: string): string {
  const match = [...NAV_ITEMS]
    .sort((a, b) => b.to.length - a.to.length)
    .find((item) => pathname === item.to || pathname.startsWith(`${item.to}/`));

  return match?.label ?? 'SalesStock';
}
