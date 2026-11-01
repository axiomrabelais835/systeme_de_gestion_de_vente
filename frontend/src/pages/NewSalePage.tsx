import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { ArrowLeft, Minus, PackagePlus, Plus, ShoppingCart, Trash2, TriangleAlert } from 'lucide-react';
import { useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';

import { PageHeader } from '@/components/layout/PageHeader';
import { SearchInput } from '@/components/SearchInput';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
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
import { apiGet, apiPost } from '@/lib/api';
import { formatFCFA, formatNumber } from '@/lib/format';
import type {
  AppSettings,
  Customer,
  PaymentMethod,
  PaymentStatus,
  Product,
  Sale,
} from '@/lib/types';

const NO_CUSTOMER = 'passage';
const MAX_QTY = 999;

const PAYMENT_METHODS: { value: PaymentMethod; label: string }[] = [
  { value: 'especes', label: 'Espèces' },
  { value: 'mobile_money', label: 'Mobile Money' },
  { value: 'carte', label: 'Carte bancaire' },
  { value: 'virement', label: 'Virement' },
];

const PAYMENT_STATUSES: { value: PaymentStatus; label: string }[] = [
  { value: 'payee', label: 'Payée' },
  { value: 'en_attente', label: 'En attente' },
];

/** Ligne du panier : instantané du produit au moment de l'ajout. */
interface CartLine {
  productId: number;
  name: string;
  sku: string;
  unitPrice: string;
  available: number;
  quantity: number;
}

/* ---------------------------------- Page ---------------------------------- */

export default function NewSalePage() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();

  const [search, setSearch] = useState('');
  const [lines, setLines] = useState<CartLine[]>([]);
  const [customerId, setCustomerId] = useState<string>(NO_CUSTOMER);
  const [paymentMethod, setPaymentMethod] = useState<PaymentMethod | ''>('');
  const [paymentStatus, setPaymentStatus] = useState<PaymentStatus>('payee');
  const [discount, setDiscount] = useState('');
  const [serverError, setServerError] = useState<string | null>(null);

  const productsQuery = useQuery({
    queryKey: ['products', 'sale-search', search],
    queryFn: () =>
      apiGet<Product[]>('/products', {
        q: search || undefined,
        is_active: 1,
        sort: 'name',
        per_page: 8,
      }).then((r) => r.data),
    placeholderData: keepPreviousData,
    staleTime: 15_000,
  });

  const customersQuery = useQuery({
    queryKey: ['customers', 'options'],
    queryFn: () => apiGet<Customer[]>('/customers', { per_page: 100 }).then((r) => r.data),
    staleTime: 60_000,
  });

  const settingsQuery = useQuery({
    queryKey: ['settings'],
    queryFn: () => apiGet<AppSettings>('/settings').then((r) => r.data),
    staleTime: 300_000,
  });

  const taxRate = settingsQuery.data?.default_tax_rate ?? 18;

  /* ------------------------------- Panier ------------------------------- */

  const addProduct = (product: Product) => {
    if (product.quantity <= 0) {
      return;
    }
    setServerError(null);
    setLines((prev) => {
      const existing = prev.find((line) => line.productId === product.id);
      if (existing) {
        return prev.map((line) =>
          line.productId === product.id
            ? { ...line, quantity: Math.min(line.quantity + 1, MAX_QTY) }
            : line,
        );
      }
      return [
        ...prev,
        {
          productId: product.id,
          name: product.name,
          sku: product.sku,
          unitPrice: product.selling_price,
          available: product.quantity,
          quantity: 1,
        },
      ];
    });
  };

  const setQuantity = (productId: number, value: number) => {
    const quantity = Math.min(Math.max(Math.floor(value) || 1, 1), MAX_QTY);
    setServerError(null);
    setLines((prev) =>
      prev.map((line) => (line.productId === productId ? { ...line, quantity } : line)),
    );
  };

  const removeLine = (productId: number) => {
    setServerError(null);
    setLines((prev) => prev.filter((line) => line.productId !== productId));
  };

  /* ------------------------- Totaux (estimation) ------------------------- */

  const subtotal = useMemo(
    () => lines.reduce((sum, line) => sum + Number(line.unitPrice) * line.quantity, 0),
    [lines],
  );

  const discountValue = Math.max(Number(discount) || 0, 0);
  const discountTooHigh = discountValue > subtotal;
  const appliedDiscount = discountTooHigh ? 0 : discountValue;
  const taxable = Math.max(subtotal - appliedDiscount, 0);
  const estimatedTax = (taxable * taxRate) / 100;
  const estimatedTotal = taxable + estimatedTax;

  const stockIssues = lines.filter((line) => line.quantity > line.available);

  /* ------------------------------ Validation ----------------------------- */

  const createMutation = useMutation({
    mutationFn: (payload: {
      customer_id: number | null;
      items: { product_id: number; quantity: number }[];
      discount: number;
      payment_method: PaymentMethod;
      payment_status: PaymentStatus;
    }) => apiPost<Sale>('/sales', payload),
    onSuccess: (sale) => {
      toast.success(`Vente ${sale.reference} enregistrée — ${formatFCFA(sale.total)}.`);
      setLines([]);
      setDiscount('');
      setServerError(null);
      setCustomerId(NO_CUSTOMER);
      setPaymentMethod('');
      setPaymentStatus('payee');
      void queryClient.invalidateQueries({ queryKey: ['products'] });
      void queryClient.invalidateQueries({ queryKey: ['dashboard'] });
      void queryClient.invalidateQueries({ queryKey: ['sales'] });
      navigate('/ventes');
    },
    onError: (error: Error) => {
      // 422 stock insuffisant / produit inactif : message métier conservé à l'écran.
      setServerError(error.message);
      toast.error(error.message);
    },
  });

  const createMutationPending = createMutation.isPending;

  const canSubmit =
    lines.length > 0 &&
    stockIssues.length === 0 &&
    !discountTooHigh &&
    paymentMethod !== '' &&
    !createMutationPending;

  const submit = () => {
    if (!canSubmit) {
      return;
    }
    setServerError(null);
    createMutation.mutate({
      customer_id: customerId === NO_CUSTOMER ? null : Number(customerId),
      items: lines.map((line) => ({ product_id: line.productId, quantity: line.quantity })),
      discount: appliedDiscount,
      payment_method: paymentMethod as PaymentMethod,
      payment_status: paymentStatus,
    });
  };

  const products = productsQuery.data ?? [];
  const productsInCart = new Set(lines.map((line) => line.productId));

  return (
    <>
      <PageHeader
        title="Nouvelle vente"
        description="Composez le panier puis validez : le contrôle et la décrément du stock sont transactionnels côté serveur."
        actions={
          <Button variant="outline" onClick={() => navigate('/ventes')}>
            <ArrowLeft />
            Retour à l'historique
          </Button>
        }
      />

      {serverError ? (
        <div
          role="alert"
          className="mb-4 flex items-start gap-2 rounded-lg border border-destructive/30 bg-destructive/10 px-4 py-3 text-sm font-medium text-destructive"
        >
          <TriangleAlert className="mt-0.5 h-4 w-4 shrink-0" />
          <span>{serverError}</span>
        </div>
      ) : null}

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-3">
        {/* --------------------------- Colonne gauche --------------------------- */}
        <div className="space-y-4 lg:col-span-2">
          {/* Client */}
          <Card>
            <CardHeader className="pb-3">
              <CardTitle className="text-base">Client</CardTitle>
            </CardHeader>
            <CardContent>
              <Select value={customerId} onValueChange={setCustomerId}>
                <SelectTrigger className="w-full sm:w-96" aria-label="Client de la vente">
                  <SelectValue placeholder="Sélectionner un client" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value={NO_CUSTOMER}>Client de passage</SelectItem>
                  {(customersQuery.data ?? []).map((customer) => (
                    <SelectItem key={customer.id} value={String(customer.id)}>
                      {customer.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              {customersQuery.isError ? (
                <p className="mt-2 text-xs text-destructive">
                  {customersQuery.error?.message ?? 'Clients indisponibles.'}
                </p>
              ) : null}
            </CardContent>
          </Card>

          {/* Recherche de produits */}
          <Card>
            <CardHeader className="pb-3">
              <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                <CardTitle className="text-base">Ajouter un produit</CardTitle>
                <SearchInput
                  value={search}
                  onValueChange={setSearch}
                  placeholder="Rechercher par nom, SKU, catégorie…"
                  className="w-full sm:w-80"
                />
              </div>
            </CardHeader>
            <CardContent className="space-y-2">
              {productsQuery.isLoading ? (
                Array.from({ length: 3 }).map((_, i) => (
                  <Skeleton key={i} className="h-14 w-full" />
                ))
              ) : products.length === 0 ? (
                <p className="py-6 text-center text-sm text-muted-foreground">
                  Aucun produit actif ne correspond à votre recherche.
                </p>
              ) : (
                products.map((product) => {
                  const inCart = productsInCart.has(product.id);
                  const out = product.quantity <= 0;
                  return (
                    <div
                      key={product.id}
                      className="flex items-center justify-between gap-3 rounded-lg border p-3"
                    >
                      <div className="min-w-0">
                        <p className="truncate text-sm font-medium">{product.name}</p>
                        <p className="truncate text-xs text-muted-foreground">
                          {product.sku} · {product.category?.name ?? 'Sans catégorie'} ·{' '}
                          {formatFCFA(product.selling_price)}
                        </p>
                      </div>
                      <div className="flex shrink-0 items-center gap-3">
                        <Badge
                          variant={
                            out ? 'destructive' : product.stock_status === 'low' ? 'warning' : 'success'
                          }
                        >
                          {out ? 'Rupture' : `${formatNumber(product.quantity)} en stock`}
                        </Badge>
                        <Button
                          size="sm"
                          onClick={() => addProduct(product)}
                          disabled={out || inCart}
                        >
                          <Plus />
                          {inCart ? 'Au panier' : 'Ajouter'}
                        </Button>
                      </div>
                    </div>
                  );
                })
              )}
            </CardContent>
          </Card>

          {/* Panier */}
          <Card>
            <CardHeader className="pb-3">
              <div className="flex items-center justify-between">
                <CardTitle className="flex items-center gap-2 text-base">
                  <ShoppingCart className="h-4 w-4 text-primary" />
                  Panier
                </CardTitle>
                <span className="text-sm text-muted-foreground">
                  {formatNumber(lines.length)} ligne(s)
                </span>
              </div>
            </CardHeader>
            <CardContent className="p-0">
              {lines.length === 0 ? (
                <div className="flex flex-col items-center gap-2 p-8 text-center">
                  <PackagePlus className="h-8 w-8 text-muted-foreground" />
                  <p className="text-sm font-medium">Le panier est vide.</p>
                  <p className="text-xs text-muted-foreground">
                    Recherchez un produit ci-dessus pour commencer l'encaissement.
                  </p>
                </div>
              ) : (
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Produit</TableHead>
                      <TableHead className="text-right">Prix unitaire</TableHead>
                      <TableHead className="text-center">Quantité</TableHead>
                      <TableHead className="text-right">Total</TableHead>
                      <TableHead className="w-10" />
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {lines.map((line) => {
                      const overStock = line.quantity > line.available;
                      return (
                        <TableRow key={line.productId} className={overStock ? 'bg-destructive/5' : ''}>
                          <TableCell>
                            <span className="font-medium">{line.name}</span>
                            <span className="block font-mono text-xs text-muted-foreground">
                              {line.sku}
                            </span>
                            {overStock ? (
                              <span className="mt-1 inline-block text-xs font-medium text-destructive">
                                Stock insuffisant : disponible {formatNumber(line.available)}
                              </span>
                            ) : (
                              <span className="block text-xs text-muted-foreground">
                                Stock : {formatNumber(line.available)}
                              </span>
                            )}
                          </TableCell>
                          <TableCell className="text-right">
                            {formatFCFA(line.unitPrice)}
                          </TableCell>
                          <TableCell>
                            <div className="flex items-center justify-center gap-1">
                              <Button
                                variant="outline"
                                size="icon-sm"
                                aria-label={`Retirer une unité de ${line.name}`}
                                onClick={() => setQuantity(line.productId, line.quantity - 1)}
                                disabled={line.quantity <= 1}
                              >
                                <Minus />
                              </Button>
                              <Input
                                type="number"
                                min={1}
                                max={MAX_QTY}
                                value={line.quantity}
                                aria-label={`Quantité pour ${line.name}`}
                                onChange={(event) =>
                                  setQuantity(line.productId, Number(event.target.value))
                                }
                                className="h-8 w-16 text-center"
                              />
                              <Button
                                variant="outline"
                                size="icon-sm"
                                aria-label={`Ajouter une unité de ${line.name}`}
                                onClick={() => setQuantity(line.productId, line.quantity + 1)}
                                disabled={line.quantity >= line.available}
                              >
                                <Plus />
                              </Button>
                            </div>
                          </TableCell>
                          <TableCell className="text-right font-semibold">
                            {formatFCFA(Number(line.unitPrice) * line.quantity)}
                          </TableCell>
                          <TableCell className="text-right">
                            <Button
                              variant="ghost"
                              size="icon-sm"
                              aria-label={`Retirer ${line.name} du panier`}
                              onClick={() => removeLine(line.productId)}
                              className="text-destructive hover:bg-destructive/10 hover:text-destructive"
                            >
                              <Trash2 />
                            </Button>
                          </TableCell>
                        </TableRow>
                      );
                    })}
                  </TableBody>
                </Table>
              )}
            </CardContent>
          </Card>
        </div>

        {/* -------------------------- Colonne droite --------------------------- */}
        <div className="space-y-4">
          <Card>
            <CardHeader className="pb-3">
              <CardTitle className="text-base">Règlement</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-1.5">
                <Label htmlFor="sale-payment-method">Mode de paiement</Label>
                <Select
                  value={paymentMethod}
                  onValueChange={(value) => setPaymentMethod(value as PaymentMethod)}
                >
                  <SelectTrigger id="sale-payment-method" aria-label="Mode de paiement">
                    <SelectValue placeholder="Choisir un mode de paiement" />
                  </SelectTrigger>
                  <SelectContent>
                    {PAYMENT_METHODS.map((method) => (
                      <SelectItem key={method.value} value={method.value}>
                        {method.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-1.5">
                <Label htmlFor="sale-payment-status">Statut du paiement</Label>
                <Select
                  value={paymentStatus}
                  onValueChange={(value) => setPaymentStatus(value as PaymentStatus)}
                >
                  <SelectTrigger id="sale-payment-status" aria-label="Statut du paiement">
                    <SelectValue placeholder="Statut du paiement" />
                  </SelectTrigger>
                  <SelectContent>
                    {PAYMENT_STATUSES.map((status) => (
                      <SelectItem key={status.value} value={status.value}>
                        {status.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-1.5">
                <Label htmlFor="sale-discount">Remise (FCFA)</Label>
                <Input
                  id="sale-discount"
                  type="number"
                  min={0}
                  step={1}
                  value={discount}
                  onChange={(event) => setDiscount(event.target.value)}
                  placeholder="0"
                  disabled={lines.length === 0}
                />
                {discountTooHigh ? (
                  <p className="text-xs font-medium text-destructive">
                    La remise ne peut pas dépasser le sous-total ({formatFCFA(subtotal)}).
                  </p>
                ) : null}
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-3">
              <CardTitle className="text-base">Récapitulatif</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <dl className="space-y-1.5 text-sm">
                <div className="flex justify-between">
                  <dt className="text-muted-foreground">Sous-total</dt>
                  <dd>{formatFCFA(subtotal)}</dd>
                </div>
                <div className="flex justify-between">
                  <dt className="text-muted-foreground">Remise</dt>
                  <dd>-{formatFCFA(appliedDiscount)}</dd>
                </div>
                <div className="flex justify-between">
                  <dt className="text-muted-foreground">Taxe (est. {formatNumber(taxRate, 0)} %)</dt>
                  <dd>{formatFCFA(estimatedTax)}</dd>
                </div>
                <div className="flex justify-between border-t pt-2 text-base font-semibold">
                  <dt>Total estimé</dt>
                  <dd>{formatFCFA(estimatedTotal)}</dd>
                </div>
              </dl>

              <p className="text-xs text-muted-foreground">
                Estimation affichée : les montants définitifs (sous-total, taxe, total) sont
                recalculés par le serveur au moment de la validation.
              </p>

              {stockIssues.length > 0 ? (
                <p className="text-xs font-medium text-destructive">
                  Quantité supérieure au stock disponible sur{' '}
                  {formatNumber(stockIssues.length)} ligne(s).
                </p>
              ) : null}

              <Button className="w-full" size="lg" disabled={!canSubmit} onClick={submit}>
                {createMutation.isPending ? 'Validation en cours…' : 'Valider la vente'}
              </Button>

              {lines.length === 0 ? (
                <p className="text-center text-xs text-muted-foreground">
                  Ajoutez au moins un article pour valider.
                </p>
              ) : paymentMethod === '' ? (
                <p className="text-center text-xs text-muted-foreground">
                  Sélectionnez un mode de paiement pour valider.
                </p>
              ) : null}
            </CardContent>
          </Card>
        </div>
      </div>
    </>
  );
}
