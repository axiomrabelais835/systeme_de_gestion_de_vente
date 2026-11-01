/** Types métier correspondant aux réponses de l'API /api/v1. */

export type UserRole = 'admin' | 'vendeur';

export interface AuthUser {
  id: number;
  name: string;
  email: string;
  role: UserRole;
  role_label: string;
  is_active: boolean;
  created_at?: string | null;
}

export interface Category {
  id: number;
  name: string;
  slug: string;
  description: string | null;
  products_count?: number;
  created_at?: string;
}

export type StockStatus = 'ok' | 'low' | 'out';

export interface Product {
  id: number;
  name: string;
  sku: string;
  category_id: number;
  category?: Pick<Category, 'id' | 'name' | 'slug'>;
  description: string | null;
  purchase_price: string;
  selling_price: string;
  quantity: number;
  low_stock_threshold: number;
  image: string | null;
  is_active: boolean;
  stock_status: StockStatus;
}

export interface Customer {
  id: number;
  name: string;
  email: string | null;
  phone: string | null;
  address: string | null;
  notes: string | null;
  total_spent?: number;
  sales_count?: number;
  created_at?: string;
}

export type SaleStatus = 'validee' | 'annulee';
export type PaymentMethod = 'especes' | 'mobile_money' | 'carte' | 'virement';
export type PaymentStatus = 'payee' | 'en_attente';

/** GET /settings */
export interface AppSettings {
  company_name: string;
  currency: string;
  currency_symbol: string;
  default_tax_rate: number;
  default_low_stock_threshold: number;
}

export interface SaleItem {
  id: number;
  product_id: number;
  /** Renseignés quand la relation produit est chargée (détail d'une vente). */
  product_name?: string | null;
  product_sku?: string | null;
  quantity: number;
  unit_price: string;
  line_total: string;
}

export interface Sale {
  id: number;
  reference: string;
  customer_id: number | null;
  customer?: Pick<Customer, 'id' | 'name'> | null;
  user?: Pick<AuthUser, 'id' | 'name' | 'role'> | null;
  subtotal: string;
  discount: string;
  tax: string;
  total: string;
  payment_method: PaymentMethod;
  payment_method_label: string;
  payment_status: PaymentStatus;
  payment_status_label: string;
  status: SaleStatus;
  status_label: string;
  items?: SaleItem[];
  /** Nombre de lignes (agrégat calculé en liste, sans charger les articles). */
  items_count?: number | null;
  sold_at: string | null;
  cancelled_at: string | null;
  cancel_reason: string | null;
}

export type MovementType = 'entree' | 'sortie' | 'ajustement' | 'annulation';

export interface StockMovement {
  id: number;
  product_id: number;
  product?: Pick<Product, 'id' | 'name' | 'sku'>;
  type: MovementType;
  type_label?: string;
  /** Delta signé : +5 pour une entrée, -3 pour une vente. */
  quantity: number;
  reason: string | null;
  reference: string | null;
  user?: Pick<AuthUser, 'id' | 'name'> | null;
  created_at: string;
}

/** GET /dashboard/summary */
export interface DashboardSummary {
  revenue: {
    today: number;
    today_trend: number | null;
    week: number;
    week_trend: number | null;
    month: number;
    month_trend: number | null;
  };
  sales_count: { today: number; week: number; month: number };
  average_basket: number;
  stock_value: number;
  low_stock_count: number;
  out_of_stock_count: number;
  products_count: number;
  customers_count: number;
}

export type ChartPeriod = '7d' | '30d' | '12m';

export interface ChartPoint {
  period: string;
  label: string;
  total: number;
  count: number;
}

export interface TopProduct {
  product_id: number;
  name: string;
  sku: string;
  quantity: number;
  revenue: number;
}

export interface CategoryShare {
  category_id: number;
  name: string;
  revenue: number;
  percentage: number;
}
