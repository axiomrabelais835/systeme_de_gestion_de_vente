import { useQuery } from '@tanstack/react-query';
import {
  ArrowDownRight,
  ArrowUpRight,
  AlertTriangle,
  Boxes,
  ChevronRight,
  IndianRupee,
  PackageX,
  RefreshCw,
  ShoppingCart,
  TrendingUp,
} from 'lucide-react';
import { useState, type ReactNode } from 'react';
import { Link } from 'react-router-dom';
import {
  Area,
  AreaChart,
  CartesianGrid,
  Cell,
  Pie,
  PieChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts';

import { PageHeader } from '@/components/layout/PageHeader';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { apiGet } from '@/lib/api';
import { formatDateTime, formatFCFA, formatNumber, formatPercent } from '@/lib/format';
import { cn } from '@/lib/utils';
import type {
  CategoryShare,
  ChartPeriod,
  ChartPoint,
  DashboardSummary,
  Product,
  Sale,
  TopProduct,
} from '@/lib/types';

const PIE_COLORS = ['#4F46E5', '#6366F1', '#818CF8', '#A5B4FC', '#0EA5E9', '#10B981', '#F59E0B', '#EF4444'];

const PERIOD_OPTIONS: Array<{ value: ChartPeriod; label: string }> = [
  { value: '7d', label: '7 jours' },
  { value: '30d', label: '30 jours' },
  { value: '12m', label: '12 mois' },
];

/* ---------------------------------- Contenu --------------------------------- */

function KpiCard({
  title,
  value,
  icon,
  accent,
  footer,
}: {
  title: string;
  value: string;
  icon: ReactNode;
  accent?: ReactNode;
  footer?: ReactNode;
}) {
  return (
    <Card>
      <CardContent className="p-5">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
              {title}
            </p>
            <p className="mt-2 truncate text-2xl font-semibold tracking-tight">{value}</p>
          </div>
          <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-primary/10 text-primary">
            {icon}
          </span>
        </div>
        {(footer || accent) && (
          <div className="mt-3 flex flex-wrap items-center gap-2 text-xs text-muted-foreground">
            {accent}
            {footer}
          </div>
        )}
      </CardContent>
    </Card>
  );
}

function TrendBadge({ value, caption }: { value: number | null; caption: string }) {
  if (value === null || value === undefined) {
    return <span className="text-muted-foreground">Pas de comparaison ({caption})</span>;
  }

  const up = value >= 0;

  return (
    <span className="inline-flex items-center gap-1.5">
      <Badge variant={up ? 'success' : 'destructive'}>
        {up ? <ArrowUpRight className="h-3 w-3" /> : <ArrowDownRight className="h-3 w-3" />}
        {formatPercent(Math.abs(value))}
      </Badge>
      <span>{caption}</span>
    </span>
  );
}

function ChartPeriodTabs({
  value,
  onChange,
}: {
  value: ChartPeriod;
  onChange: (period: ChartPeriod) => void;
}) {
  return (
    <div className="inline-flex rounded-lg border bg-muted/50 p-1">
      {PERIOD_OPTIONS.map((option) => (
        <button
          key={option.value}
          type="button"
          onClick={() => onChange(option.value)}
          className={cn(
            'rounded-md px-3 py-1.5 text-xs font-medium transition-colors',
            value === option.value
              ? 'bg-background text-foreground shadow-sm'
              : 'text-muted-foreground hover:text-foreground',
          )}
        >
          {option.label}
        </button>
      ))}
    </div>
  );
}

function ErrorState({ message, onRetry }: { message: string; onRetry: () => void }) {
  return (
    <Card className="border-destructive/30">
      <CardContent className="flex flex-col items-center gap-3 p-10 text-center">
        <PackageX className="h-8 w-8 text-destructive" />
        <p className="text-sm font-medium">{message}</p>
        <Button variant="outline" size="sm" onClick={onRetry}>
          <RefreshCw />
          Réessayer
        </Button>
      </CardContent>
    </Card>
  );
}

function SkeletonCards() {
  return (
    <div className="space-y-6">
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {Array.from({ length: 4 }).map((_, i) => (
          <Card key={i}>
            <CardContent className="space-y-3 p-5">
              <Skeleton className="h-3 w-28" />
              <Skeleton className="h-7 w-36" />
              <Skeleton className="h-3 w-24" />
            </CardContent>
          </Card>
        ))}
      </div>
      <div className="grid gap-4 xl:grid-cols-3">
        <Card className="xl:col-span-2">
          <CardContent className="p-6">
            <Skeleton className="h-[280px] w-full" />
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-6">
            <Skeleton className="h-[280px] w-full" />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

/* ------------------------------------ Page ---------------------------------- */

export default function DashboardPage() {
  const [period, setPeriod] = useState<ChartPeriod>('30d');

  const summaryQuery = useQuery({
    queryKey: ['dashboard', 'summary'],
    queryFn: () => apiGet<DashboardSummary>('/dashboard/summary'),
  });

  const chartQuery = useQuery({
    queryKey: ['dashboard', 'chart', period],
    queryFn: () =>
      apiGet<{ period: ChartPeriod; points: ChartPoint[] }>('/dashboard/sales-chart', { period }),
  });

  const topProductsQuery = useQuery({
    queryKey: ['dashboard', 'top-products', period],
    queryFn: () =>
      apiGet<{ period: ChartPeriod; products: TopProduct[] }>('/dashboard/top-products', {
        period,
      }),
  });

  const sharesQuery = useQuery({
    queryKey: ['dashboard', 'sales-by-category', period],
    queryFn: () =>
      apiGet<{ period: ChartPeriod; categories: CategoryShare[] }>('/dashboard/sales-by-category', {
        period,
      }),
  });

  const recentSalesQuery = useQuery({
    queryKey: ['dashboard', 'recent-sales'],
    queryFn: () => apiGet<Sale[]>('/dashboard/recent-sales'),
  });

  const lowStockQuery = useQuery({
    queryKey: ['products', 'low-stock', 'dashboard'],
    queryFn: () => apiGet<Product[]>('/products/low-stock', { per_page: 6 }),
  });

  if (summaryQuery.isError) {
    return (
      <>
        <PageHeader title="Tableau de bord" description="Vue d'ensemble de votre activité." />
        <ErrorState
          message={summaryQuery.error?.message ?? 'Impossible de charger le tableau de bord.'}
          onRetry={() => void summaryQuery.refetch()}
        />
      </>
    );
  }

  const summary = summaryQuery.data?.data;
  const points = chartQuery.data?.data.points ?? [];
  const topProducts = topProductsQuery.data?.data.products ?? [];
  const shares = sharesQuery.data?.data.categories ?? [];
  const recentSales = recentSalesQuery.data?.data ?? [];
  const lowStock = lowStockQuery.data?.data ?? [];

  return (
    <>
      <PageHeader
        title="Tableau de bord"
        description="Vue d'ensemble de votre activité : chiffre d'affaires, stocks et dernières ventes."
        actions={<ChartPeriodTabs value={period} onChange={setPeriod} />}
      />

      {summaryQuery.isLoading || !summary ? (
        <SkeletonCards />
      ) : (
        <div className="space-y-6">
          {/* Indicateurs clés */}
          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <KpiCard
              title="CA du jour"
              value={formatFCFA(summary.revenue.today)}
              icon={<IndianRupee className="h-5 w-5" />}
              accent={<TrendBadge value={summary.revenue.today_trend} caption="vs hier" />}
            />
            <KpiCard
              title="CA du mois"
              value={formatFCFA(summary.revenue.month)}
              icon={<TrendingUp className="h-5 w-5" />}
              accent={<TrendBadge value={summary.revenue.month_trend} caption="vs mois dernier" />}
            />
            <KpiCard
              title="Ventes du mois"
              value={formatNumber(summary.sales_count.month)}
              icon={<ShoppingCart className="h-5 w-5" />}
              footer={
                <>
                  · Panier moyen&nbsp;: <strong>{formatFCFA(summary.average_basket)}</strong>
                </>
              }
            />
            <KpiCard
              title="Valeur du stock"
              value={formatFCFA(summary.stock_value)}
              icon={<Boxes className="h-5 w-5" />}
              footer={
                <>
                  · {formatNumber(summary.products_count)} produits actifs ·{' '}
                  {formatNumber(summary.customers_count)} clients
                </>
              }
            />
          </div>

          {/* Graphiques */}
          <div className="grid gap-4 xl:grid-cols-3">
            <Card className="xl:col-span-2">
              <CardHeader className="pb-2">
                <CardTitle>Évolution du chiffre d'affaires</CardTitle>
                <CardDescription>
                  {period === '12m'
                    ? 'Total des ventes validées sur 12 mois'
                    : `Total des ventes validées sur ${period === '7d' ? '7 jours' : '30 jours'}`}
                </CardDescription>
              </CardHeader>
              <CardContent className="pb-5">
                {chartQuery.isLoading ? (
                  <Skeleton className="h-[280px] w-full" />
                ) : (
                  <div className="h-[280px] w-full">
                    <ResponsiveContainer width="100%" height="100%">
                      <AreaChart data={points} margin={{ top: 8, right: 8, left: 0, bottom: 0 }}>
                        <defs>
                          <linearGradient id="caFill" x1="0" y1="0" x2="0" y2="1">
                            <stop offset="0%" stopColor="#4F46E5" stopOpacity={0.35} />
                            <stop offset="100%" stopColor="#4F46E5" stopOpacity={0.02} />
                          </linearGradient>
                        </defs>
                        <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="hsl(var(--border))" />
                        <XAxis
                          dataKey="label"
                          tickLine={false}
                          axisLine={false}
                          minTickGap={28}
                          tick={{ fontSize: 11, fill: 'hsl(var(--muted-foreground))' }}
                        />
                        <YAxis
                          width={64}
                          tickLine={false}
                          axisLine={false}
                          tickFormatter={(value: number) => formatNumber(value)}
                          tick={{ fontSize: 11, fill: 'hsl(var(--muted-foreground))' }}
                        />
                        <Tooltip
                          cursor={{ stroke: 'hsl(var(--border))' }}
                          content={({ active, payload, label }) => {
                            if (!active || !payload?.length) return null;
                            const row = payload[0].payload as ChartPoint;
                            return (
                              <div className="rounded-md border bg-popover px-3 py-2 text-xs shadow-md">
                                <p className="font-medium">{label}</p>
                                <p className="mt-1 text-primary">{formatFCFA(row.total)}</p>
                                <p className="text-muted-foreground">
                                  {formatNumber(row.count)} vente(s)
                                </p>
                              </div>
                            );
                          }}
                        />
                        <Area
                          type="monotone"
                          dataKey="total"
                          stroke="#4F46E5"
                          strokeWidth={2}
                          fill="url(#caFill)"
                        />
                      </AreaChart>
                    </ResponsiveContainer>
                  </div>
                )}
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="pb-2">
                <CardTitle>Répartition par catégorie</CardTitle>
                <CardDescription>Part de chaque catégorie dans le CA</CardDescription>
              </CardHeader>
              <CardContent>
                {sharesQuery.isLoading ? (
                  <Skeleton className="h-[280px] w-full" />
                ) : shares.length === 0 ? (
                  <p className="py-10 text-center text-sm text-muted-foreground">
                    Aucune vente sur la période.
                  </p>
                ) : (
                  <div className="space-y-4">
                    <div className="h-[170px] w-full">
                      <ResponsiveContainer width="100%" height="100%">
                        <PieChart>
                          <Pie
                            data={shares}
                            dataKey="revenue"
                            nameKey="name"
                            innerRadius={52}
                            outerRadius={80}
                            paddingAngle={2}
                            stroke="none"
                          >
                            {shares.map((_, index) => (
                              <Cell key={index} fill={PIE_COLORS[index % PIE_COLORS.length]} />
                            ))}
                          </Pie>
                          <Tooltip
                            content={({ active, payload }) => {
                              if (!active || !payload?.length) return null;
                              const row = payload[0].payload as CategoryShare;
                              return (
                                <div className="rounded-md border bg-popover px-3 py-2 text-xs shadow-md">
                                  <p className="font-medium">{row.name}</p>
                                  <p className="mt-1 text-primary">{formatFCFA(row.revenue)}</p>
                                  <p className="text-muted-foreground">
                                    {formatPercent(row.percentage)}
                                  </p>
                                </div>
                              );
                            }}
                          />
                        </PieChart>
                      </ResponsiveContainer>
                    </div>
                    <ul className="space-y-2">
                      {shares.slice(0, 5).map((share, index) => (
                        <li key={share.category_id} className="flex items-center gap-2 text-sm">
                          <span
                            className="h-2.5 w-2.5 shrink-0 rounded-full"
                            style={{ backgroundColor: PIE_COLORS[index % PIE_COLORS.length] }}
                          />
                          <span className="min-w-0 flex-1 truncate">{share.name}</span>
                          <span className="font-medium">{formatPercent(share.percentage)}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
              </CardContent>
            </Card>
          </div>

          {/* Ventes récentes + meilleures ventes */}
          <div className="grid gap-4 xl:grid-cols-3">
            <Card className="xl:col-span-2">
              <CardHeader className="pb-3">
                <CardTitle>Ventes récentes</CardTitle>
                <CardDescription>Les dernières ventes enregistrées</CardDescription>
              </CardHeader>
              <CardContent>
                {recentSalesQuery.isLoading ? (
                  <div className="space-y-2">
                    {Array.from({ length: 4 }).map((_, i) => (
                      <Skeleton key={i} className="h-10 w-full" />
                    ))}
                  </div>
                ) : recentSales.length === 0 ? (
                  <p className="py-8 text-center text-sm text-muted-foreground">
                    Aucune vente enregistrée pour le moment.
                  </p>
                ) : (
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>Référence</TableHead>
                        <TableHead className="hidden sm:table-cell">Client</TableHead>
                        <TableHead className="hidden md:table-cell">Vendeur</TableHead>
                        <TableHead className="text-right">Total</TableHead>
                        <TableHead className="hidden sm:table-cell">Statut</TableHead>
                        <TableHead className="hidden lg:table-cell">Date</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {recentSales.map((sale) => (
                        <TableRow key={sale.id}>
                          <TableCell className="font-medium">{sale.reference}</TableCell>
                          <TableCell className="hidden sm:table-cell">
                            {sale.customer?.name ?? 'Client de passage'}
                          </TableCell>
                          <TableCell className="hidden md:table-cell">
                            {sale.user?.name ?? '—'}
                          </TableCell>
                          <TableCell className="text-right font-semibold">
                            {formatFCFA(sale.total)}
                          </TableCell>
                          <TableCell className="hidden sm:table-cell">
                            <Badge variant={sale.status === 'validee' ? 'success' : 'destructive'}>
                              {sale.status_label}
                            </Badge>
                          </TableCell>
                          <TableCell className="hidden whitespace-nowrap text-muted-foreground lg:table-cell">
                            {formatDateTime(sale.sold_at)}
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                )}
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="pb-3">
                <CardTitle>Meilleures ventes</CardTitle>
                <CardDescription>Produits les plus rentables</CardDescription>
              </CardHeader>
              <CardContent>
                {topProductsQuery.isLoading ? (
                  <div className="space-y-3">
                    {Array.from({ length: 4 }).map((_, i) => (
                      <Skeleton key={i} className="h-12 w-full" />
                    ))}
                  </div>
                ) : topProducts.length === 0 ? (
                  <p className="py-8 text-center text-sm text-muted-foreground">
                    Aucune vente sur la période.
                  </p>
                ) : (
                  <ol className="space-y-3">
                    {topProducts.map((product, index) => (
                      <li
                        key={product.product_id}
                        className="flex items-center gap-3 rounded-lg border p-3"
                      >
                        <span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-primary/10 text-xs font-bold text-primary">
                          {index + 1}
                        </span>
                        <div className="min-w-0 flex-1">
                          <p className="truncate text-sm font-medium">{product.name}</p>
                          <p className="text-xs text-muted-foreground">
                            {product.sku} · {formatNumber(product.quantity)} vendu(s)
                          </p>
                        </div>
                        <span className="shrink-0 text-sm font-semibold">
                          {formatFCFA(product.revenue)}
                        </span>
                      </li>
                    ))}
                  </ol>
                )}
              </CardContent>
            </Card>
          </div>

          {/* Alertes de stock */}
          <Card>
            <CardHeader className="pb-3 sm:flex-row sm:items-center sm:justify-between">
              <div>
                <CardTitle className="flex items-center gap-2">
                  <AlertTriangle className="h-4 w-4 text-warning" />
                  Alertes de stock
                </CardTitle>
                <CardDescription>
                  {formatNumber(summary.low_stock_count)} produit(s) en alerte ·{' '}
                  {formatNumber(summary.out_of_stock_count)} en rupture
                </CardDescription>
              </div>
              <Button variant="outline" size="sm" asChild>
                <Link to="/produits?status=low">
                  Voir les produits en alerte
                  <ChevronRight />
                </Link>
              </Button>
            </CardHeader>
            <CardContent>
              {lowStockQuery.isLoading ? (
                <div className="space-y-2">
                  {Array.from({ length: 3 }).map((_, i) => (
                    <Skeleton key={i} className="h-10 w-full" />
                  ))}
                </div>
              ) : lowStock.length === 0 ? (
                <div className="flex items-center gap-2 rounded-lg border border-success/30 bg-success/10 px-4 py-3 text-sm text-success">
                  <Boxes className="h-4 w-4" />
                  Tous vos produits sont au-dessus de leur seuil d'alerte.
                </div>
              ) : (
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Produit</TableHead>
                      <TableHead className="hidden sm:table-cell">SKU</TableHead>
                      <TableHead className="hidden sm:table-cell">Catégorie</TableHead>
                      <TableHead className="text-right">Stock</TableHead>
                      <TableHead className="text-right">Seuil</TableHead>
                      <TableHead>État</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {lowStock.map((product) => (
                      <TableRow key={product.id}>
                        <TableCell className="font-medium">{product.name}</TableCell>
                        <TableCell className="hidden font-mono text-xs sm:table-cell">
                          {product.sku}
                        </TableCell>
                        <TableCell className="hidden sm:table-cell">
                          {product.category?.name ?? '—'}
                        </TableCell>
                        <TableCell className="text-right font-semibold">
                          {formatNumber(product.quantity)}
                        </TableCell>
                        <TableCell className="text-right text-muted-foreground">
                          {formatNumber(product.low_stock_threshold)}
                        </TableCell>
                        <TableCell>
                          {product.quantity <= 0 ? (
                            <Badge variant="destructive">Rupture</Badge>
                          ) : (
                            <Badge variant="warning">Stock bas</Badge>
                          )}
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              )}
            </CardContent>
          </Card>
        </div>
      )}
    </>
  );
}
