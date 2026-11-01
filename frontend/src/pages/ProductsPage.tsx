import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { MoreHorizontal, Package, PackagePlus, Pencil, Plus, Trash2, Power, PowerOff } from 'lucide-react';
import { useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { toast } from 'sonner';

import { ConfirmDialog } from '@/components/ConfirmDialog';
import { ErrorState } from '@/components/ErrorState';
import { PageHeader } from '@/components/layout/PageHeader';
import { Pagination } from '@/components/Pagination';
import { SearchInput } from '@/components/SearchInput';
import { AdjustStockDialog } from '@/components/products/AdjustStockDialog';
import { ProductFormDialog } from '@/components/products/ProductFormDialog';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
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
import { apiDelete, apiGet, apiPatch, apiPost, apiPut } from '@/lib/api';
import { useAuth } from '@/lib/auth';
import { formatFCFA, formatNumber } from '@/lib/format';
import type { Category, Product, StockStatus } from '@/lib/types';

const PER_PAGE = 15;
const ALL = 'all';

const STATUS_OPTIONS = [
  { value: ALL, label: 'Tous les stocks' },
  { value: 'ok', label: 'En stock' },
  { value: 'low', label: 'Stock bas' },
  { value: 'out', label: 'Rupture' },
];

const ACTIVE_OPTIONS = [
  { value: ALL, label: 'Tous' },
  { value: '1', label: 'Actifs' },
  { value: '0', label: 'Inactifs' },
];

const SORT_OPTIONS = [
  { value: 'name', label: 'Nom (A→Z)' },
  { value: '-name', label: 'Nom (Z→A)' },
  { value: '-selling_price', label: 'Prix décroissant' },
  { value: 'selling_price', label: 'Prix croissant' },
  { value: '-quantity', label: 'Stock décroissant' },
  { value: 'quantity', label: 'Stock croissant' },
  { value: '-created_at', label: 'Ajouts récents' },
];

const STATUS_BADGE: Record<StockStatus, { variant: 'success' | 'warning' | 'destructive'; label: string }> = {
  ok: { variant: 'success', label: 'En stock' },
  low: { variant: 'warning', label: 'Stock bas' },
  out: { variant: 'destructive', label: 'Rupture' },
};

/* ---------------------------------- Page ---------------------------------- */

export default function ProductsPage() {
  const { user } = useAuth();
  const isAdmin = user?.role === 'admin';
  const queryClient = useQueryClient();
  const [searchParams, setSearchParams] = useSearchParams();

  // Filtres pilotés par l'URL : la page est partageable et le lien
  // « /produits?status=low » du tableau de bord fonctionne directement.
  const q = searchParams.get('q') ?? '';
  const categoryId = searchParams.get('category_id') ?? ALL;
  const status = searchParams.get('status') ?? ALL;
  const isActive = searchParams.get('is_active') ?? ALL;
  const sort = searchParams.get('sort') ?? 'name';
  const page = Math.max(Number(searchParams.get('page') ?? '1') || 1, 1);

  const [formState, setFormState] = useState<{ open: boolean; product: Product | null }>({
    open: false,
    product: null,
  });
  const [adjustProduct, setAdjustProduct] = useState<Product | null>(null);
  const [deleteProduct, setDeleteProduct] = useState<Product | null>(null);

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

  const resetFilters = () => {
    setSearchParams(new URLSearchParams());
  };

  const params = useMemo(
    () => ({
      q: q || undefined,
      category_id: categoryId !== ALL ? Number(categoryId) : undefined,
      status: status !== ALL ? status : undefined,
      is_active: isActive !== ALL ? isActive : undefined,
      sort,
      page,
      per_page: PER_PAGE,
    }),
    [q, categoryId, status, isActive, sort, page],
  );

  const categoriesQuery = useQuery({
    queryKey: ['categories', 'options'],
    queryFn: () => apiGet<Category[]>('/categories', { per_page: 100, sort: 'name' }),
    staleTime: 60_000,
  });

  const productsQuery = useQuery({
    queryKey: ['products', 'list', params],
    queryFn: () => apiGet<Product[]>('/products', params),
    placeholderData: keepPreviousData,
  });

  const invalidate = () => {
    void queryClient.invalidateQueries({ queryKey: ['products'] });
    void queryClient.invalidateQueries({ queryKey: ['dashboard'] });
  };

  const closeForm = () => setFormState({ open: false, product: null });

  const createMutation = useMutation({
    mutationFn: (payload: Record<string, unknown>) => apiPost<Product>('/products', payload),
    onSuccess: () => {
      toast.success('Produit créé avec succès.');
      closeForm();
      invalidate();
    },
    // Les erreurs 422 sont remontées champ par champ par le dialogue.
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, payload }: { id: number; payload: Record<string, unknown> }) =>
      apiPut<Product>(`/products/${id}`, payload),
    onSuccess: () => {
      toast.success('Produit mis à jour.');
      closeForm();
      invalidate();
    },
  });

  const adjustMutation = useMutation({
    mutationFn: ({
      id,
      payload,
    }: {
      id: number;
      payload: { quantity_delta: number; reason: string | null };
    }) => apiPost<Product>(`/products/${id}/adjust-stock`, payload),
    onSuccess: (product) => {
      toast.success(
        `Stock ajusté : ${product.name} est maintenant à ${formatNumber(product.quantity)} unité(s).`,
      );
      setAdjustProduct(null);
      invalidate();
    },
  });

  const toggleActiveMutation = useMutation({
    mutationFn: (product: Product) =>
      // UpdateProductRequest exige les champs principaux : on renvoie le produit
      // complet avec l'inverseur is_active.
      apiPatch<Product>(`/products/${product.id}`, {
        name: product.name,
        sku: product.sku,
        category_id: product.category_id,
        description: product.description || null,
        purchase_price: Number(product.purchase_price),
        selling_price: Number(product.selling_price),
        low_stock_threshold: product.low_stock_threshold,
        image: product.image || null,
        is_active: !product.is_active,
      }),
    onSuccess: (product) => {
      toast.success(
        product.is_active
          ? `« ${product.name} » est de nouveau actif.`
          : `« ${product.name} » a été désactivé (conservé pour l'historique).`,
      );
      invalidate();
    },
    onError: (error: Error) => toast.error(error.message),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => apiDelete(`/products/${id}`),
    onSuccess: () => {
      toast.success('Produit supprimé.');
      setDeleteProduct(null);
      invalidate();
    },
    // Message métier explicite du serveur (ex. : suppression interdite si ventes liées).
    onError: (error: Error) => toast.error(error.message),
  });

  const handleProductSubmit = async (payload: Record<string, unknown>) => {
    if (formState.product) {
      await updateMutation.mutateAsync({ id: formState.product.id, payload });
    } else {
      await createMutation.mutateAsync(payload);
    }
  };

  const handleAdjustSubmit = async (payload: { quantity_delta: number; reason: string | null }) => {
    if (adjustProduct) {
      await adjustMutation.mutateAsync({ id: adjustProduct.id, payload });
    }
  };

  const isSubmittingProduct = createMutation.isPending || updateMutation.isPending;
  const categories = categoriesQuery.data?.data ?? [];
  const hasFilters = q !== '' || categoryId !== ALL || status !== ALL || isActive !== ALL;

  return (
    <>
      <PageHeader
        title="Produits"
        description="Catalogue, stocks, ajustements et alertes de rupture."
        actions={
          <Button onClick={() => setFormState({ open: true, product: null })}>
            <Plus />
            Nouveau produit
          </Button>
        }
      />

      {/* Barre de filtres */}
      <div className="mb-4 flex flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-center">
        <SearchInput
          value={q}
          onValueChange={(value) => setFilter('q', value)}
          placeholder="Rechercher un produit ou un SKU…"
          className="w-full sm:w-72"
        />
        <Select value={categoryId} onValueChange={(value) => setFilter('category_id', value)}>
          <SelectTrigger className="w-full sm:w-52">
            <SelectValue placeholder="Catégorie" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={ALL}>Toutes catégories</SelectItem>
            {categories.map((category) => (
              <SelectItem key={category.id} value={String(category.id)}>
                {category.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select value={status} onValueChange={(value) => setFilter('status', value)}>
          <SelectTrigger className="w-full sm:w-44">
            <SelectValue placeholder="Stock" />
          </SelectTrigger>
          <SelectContent>
            {STATUS_OPTIONS.map((option) => (
              <SelectItem key={option.value} value={option.value}>
                {option.label}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select value={isActive} onValueChange={(value) => setFilter('is_active', value)}>
          <SelectTrigger className="w-full sm:w-36">
            <SelectValue placeholder="État" />
          </SelectTrigger>
          <SelectContent>
            {ACTIVE_OPTIONS.map((option) => (
              <SelectItem key={option.value} value={option.value}>
                {option.label}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select value={sort} onValueChange={(value) => setFilter('sort', value)}>
          <SelectTrigger className="w-full sm:w-52">
            <SelectValue placeholder="Trier" />
          </SelectTrigger>
          <SelectContent>
            {SORT_OPTIONS.map((option) => (
              <SelectItem key={option.value} value={option.value}>
                {option.label}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        {hasFilters ? (
          <Button variant="ghost" size="sm" onClick={resetFilters}>
            Réinitialiser
          </Button>
        ) : null}
      </div>

      {productsQuery.isError ? (
        <ErrorState
          message={productsQuery.error?.message ?? 'Impossible de charger les produits.'}
          onRetry={() => void productsQuery.refetch()}
        />
      ) : (
        <Card>
          <CardContent className="p-0">
            {productsQuery.isLoading ? (
              <div className="space-y-2 p-4">
                {Array.from({ length: 6 }).map((_, i) => (
                  <Skeleton key={i} className="h-12 w-full" />
                ))}
              </div>
            ) : (productsQuery.data?.data.length ?? 0) === 0 ? (
              <div className="flex flex-col items-center gap-2 p-10 text-center">
                <Package className="h-8 w-8 text-muted-foreground" />
                <p className="font-medium">
                  {hasFilters ? 'Aucun produit ne correspond à vos filtres.' : 'Aucun produit pour le moment.'}
                </p>
                <p className="max-w-md text-sm text-muted-foreground">
                  {hasFilters
                    ? 'Essayez de modifier ou de réinitialiser vos critères de recherche.'
                    : 'Commencez par ajouter votre premier produit au catalogue.'}
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
                      <TableHead>Produit</TableHead>
                      <TableHead className="hidden sm:table-cell">Catégorie</TableHead>
                      <TableHead className="text-right">Prix de vente</TableHead>
                      <TableHead className="text-right">Stock</TableHead>
                      <TableHead className="hidden md:table-cell">État</TableHead>
                      <TableHead className="w-12 text-right">Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {productsQuery.data?.data.map((product) => {
                      const badge = STATUS_BADGE[product.stock_status] ?? STATUS_BADGE.ok;
                      return (
                        <TableRow key={product.id}>
                          <TableCell>
                            <div className="flex items-center gap-2">
                              <span className="font-medium">{product.name}</span>
                              {!product.is_active ? <Badge variant="muted">Inactif</Badge> : null}
                            </div>
                            <span className="font-mono text-xs text-muted-foreground">
                              {product.sku}
                            </span>
                          </TableCell>
                          <TableCell className="hidden sm:table-cell">
                            <span className="text-muted-foreground">
                              {product.category?.name ?? '—'}
                            </span>
                          </TableCell>
                          <TableCell className="text-right font-semibold">
                            {formatFCFA(product.selling_price)}
                          </TableCell>
                          <TableCell className="text-right">
                            <div className="flex flex-col items-end gap-1">
                              <span className="font-semibold">
                                {formatNumber(product.quantity)}
                              </span>
                              <Badge variant={badge.variant}>{badge.label}</Badge>
                            </div>
                          </TableCell>
                          <TableCell className="hidden md:table-cell">
                            {product.is_active ? (
                              <Badge variant="success">Actif</Badge>
                            ) : (
                              <Badge variant="muted">Inactif</Badge>
                            )}
                          </TableCell>
                          <TableCell className="text-right">
                            <DropdownMenu>
                              <DropdownMenuTrigger asChild>
                                <Button variant="ghost" size="icon-sm">
                                  <MoreHorizontal />
                                  <span className="sr-only">Actions pour {product.name}</span>
                                </Button>
                              </DropdownMenuTrigger>
                              <DropdownMenuContent align="end">
                                <DropdownMenuItem
                                  onClick={() => setFormState({ open: true, product })}
                                >
                                  <Pencil />
                                  Modifier
                                </DropdownMenuItem>
                                <DropdownMenuItem onClick={() => setAdjustProduct(product)}>
                                  <PackagePlus />
                                  Ajuster le stock
                                </DropdownMenuItem>
                                <DropdownMenuItem onClick={() => toggleActiveMutation.mutate(product)}>
                                  {product.is_active ? <PowerOff /> : <Power />}
                                  {product.is_active ? 'Désactiver' : 'Activer'}
                                </DropdownMenuItem>
                                {isAdmin ? (
                                  <>
                                    <DropdownMenuSeparator />
                                    <DropdownMenuItem
                                      className="text-destructive focus:bg-destructive/10 focus:text-destructive"
                                      onClick={() => setDeleteProduct(product)}
                                    >
                                      <Trash2 />
                                      Supprimer
                                    </DropdownMenuItem>
                                  </>
                                ) : null}
                              </DropdownMenuContent>
                            </DropdownMenu>
                          </TableCell>
                        </TableRow>
                      );
                    })}
                  </TableBody>
                </Table>

                <div className="border-t p-4">
                  <Pagination
                    meta={productsQuery.data?.meta}
                    onPageChange={(p) => setFilter('page', String(p))}
                    isFetching={productsQuery.isFetching}
                  />
                </div>
              </>
            )}
          </CardContent>
        </Card>
      )}

      {/* Dialogue création / édition */}
      <ProductFormDialog
        open={formState.open}
        onOpenChange={(open) => (open ? setFormState({ open, product: formState.product }) : closeForm())}
        product={formState.product}
        onSubmit={handleProductSubmit}
        submitting={isSubmittingProduct}
      />

      {/* Dialogue ajustement de stock */}
      <AdjustStockDialog
        open={adjustProduct !== null}
        onOpenChange={(open) => {
          if (!open) setAdjustProduct(null);
        }}
        product={adjustProduct}
        onSubmit={handleAdjustSubmit}
        submitting={adjustMutation.isPending}
      />

      {/* Confirmation de suppression */}
      <ConfirmDialog
        open={deleteProduct !== null}
        onOpenChange={(open) => {
          if (!open) setDeleteProduct(null);
        }}
        title="Supprimer le produit"
        description={
          deleteProduct
            ? `Voulez-vous vraiment supprimer « ${deleteProduct.name} » ? Cette action est irréversible. Si le produit figure dans des ventes, la suppression sera refusée.`
            : ''
        }
        confirmLabel="Supprimer"
        loading={deleteMutation.isPending}
        onConfirm={() => {
          if (deleteProduct) deleteMutation.mutate(deleteProduct.id);
        }}
      />
    </>
  );
}
