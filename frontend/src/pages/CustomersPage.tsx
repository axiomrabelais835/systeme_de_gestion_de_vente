import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { Eye, MoreHorizontal, Pencil, Plus, Trash2, UserRound } from 'lucide-react';
import { useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { toast } from 'sonner';

import { ConfirmDialog } from '@/components/ConfirmDialog';
import { CustomerDetailDialog } from '@/components/customers/CustomerDetailDialog';
import { CustomerFormDialog } from '@/components/customers/CustomerFormDialog';
import { ErrorState } from '@/components/ErrorState';
import { PageHeader } from '@/components/layout/PageHeader';
import { Pagination } from '@/components/Pagination';
import { SearchInput } from '@/components/SearchInput';
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
import { Skeleton } from '@/components/ui/skeleton';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { apiDelete, apiGet, apiPost, apiPut } from '@/lib/api';
import { formatDate } from '@/lib/format';
import type { Customer } from '@/lib/types';

const PER_PAGE = 15;

/* ---------------------------------- Page ---------------------------------- */

export default function CustomersPage() {
  const queryClient = useQueryClient();
  const [searchParams, setSearchParams] = useSearchParams();

  // Filtres pilotés par l'URL : la page est partageable.
  const q = searchParams.get('q') ?? '';
  const page = Math.max(Number(searchParams.get('page') ?? '1') || 1, 1);

  const [formState, setFormState] = useState<{ open: boolean; customer: Customer | null }>({
    open: false,
    customer: null,
  });
  const [detailId, setDetailId] = useState<number | null>(null);
  const [deleteCustomer, setDeleteCustomer] = useState<Customer | null>(null);

  const setFilter = (key: string, value: string) => {
    setSearchParams((prev) => {
      const next = new URLSearchParams(prev);
      if (value) next.set(key, value);
      else next.delete(key);
      // Toute modification de filtre revient à la première page.
      if (key !== 'page') next.delete('page');
      return next;
    });
  };

  const resetFilters = () => setSearchParams(new URLSearchParams());

  const params = useMemo(() => ({ q: q || undefined, page, per_page: PER_PAGE }), [q, page]);

  const customersQuery = useQuery({
    queryKey: ['customers', 'list', params],
    queryFn: () => apiGet<Customer[]>('/customers', params),
    placeholderData: keepPreviousData,
  });

  const invalidate = () => {
    void queryClient.invalidateQueries({ queryKey: ['customers'] });
    void queryClient.invalidateQueries({ queryKey: ['dashboard'] });
  };

  const closeForm = () => setFormState({ open: false, customer: null });

  const createMutation = useMutation({
    mutationFn: (payload: Record<string, unknown>) => apiPost<Customer>('/customers', payload),
    onSuccess: (customer) => {
      toast.success(`Client « ${customer.name} » créé avec succès.`);
      closeForm();
      invalidate();
    },
    // Les erreurs 422 sont remontées champ par champ par le dialogue.
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, payload }: { id: number; payload: Record<string, unknown> }) =>
      apiPut<Customer>(`/customers/${id}`, payload),
    onSuccess: (customer) => {
      toast.success(`Fiche de « ${customer.name} » mise à jour.`);
      closeForm();
      invalidate();
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => apiDelete(`/customers/${id}`),
    onSuccess: () => {
      toast.success('Client supprimé — son historique d\'achats est conservé.');
      setDeleteCustomer(null);
      invalidate();
    },
    onError: (error: Error) => toast.error(error.message),
  });

  const handleCustomerSubmit = async (payload: Record<string, unknown>) => {
    if (formState.customer) {
      await updateMutation.mutateAsync({ id: formState.customer.id, payload });
    } else {
      await createMutation.mutateAsync(payload);
    }
  };

  const isSubmitting = createMutation.isPending || updateMutation.isPending;
  const customers = customersQuery.data?.data ?? [];
  const hasFilters = q !== '';

  return (
    <>
      <PageHeader
        title="Clients"
        description="Fiches clients, historique d'achats et dépenses."
        actions={
          <Button onClick={() => setFormState({ open: true, customer: null })}>
            <Plus />
            Nouveau client
          </Button>
        }
      />

      {/* Barre de filtres */}
      <div className="mb-4 flex flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-center">
        <SearchInput
          value={q}
          onValueChange={(value) => setFilter('q', value)}
          placeholder="Rechercher un nom, un e-mail ou un téléphone…"
          className="w-full sm:w-80"
        />
        {hasFilters ? (
          <Button variant="ghost" size="sm" onClick={resetFilters}>
            Réinitialiser
          </Button>
        ) : null}
      </div>

      {customersQuery.isError ? (
        <ErrorState
          message={customersQuery.error?.message ?? 'Impossible de charger les clients.'}
          onRetry={() => void customersQuery.refetch()}
        />
      ) : (
        <Card>
          <CardContent className="p-0">
            {customersQuery.isLoading ? (
              <div className="space-y-2 p-4">
                {Array.from({ length: 6 }).map((_, i) => (
                  <Skeleton key={i} className="h-12 w-full" />
                ))}
              </div>
            ) : customers.length === 0 ? (
              <div className="flex flex-col items-center gap-2 p-10 text-center">
                <UserRound className="h-8 w-8 text-muted-foreground" />
                <p className="font-medium">
                  {hasFilters
                    ? 'Aucun client ne correspond à votre recherche.'
                    : 'Aucun client pour le moment.'}
                </p>
                <p className="max-w-md text-sm text-muted-foreground">
                  {hasFilters
                    ? 'Essayez de modifier ou de réinitialiser votre recherche.'
                    : "Créez une fiche client pour suivre ses achats et son chiffre d'affaires."}
                </p>
                {hasFilters ? (
                  <Button variant="outline" size="sm" onClick={resetFilters}>
                    Réinitialiser la recherche
                  </Button>
                ) : null}
              </div>
            ) : (
              <>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Client</TableHead>
                      <TableHead className="hidden lg:table-cell">Adresse</TableHead>
                      <TableHead className="hidden sm:table-cell">Client depuis</TableHead>
                      <TableHead className="w-12 text-right">Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {customers.map((customer) => (
                      <TableRow key={customer.id}>
                        <TableCell>
                          <span className="font-medium">{customer.name}</span>
                          <span className="block text-xs text-muted-foreground">
                            {customer.email ?? '—'}
                            {customer.phone ? ` · ${customer.phone}` : ''}
                          </span>
                        </TableCell>
                        <TableCell className="hidden lg:table-cell">
                          <span className="text-muted-foreground">{customer.address ?? '—'}</span>
                        </TableCell>
                        <TableCell className="hidden sm:table-cell">
                          <Badge variant="muted">{formatDate(customer.created_at)}</Badge>
                        </TableCell>
                        <TableCell className="text-right">
                          <DropdownMenu>
                            <DropdownMenuTrigger asChild>
                              <Button variant="ghost" size="icon-sm">
                                <MoreHorizontal />
                                <span className="sr-only">Actions pour {customer.name}</span>
                              </Button>
                            </DropdownMenuTrigger>
                            <DropdownMenuContent align="end">
                              <DropdownMenuItem onClick={() => setDetailId(customer.id)}>
                                <Eye />
                                Voir la fiche
                              </DropdownMenuItem>
                              <DropdownMenuItem
                                onClick={() => setFormState({ open: true, customer })}
                              >
                                <Pencil />
                                Modifier
                              </DropdownMenuItem>
                              <DropdownMenuSeparator />
                              <DropdownMenuItem
                                className="text-destructive focus:bg-destructive/10 focus:text-destructive"
                                onClick={() => setDeleteCustomer(customer)}
                              >
                                <Trash2 />
                                Supprimer
                              </DropdownMenuItem>
                            </DropdownMenuContent>
                          </DropdownMenu>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>

                <div className="border-t p-4">
                  <Pagination
                    meta={customersQuery.data?.meta}
                    onPageChange={(p) => setFilter('page', String(p))}
                    isFetching={customersQuery.isFetching}
                  />
                </div>
              </>
            )}
          </CardContent>
        </Card>
      )}

      {/* Dialogue création / édition */}
      <CustomerFormDialog
        open={formState.open}
        onOpenChange={(open) =>
          open ? setFormState({ open, customer: formState.customer }) : closeForm()
        }
        customer={formState.customer}
        onSubmit={handleCustomerSubmit}
        submitting={isSubmitting}
      />

      {/* Fiche détaillée avec historique d'achats */}
      <CustomerDetailDialog
        customerId={detailId}
        open={detailId !== null}
        onOpenChange={(open) => {
          if (!open) setDetailId(null);
        }}
      />

      {/* Confirmation de suppression (soft delete) */}
      <ConfirmDialog
        open={deleteCustomer !== null}
        onOpenChange={(open) => {
          if (!open) setDeleteCustomer(null);
        }}
        title="Supprimer le client"
        description={
          deleteCustomer
            ? `Voulez-vous vraiment retirer « ${deleteCustomer.name} » ? Sa fiche sera masquée mais son historique d'achats sera conservé.`
            : ''
        }
        confirmLabel="Supprimer"
        loading={deleteMutation.isPending}
        onConfirm={() => {
          if (deleteCustomer) deleteMutation.mutate(deleteCustomer.id);
        }}
      />
    </>
  );
}
