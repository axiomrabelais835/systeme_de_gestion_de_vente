import { keepPreviousData, useQuery } from '@tanstack/react-query';
import { ArrowLeftRight, Download } from 'lucide-react';
import { useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { toast } from 'sonner';

import { ErrorState } from '@/components/ErrorState';
import { PageHeader } from '@/components/layout/PageHeader';
import { Pagination } from '@/components/Pagination';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Skeleton } from '@/components/ui/skeleton';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { api, apiGet } from '@/lib/api';
import { formatDateTime, formatNumber } from '@/lib/format';
import type { MovementType, Product, StockMovement } from '@/lib/types';

const PER_PAGE = 20;
const ALL = 'all';

const TYPE_OPTIONS = [
  { value: ALL, label: 'Tous les types' },
  { value: 'entree', label: 'Entrée' },
  { value: 'sortie', label: 'Sortie' },
  { value: 'ajustement', label: 'Ajustement' },
  { value: 'annulation', label: 'Annulation' },
];

/** Couleur du badge par type de mouvement. */
const TYPE_BADGE: Record<
  MovementType,
  { variant: 'success' | 'destructive' | 'warning' | 'secondary'; label: string }
> = {
  entree: { variant: 'success', label: 'Entrée' },
  sortie: { variant: 'destructive', label: 'Sortie' },
  ajustement: { variant: 'warning', label: 'Ajustement' },
  annulation: { variant: 'secondary', label: 'Annulation' },
};

/* ---------------------------------- Page ---------------------------------- */

