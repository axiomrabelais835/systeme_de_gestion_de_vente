import { useQuery } from '@tanstack/react-query';
import { Ban, ReceiptText } from 'lucide-react';

import { ErrorState } from '@/components/ErrorState';
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
import { apiGet } from '@/lib/api';
import { formatDateTime, formatFCFA, formatNumber } from '@/lib/format';
import type { Sale } from '@/lib/types';

interface SaleDetailDialogProps {
  saleId: number | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  /** Demande d'annulation : la vente est transmise pour confirmation. */
  onRequestCancel: (sale: Sale) => void;
}

/** Détail complet d'une vente : articles figés, montants calculés par le serveur. */
export function SaleDetailDialog({
  saleId,
  open,
  onOpenChange,
  onRequestCancel,
}: SaleDetailDialogProps) {
  const query = useQuery({
    queryKey: ['sales', 'detail', saleId],
    queryFn: () => apiGet<Sale>(`/sales/${saleId}`).then((r) => r.data),
    enabled: open && saleId !== null,
  });

  const sale = query.data;
  const canCancel = sale?.status === 'validee';

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-h-[85vh] overflow-y-auto sm:max-w-2xl">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2 pr-8">
            <ReceiptText className="h-5 w-5 text-primary" />
            {sale ? sale.reference : 'Détail de la vente'}
          </DialogTitle>
          <DialogDescription>
            {sale
              ? `${formatDateTime(sale.sold_at)} · ${sale.items_count ?? sale.items?.length ?? 0} article(s)`
              : 'Chargement…'}
          </DialogDescription>
        </DialogHeader>

        {query.isLoading ? (
          <div className="space-y-3">
            <Skeleton className="h-6 w-1/2" />
            <Skeleton className="h-24 w-full" />
            <Skeleton className="h-24 w-full" />
          </div>
        ) : query.isError || !sale ? (
          <ErrorState
            message={query.error?.message ?? 'Impossible de charger le détail de cette vente.'}
            onRetry={() => void query.refetch()}
          />
        ) : (
          <div className="space-y-4">
            {/* Badges d'état */}
            <div className="flex flex-wrap items-center gap-2">
              <Badge variant={sale.status === 'validee' ? 'success' : 'destructive'}>
                {sale.status_label}
              </Badge>
              <Badge variant="muted">{sale.payment_method_label}</Badge>
              <Badge variant={sale.payment_status === 'payee' ? 'secondary' : 'warning'}>
                {sale.payment_status_label}
              </Badge>
            </div>

            {/* Informations */}
            <dl className="grid grid-cols-1 gap-x-6 gap-y-2 rounded-lg border bg-muted/30 p-4 text-sm sm:grid-cols-2">
              <div className="flex justify-between gap-3">
                <dt className="text-muted-foreground">Client</dt>
                <dd className="font-medium">{sale.customer?.name ?? 'Client de passage'}</dd>
              </div>
              <div className="flex justify-between gap-3">
                <dt className="text-muted-foreground">Vendeur</dt>
                <dd className="font-medium">{sale.user?.name ?? '—'}</dd>
              </div>
              <div className="flex justify-between gap-3">
                <dt className="text-muted-foreground">Date de vente</dt>
                <dd className="font-medium">{formatDateTime(sale.sold_at)}</dd>
              </div>
              {sale.status === 'annulee' ? (
                <div className="flex justify-between gap-3 sm:col-span-2">
                  <dt className="text-muted-foreground">Annulée le</dt>
                  <dd className="text-right font-medium">
                    {formatDateTime(sale.cancelled_at)}
                    {sale.cancel_reason ? (
                      <span className="block text-xs font-normal text-muted-foreground">
                        Motif : {sale.cancel_reason}
                      </span>
                    ) : null}
                  </dd>
                </div>
              ) : null}
            </dl>

            {/* Articles (prix figés au moment de la vente) */}
            <div className="rounded-lg border">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Produit</TableHead>
                    <TableHead className="text-right">Prix unitaire</TableHead>
                    <TableHead className="text-right">Quantité</TableHead>
                    <TableHead className="text-right">Total</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {(sale.items ?? []).map((item) => (
                    <TableRow key={item.id}>
                      <TableCell>
                        <span className="font-medium">{item.product_name ?? `Produit #${item.product_id}`}</span>
                        {item.product_sku ? (
                          <span className="block font-mono text-xs text-muted-foreground">
                            {item.product_sku}
                          </span>
                        ) : null}
                      </TableCell>
                      <TableCell className="text-right">{formatFCFA(item.unit_price)}</TableCell>
                      <TableCell className="text-right">{formatNumber(item.quantity)}</TableCell>
                      <TableCell className="text-right font-semibold">
                        {formatFCFA(item.line_total)}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>

            {/* Totaux */}
            <dl className="ml-auto w-full max-w-xs space-y-1.5 text-sm">
              <div className="flex justify-between">
                <dt className="text-muted-foreground">Sous-total</dt>
                <dd>{formatFCFA(sale.subtotal)}</dd>
              </div>
              <div className="flex justify-between">
                <dt className="text-muted-foreground">Remise</dt>
                <dd>-{formatFCFA(sale.discount)}</dd>
              </div>
              <div className="flex justify-between">
                <dt className="text-muted-foreground">Taxe</dt>
                <dd>{formatFCFA(sale.tax)}</dd>
              </div>
              <div className="flex justify-between border-t pt-1.5 text-base font-semibold">
                <dt>Total</dt>
                <dd>{formatFCFA(sale.total)}</dd>
              </div>
            </dl>
          </div>
        )}

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)}>
            Fermer
          </Button>
          {canCancel && sale ? (
            <Button variant="destructive" onClick={() => onRequestCancel(sale)}>
              <Ban />
              Annuler la vente
            </Button>
          ) : null}
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
