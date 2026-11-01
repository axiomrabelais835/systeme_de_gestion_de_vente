import { useQuery } from '@tanstack/react-query';
import { UserRound } from 'lucide-react';
import { useState } from 'react';

import { ErrorState } from '@/components/ErrorState';
import { Pagination } from '@/components/Pagination';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Skeleton } from '@/components/ui/skeleton';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { apiGet, type PaginationMeta } from '@/lib/api';
import { formatDate, formatDateTime, formatFCFA } from '@/lib/format';
import type { Customer, Sale } from '@/lib/types';

/** Réponse de GET /customers/{id} : fiche + historique paginé. */
interface CustomerShowResponse {
  customer: Customer;
  sales: Sale[];
  sales_meta: PaginationMeta;
}

interface CustomerDetailDialogProps {
  customerId: number | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

/** Fiche client : coordonnées, agrégats calculés par le serveur, historique d'achats. */
export function CustomerDetailDialog({ customerId, open, onOpenChange }: CustomerDetailDialogProps) {
  const [salesPage, setSalesPage] = useState(1);

  const query = useQuery({
    queryKey: ['customers', 'detail', customerId, salesPage],
    queryFn: () =>
      apiGet<CustomerShowResponse>(`/customers/${customerId}`, {
        page: salesPage,
        per_page: 10,
      }).then((r) => r.data),
    enabled: open && customerId !== null,
    placeholderData: (previous) => previous,
  });

  const data = query.data;
  const customer = data?.customer;
  const sales = data?.sales ?? [];
  const averageBasket =
    customer && customer.sales_count ? (customer.total_spent ?? 0) / customer.sales_count : 0;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-h-[85vh] overflow-y-auto sm:max-w-2xl">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2 pr-8">
            <UserRound className="h-5 w-5 text-primary" />
            {customer ? customer.name : 'Fiche client'}
          </DialogTitle>
          <DialogDescription>
            {customer ? `Client depuis le ${formatDate(customer.created_at)}` : 'Chargement…'}
          </DialogDescription>
        </DialogHeader>

        {query.isLoading ? (
          <div className="space-y-3">
            <Skeleton className="h-6 w-1/2" />
            <Skeleton className="h-24 w-full" />
            <Skeleton className="h-24 w-full" />
          </div>
        ) : query.isError || !customer ? (
          <ErrorState
            message={query.error?.message ?? 'Impossible de charger la fiche de ce client.'}
            onRetry={() => void query.refetch()}
          />
        ) : (
          <div className="space-y-4">
            {/* Coordonnées */}
            <dl className="grid grid-cols-1 gap-x-6 gap-y-2 rounded-lg border bg-muted/30 p-4 text-sm sm:grid-cols-2">
              <div className="flex justify-between gap-3">
                <dt className="text-muted-foreground">E-mail</dt>
                <dd className="font-medium">{customer.email ?? '—'}</dd>
              </div>
              <div className="flex justify-between gap-3">
                <dt className="text-muted-foreground">Téléphone</dt>
                <dd className="font-medium">{customer.phone ?? '—'}</dd>
              </div>
              <div className="flex justify-between gap-3 sm:col-span-2">
                <dt className="text-muted-foreground">Adresse</dt>
                <dd className="font-medium">{customer.address ?? '—'}</dd>
              </div>
              {customer.notes ? (
                <div className="flex justify-between gap-3 sm:col-span-2">
                  <dt className="text-muted-foreground">Notes</dt>
                  <dd className="max-w-md text-right font-medium">{customer.notes}</dd>
                </div>
              ) : null}
            </dl>

            {/* Agrégats calculés par le serveur (ventes validées uniquement) */}
            <dl className="grid grid-cols-1 gap-3 sm:grid-cols-3">
              <div className="rounded-lg border p-3">
                <dt className="text-xs text-muted-foreground">Total dépensé</dt>
                <dd className="text-lg font-semibold">{formatFCFA(customer.total_spent ?? 0)}</dd>
              </div>
              <div className="rounded-lg border p-3">
                <dt className="text-xs text-muted-foreground">Ventes validées</dt>
                <dd className="text-lg font-semibold">{customer.sales_count ?? 0}</dd>
              </div>
              <div className="rounded-lg border p-3">
                <dt className="text-xs text-muted-foreground">Panier moyen</dt>
                <dd className="text-lg font-semibold">{formatFCFA(averageBasket)}</dd>
              </div>
            </dl>

            {/* Historique d'achats */}
            <div>
              <h3 className="mb-2 text-sm font-medium">Historique d'achats</h3>
              {sales.length === 0 ? (
                <p className="rounded-lg border border-dashed p-6 text-center text-sm text-muted-foreground">
                  {salesPage > 1
                    ? 'Aucun achat sur cette page.'
                    : 'Aucun achat enregistré pour ce client.'}
                </p>
              ) : (
                <div className="rounded-lg border">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>Référence</TableHead>
                        <TableHead className="hidden sm:table-cell">Date</TableHead>
                        <TableHead className="text-right">Total</TableHead>
                        <TableHead className="text-right">Statut</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {sales.map((sale) => (
                        <TableRow key={sale.id}>
                          <TableCell className="font-medium">{sale.reference}</TableCell>
                          <TableCell className="hidden sm:table-cell">
                            {formatDateTime(sale.sold_at)}
                          </TableCell>
                          <TableCell className="text-right font-semibold">
                            {formatFCFA(sale.total)}
                          </TableCell>
                          <TableCell className="text-right">
                            <Badge variant={sale.status === 'validee' ? 'success' : 'destructive'}>
                              {sale.status_label}
                            </Badge>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </div>
              )}
              {(data?.sales_meta?.total ?? 0) > 10 ? (
                <div className="mt-2">
                  <Pagination
                    meta={data?.sales_meta}
                    onPageChange={setSalesPage}
                    isFetching={query.isFetching}
                  />
                </div>
              ) : null}
            </div>
          </div>
        )}

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)}>
            Fermer
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