export default function StockMovementsPage() {
  const [searchParams, setSearchParams] = useSearchParams();

  // Filtres pilotés par l'URL : le journal est partageable.
  const productId = searchParams.get('product_id') ?? ALL;
  const type = searchParams.get('type') ?? ALL;
  const dateFrom = searchParams.get('date_from') ?? '';
  const dateTo = searchParams.get('date_to') ?? '';
  const page = Math.max(Number(searchParams.get('page') ?? '1') || 1, 1);

  const [exporting, setExporting] = useState(false);

  const setFilter = (key: string, value: string) => {
    setSearchParams((prev) => {
      const next = new URLSearchParams(prev);
      if (value && value !== ALL) next.set(key, value);
      else next.delete(key);
      // Toute modification de filtre revient à la première page.
      if (key !== 'page') next.delete('page');
      return next;
    });
  };

  const resetFilters = () => setSearchParams(new URLSearchParams());
  const hasFilters = productId !== ALL || type !== ALL || Boolean(dateFrom || dateTo);

  const params = useMemo(
    () => ({
      product_id: productId !== ALL ? Number(productId) : undefined,
      type: type !== ALL ? type : undefined,
      date_from: dateFrom || undefined,
      date_to: dateTo || undefined,
      page,
      per_page: PER_PAGE,
    }),
    [productId, type, dateFrom, dateTo, page],
  );

  const productsQuery = useQuery({
    queryKey: ['products', 'options'],
    queryFn: () => apiGet<Product[]>('/products', { per_page: 100, sort: 'name' }),
    staleTime: 60_000,
  });

  const movementsQuery = useQuery({
    queryKey: ['stock-movements', 'list', params],
    queryFn: () => apiGet<StockMovement[]>('/stock-movements', params),
    placeholderData: keepPreviousData,
  });

  /** Export CSV du journal correspondant aux filtres (jeton porté par l'en-tête). */
  const exportCsv = async () => {
    setExporting(true);
    try {
      const { data } = await api.get('/stock-movements/export', { params, responseType: 'blob' });
      const url = URL.createObjectURL(new Blob([data], { type: 'text/csv;charset=utf-8;' }));
      const link = document.createElement('a');
      link.href = url;
      link.download = `mouvements-${new Date().toISOString().slice(0, 10)}.csv`;
      document.body.appendChild(link);
      link.click();
      link.remove();
      window.setTimeout(() => URL.revokeObjectURL(url), 1_000);
      toast.success('Export CSV téléchargé.');
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "L'export a échoué.");
    } finally {
      setExporting(false);
    }
  };

  const movements = movementsQuery.data?.data ?? [];

  return (
    <>
      <PageHeader
        title="Mouvements de stock"
        description="Journal complet des entrées, sorties, ventes et annulations."
        actions={
          <Button
            variant="outline"
            onClick={() => void exportCsv()}
            disabled={exporting || movements.length === 0}
          >
            <Download />
            {exporting ? 'Export…' : 'Exporter (CSV)'}
          </Button>
        }
      />

      {/* Filtres */}
      <div className="mb-4 flex flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-center">
        <Select value={productId} onValueChange={(value) => setFilter('product_id', value)}>
          <SelectTrigger className="w-full sm:w-64">
            <SelectValue placeholder="Produit" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={ALL}>Tous les produits</SelectItem>
            {productsQuery.data?.data.map((product) => (
              <SelectItem key={product.id} value={String(product.id)}>
                {product.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select value={type} onValueChange={(value) => setFilter('type', value)}>
          <SelectTrigger className="w-full sm:w-48">
            <SelectValue placeholder="Type" />
          </SelectTrigger>
          <SelectContent>
            {TYPE_OPTIONS.map((option) => (
              <SelectItem key={option.value} value={option.value}>
                {option.label}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <div className="flex items-center gap-2">
          <Input
            type="date"
            aria-label="Date de début"
            value={dateFrom}
            onChange={(event) => setFilter('date_from', event.target.value)}
            className="w-full sm:w-40"
          />
          <span className="text-sm text-muted-foreground">au</span>
          <Input
            type="date"
            aria-label="Date de fin"
            value={dateTo}
            onChange={(event) => setFilter('date_to', event.target.value)}
            className="w-full sm:w-40"
          />
        </div>
        {hasFilters ? (
          <Button variant="ghost" size="sm" onClick={resetFilters}>
            Réinitialiser
          </Button>
        ) : null}
      </div>

      {movementsQuery.isError ? (
        <ErrorState
          message={movementsQuery.error?.message ?? 'Impossible de charger les mouvements.'}
          onRetry={() => void movementsQuery.refetch()}
        />
      ) : (
        <Card>
          <CardContent className="p-0">
            {movementsQuery.isLoading ? (
              <div className="space-y-2 p-4">
                {Array.from({ length: 8 }).map((_, i) => (
                  <Skeleton key={i} className="h-12 w-full" />
                ))}
              </div>
            ) : movements.length === 0 ? (
              <div className="flex flex-col items-center gap-2 p-10 text-center">
                <ArrowLeftRight className="h-8 w-8 text-muted-foreground" />
                <p className="font-medium">
                  {hasFilters
                    ? 'Aucun mouvement ne correspond à vos filtres.'
                    : 'Aucun mouvement de stock pour le moment.'}
                </p>
                <p className="max-w-md text-sm text-muted-foreground">
                  {hasFilters
                    ? 'Essayez de modifier ou de réinitialiser vos critères.'
                    : "Chaque vente, annulation et ajustement s'affichera ici automatiquement."}
                </p>
                {hasFilters ? (
                  <Button variant="outline" size="sm" onClick={resetFilters}>
                    Réinitialiser les filtres
                  </Button>
                ) : null}
              </div>
            ) : (
              <>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead className="hidden sm:table-cell">Date</TableHead>
                      <TableHead>Produit</TableHead>
                      <TableHead>Type</TableHead>
                      <TableHead className="text-right">Quantité</TableHead>
                      <TableHead className="hidden md:table-cell">Motif / Référence</TableHead>
                      <TableHead className="hidden lg:table-cell">Opérateur</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {movements.map((movement) => {
                      const badge = TYPE_BADGE[movement.type] ?? TYPE_BADGE.ajustement;
                      const isIncrease = movement.quantity > 0;
                      return (
                        <TableRow key={movement.id}>
                          <TableCell className="hidden sm:table-cell">
                            <span className="text-sm">{formatDateTime(movement.created_at)}</span>
                          </TableCell>
                          <TableCell>
                            <span className="font-medium">
                              {movement.product?.name ?? `Produit #${movement.product_id}`}
                            </span>
                            {movement.product?.sku ? (
                              <span className="block font-mono text-xs text-muted-foreground">
                                {movement.product.sku}
                              </span>
                            ) : null}
                          </TableCell>
                          <TableCell>
                            <Badge variant={badge.variant}>{badge.label}</Badge>
                          </TableCell>
                          <TableCell
                            className={`text-right font-semibold ${
                              isIncrease ? 'text-emerald-600 dark:text-emerald-400' : ''
                            }`}
                          >
                            {isIncrease ? '+' : ''}
                            {formatNumber(movement.quantity)}
                          </TableCell>
                          <TableCell className="hidden md:table-cell">
                            <span className="text-sm text-muted-foreground">
                              {movement.reason ?? '—'}
                            </span>
                            {movement.reference ? (
                              <span className="block font-mono text-xs text-muted-foreground">
                                {movement.reference}
                              </span>
                            ) : null}
                          </TableCell>
                          <TableCell className="hidden lg:table-cell">
                            <span className="text-sm text-muted-foreground">
                              {movement.user?.name ?? '—'}
                            </span>
                          </TableCell>
                        </TableRow>
                      );
                    })}
                  </TableBody>
                </Table>

                <div className="border-t p-4">
                  <Pagination
                    meta={movementsQuery.data?.meta}
                    onPageChange={(p) => setFilter('page', String(p))}
                    isFetching={movementsQuery.isFetching}
                  />
                </div>
              </>
            )}
          </CardContent>
        </Card>
      )}
    </>
  );
}
