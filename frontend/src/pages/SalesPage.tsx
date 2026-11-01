import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { Ban, Download, Eye, Plus, ReceiptText } from 'lucide-react';
import { useMemo, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { toast } from 'sonner';

import { ConfirmDialog } from '@/components/ConfirmDialog';
import { ErrorState } from '@/components/ErrorState';
import { PageHeader } from '@/components/layout/PageHeader';
import { Pagination } from '@/components/Pagination';
import { SearchInput } from '@/components/SearchInput';
import { SaleDetailDialog } from '@/components/sales/SaleDetailDialog';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
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
import { Textarea } from '@/components/ui/textarea';
import { api, apiGet, apiPost } from '@/lib/api';
import { formatDateTime, formatFCFA, formatNumber } from '@/lib/format';
import type { Sale } from '@/lib/types';

const PER_PAGE = 15;
const ALL = 'all';
const REASON_MAX = 255;

const STATUS_OPTIONS = [
  { value: ALL, label: 'Tous les statuts' },
  { value: 'validee', label: 'Validées' },
  { value: 'annulee', label: 'Annulées' },
];

const PAYMENT_OPTIONS = [
  { value: ALL, label: 'Tous les paiements' },
  { value: 'especes', label: 'Espèces' },
  { value: 'mobile_money', label: 'Mobile Money' },
  { value: 'carte', label: 'Carte bancaire' },
  { value: 'virement', label: 'Virement' },
];

/* ---------------------------------- Page ---------------------------------- */

export default function SalesPage() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [searchParams, setSearchParams] = useSearchParams();

  // Filtres pilotés par l'URL : l'historique est partageable.
  const q = searchParams.get('q') ?? '';
  const status = searchParams.get('status') ?? ALL;
  const paymentMethod = searchParams.get('payment_method') ?? ALL;
  const dateFrom = searchParams.get('date_from') ?? '';
  const dateTo = searchParams.get('date_to') ?? '';
  const page = Math.max(Number(searchParams.get('page') ?? '1') || 1, 1);

  const [detailId, setDetailId] = useState<number | null>(null);
  const [cancelSale, setCancelSale] = useState<Sale | null>(null);
  const [cancelReason, setCancelReason] = useState('');
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

  const hasFilters = Boolean(q || dateFrom || dateTo || status !== ALL || paymentMethod !== ALL);

  const resetFilters = () => setSearchParams(new URLSearchParams());

  const params = useMemo(
    () => ({
      q: q || undefined,
      status: status !== ALL ? status : undefined,
      payment_method: paymentMethod !== ALL ? paymentMethod : undefined,
      date_from: dateFrom || undefined,
      date_to: dateTo || undefined,
      sort: '-sold_at',
      page,
      per_page: PER_PAGE,
    }),
    [q, status, paymentMethod, dateFrom, dateTo, page],
  );

  const salesQuery = useQuery({
    queryKey: ['sales', 'list', params],
    queryFn: () => apiGet<Sale[]>('/sales', params),
    placeholderData: keepPreviousData,
  });

  const invalidate = () => {
    void queryClient.invalidateQueries({ queryKey: ['sales'] });
    void queryClient.invalidateQueries({ queryKey: ['products'] });
    void queryClient.invalidateQueries({ queryKey: ['dashboard'] });
  };

  const cancelMutation = useMutation({
    mutationFn: ({ id, reason }: { id: number; reason: string }) =>
      apiPost<Sale>(`/sales/${id}/cancel`, { reason: reason.trim() || null }),
    onSuccess: (sale) => {
      // Le serveur a réintégré le stock : on le signale explicitement.
      toast.success(`Vente ${sale.reference} annulée — le stock a été réintégré.`);
      setCancelSale(null);
      setCancelReason('');
      invalidate();
    },
    onError: (error: Error) => toast.error(error.message),
  });

  /** Export CSV des ventes correspondant aux filtres (jeton porté par l'en-tête). */
  const exportCsv = async () => {
    setExporting(true);
    try {
      const { data } = await api.get('/sales/export', { params, responseType: 'blob' });
      const url = URL.createObjectURL(new Blob([data], { type: 'text/csv;charset=utf-8;' }));
      const link = document.createElement('a');
      link.href = url;
      link.download = `ventes-${new Date().toISOString().slice(0, 10)}.csv`;
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

  const sales = salesQuery.data?.data ?? [];

  return (
    <>
      <PageHeader
        title="Ventes"
        description="Encaissement, historique des ventes et annulations."
        actions={
          <>
            <Button
              variant="outline"
              onClick={() => void exportCsv()}
              disabled={exporting || sales.length === 0}
            >
              <Download />
              {exporting ? 'Export…' : 'Exporter (CSV)'}
            </Button>
            <Button onClick={() => navigate('/ventes/nouvelle')}>
              <Plus />
              Nouvelle vente
            </Button>
          </>
        }
      />

      {/* Filtres */}
      <div className="mb-4 flex flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-end">
        <SearchInput
          value={q}
          onValueChange={(value) => setFilter('q', value)}
          placeholder="Référence (ex. : VTE-2026)…"
          className="w-full sm:w-64"
        />
        <div className="flex flex-col gap-1">
          <Label className="text-xs text-muted-foreground">Statut</Label>
          <Select value={status} onValueChange={(value) => setFilter('status', value)}>
            <SelectTrigger className="w-full sm:w-40">
              <SelectValue placeholder="Statut" />
            </SelectTrigger>
            <SelectContent>
              {STATUS_OPTIONS.map((option) => (
                <SelectItem key={option.value} value={option.value}>
                  {option.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <div className="flex flex-col gap-1">
          <Label className="text-xs text-muted-foreground">Paiement</Label>
          <Select value={paymentMethod} onValueChange={(value) => setFilter('payment_method', value)}>
            <SelectTrigger className="w-full sm:w-48">
              <SelectValue placeholder="Paiement" />
            </SelectTrigger>
            <SelectContent>
              {PAYMENT_OPTIONS.map((option) => (
                <SelectItem key={option.value} value={option.value}>
                  {option.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <div className="flex flex-col gap-1">
          <Label className="text-xs text-muted-foreground" htmlFor="sale-date-from">
            Du
          </Label>
          <Input
            id="sale-date-from"
            type="date"
            value={dateFrom}
            max={dateTo || undefined}
            onChange={(event) => setFilter('date_from', event.target.value)}
            className="w-full sm:w-40"
          />
        </div>
        <div className="flex flex-col gap-1">
          <Label className="text-xs text-muted-foreground" htmlFor="sale-date-to">
            Au
          </Label>
          <Input
            id="sale-date-to"
            type="date"
            value={dateTo}
            min={dateFrom || undefined}
            onChange={(event) => setFilter('date_to', event.target.value)}
            className="w-full sm:w-40"
          />
        </div>
        {hasFilters ? (
          <Button variant="ghost" size="sm" onClick={resetFilters} className="sm:mb-0.5">
            Réinitialiser
          </Button>
        ) : null}
      </div>

      {salesQuery.isError ? (
        <ErrorState
          message={salesQuery.error?.message ?? 'Impossible de charger les ventes.'}
          onRetry={() => void salesQuery.refetch()}
        />
      ) : (
        <Card>
          <CardContent className="p-0">
            {salesQuery.isLoading ? (
              <div className="space-y-2 p-4">
                {Array.from({ length: 6 }).map((_, i) => (
                  <Skeleton key={i} className="h-12 w-full" />
                ))}
              </div>
            ) : sales.length === 0 ? (
              <div className="flex flex-col items-center gap-2 p-10 text-center">
                <ReceiptText className="h-8 w-8 text-muted-foreground" />
                <p className="font-medium">
                  {hasFilters
                    ? 'Aucune vente ne correspond à vos filtres.'
                    : 'Aucune vente enregistrée pour le moment.'}
                </p>
                <p className="max-w-md text-sm text-muted-foreground">
                  {hasFilters
                    ? 'Élargissez la période ou réinitialisez les filtres.'
                    : 'Créez une vente pour démarrer l’encaissement.'}
                </p>
              </div>
            ) : (
              <>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Référence</TableHead>
                      <TableHead className="hidden sm:table-cell">Client</TableHead>
                      <TableHead className="hidden md:table-cell">Vendeur</TableHead>
                      <TableHead className="hidden lg:table-cell">Paiement</TableHead>
                      <TableHead className="text-right">Articles</TableHead>
                      <TableHead className="text-right">Total</TableHead>
                      <TableHead>Statut</TableHead>
                      <TableHead className="w-24 text-right">Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {sales.map((sale) => (
                      <TableRow key={sale.id}>
                        <TableCell>
                          <span className="font-medium">{sale.reference}</span>
                          <span className="block text-xs text-muted-foreground">
                            {formatDateTime(sale.sold_at)}
                          </span>
                        </TableCell>
                        <TableCell className="hidden sm:table-cell">
                          {sale.customer?.name ?? (
                            <span className="text-muted-foreground">Client de passage</span>
                          )}
                        </TableCell>
                        <TableCell className="hidden md:table-cell text-muted-foreground">
                          {sale.user?.name ?? '—'}
                        </TableCell>
                        <TableCell className="hidden lg:table-cell">
                          <span className="text-sm">{sale.payment_method_label}</span>
                          <span className="block text-xs text-muted-foreground">
                            {sale.payment_status_label}
                          </span>
                        </TableCell>
                        <TableCell className="text-right">
                          <Badge variant="secondary">{formatNumber(sale.items_count ?? 0)}</Badge>
                        </TableCell>
                        <TableCell className="text-right font-semibold">
                          {formatFCFA(sale.total)}
                        </TableCell>
                        <TableCell>
                          <Badge variant={sale.status === 'validee' ? 'success' : 'destructive'}>
                            {sale.status_label}
                          </Badge>
                        </TableCell>
                        <TableCell className="text-right">
                          <div className="flex items-center justify-end gap-1">
                            <Button
                              variant="ghost"
                              size="icon-sm"
                              onClick={() => setDetailId(sale.id)}
                              aria-label={`Voir le détail de ${sale.reference}`}
                            >
                              <Eye />
                            </Button>
                            {sale.status === 'validee' ? (
                              <Button
                                variant="ghost"
                                size="icon-sm"
                                onClick={() => {
                                  setCancelReason('');
                                  setCancelSale(sale);
                                }}
                                aria-label={`Annuler la vente ${sale.reference}`}
                                className="text-destructive hover:bg-destructive/10 hover:text-destructive"
                              >
                                <Ban />
                              </Button>
                            ) : null}
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>

                <div className="border-t p-4">
                  <Pagination
                    meta={salesQuery.data?.meta}
                    onPageChange={(p) => setFilter('page', String(p))}
                    isFetching={salesQuery.isFetching}
                  />
                </div>
              </>
            )}
          </CardContent>
        </Card>
      )}

      {/* Détail d'une vente */}
      <SaleDetailDialog
        saleId={detailId}
        open={detailId !== null}
        onOpenChange={(open) => {
          if (!open) setDetailId(null);
        }}
        onRequestCancel={(sale) => {
          setDetailId(null);
          setCancelReason('');
          setCancelSale(sale);
        }}
      />

      {/* Confirmation d'annulation (le stock est réintégré par le serveur) */}
      <ConfirmDialog
        open={cancelSale !== null}
        onOpenChange={(open) => {
          if (!open) {
            setCancelSale(null);
            setCancelReason('');
          }
        }}
        title="Annuler la vente"
        description={
          cancelSale
            ? `Voulez-vous annuler la vente ${cancelSale.reference} (${formatFCFA(cancelSale.total)}) ? Le stock des articles sera automatiquement réintégré.`
            : ''
        }
        confirmLabel="Annuler la vente"
        loading={cancelMutation.isPending}
        onConfirm={() => {
          if (cancelSale) cancelMutation.mutate({ id: cancelSale.id, reason: cancelReason });
        }}
      >
        <div className="space-y-1.5">
          <Label htmlFor="cancel-reason">Motif d'annulation (facultatif)</Label>
          <Textarea
            id="cancel-reason"
            rows={2}
            maxLength={REASON_MAX}
            value={cancelReason}
            onChange={(event) => setCancelReason(event.target.value)}
            placeholder="Ex. : produit défectueux, erreur de saisie…"
          />
          <p className="text-xs text-muted-foreground">
            {cancelReason.length} / {REASON_MAX} caractères
          </p>
        </div>
      </ConfirmDialog>
    </>
  );
}
