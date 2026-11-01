import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { MoreHorizontal, Pencil, Plus, Tags, Trash2 } from 'lucide-react';
import { useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { toast } from 'sonner';

import { CategoryFormDialog } from '@/components/categories/CategoryFormDialog';
import { ConfirmDialog } from '@/components/ConfirmDialog';
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
import { apiDelete, apiGet, apiPost, apiPut } from '@/lib/api';
import { useAuth } from '@/lib/auth';
import { formatDate, formatNumber } from '@/lib/format';
import type { Category } from '@/lib/types';

const PER_PAGE = 15;
const ALL = 'all';

const SORT_OPTIONS = [
  { value: 'name', label: 'Nom (A→Z)' },
  { value: '-name', label: 'Nom (Z→A)' },
  { value: '-products_count', label: 'Plus de produits' },
  { value: 'products_count', label: 'Moins de produits' },
  { value: '-created_at', label: 'Ajouts récents' },
];

/* ---------------------------------- Page ---------------------------------- */

export default function CategoriesPage() {
  const { user } = useAuth();
  const isAdmin = user?.role === 'admin';
  const queryClient = useQueryClient();
  const [searchParams, setSearchParams] = useSearchParams();

  const q = searchParams.get('q') ?? '';
  const sort = searchParams.get('sort') ?? 'name';
  const page = Math.max(Number(searchParams.get('page') ?? '1') || 1, 1);

  const [formState, setFormState] = useState<{ open: boolean; category: Category | null }>({
    open: false,
    category: null,
  });
  const [deleteCategory, setDeleteCategory] = useState<Category | null>(null);

  const setFilter = (key: string, value: string) => {
    setSearchParams((prev) => {
      const next = new URLSearchParams(prev);
      if (value && value !== ALL) next.set(key, value);
      else next.delete(key);
      if (key !== 'page') next.delete('page');
      return next;
    });
  };

  const params = useMemo(
    () => ({ q: q || undefined, sort, page, per_page: PER_PAGE }),
    [q, sort, page],
  );

  const categoriesQuery = useQuery({
    queryKey: ['categories', 'list', params],
    queryFn: () => apiGet<Category[]>('/categories', params),
    placeholderData: keepPreviousData,
  });

  const invalidate = () => {
    void queryClient.invalidateQueries({ queryKey: ['categories'] });
    void queryClient.invalidateQueries({ queryKey: ['products'] });
    void queryClient.invalidateQueries({ queryKey: ['dashboard'] });
  };

  const closeForm = () => setFormState({ open: false, category: null });

  const createMutation = useMutation({
    mutationFn: (payload: { name: string; description: string | null }) =>
      apiPost<Category>('/categories', payload),
    onSuccess: () => {
      toast.success('Catégorie créée avec succès.');
      closeForm();
      invalidate();
    },
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, payload }: { id: number; payload: { name: string; description: string | null } }) =>
      apiPut<Category>(`/categories/${id}`, payload),
    onSuccess: () => {
      toast.success('Catégorie mise à jour.');
      closeForm();
      invalidate();
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => apiDelete(`/categories/${id}`),
    onSuccess: () => {
      toast.success('Catégorie supprimée.');
      setDeleteCategory(null);
      invalidate();
    },
    // Message métier explicite (ex. : suppression interdite si produits rattachés).
    onError: (error: Error) => toast.error(error.message),
  });

  const handleSubmit = async (payload: { name: string; description: string | null }) => {
    if (formState.category) {
      await updateMutation.mutateAsync({ id: formState.category.id, payload });
    } else {
      await createMutation.mutateAsync(payload);
    }
  };

  const isSubmitting = createMutation.isPending || updateMutation.isPending;
  const categories = categoriesQuery.data?.data ?? [];

  return (
    <>
      <PageHeader
        title="Catégories"
        description="Organisation du catalogue par catégorie."
        actions={
          <Button onClick={() => setFormState({ open: true, category: null })}>
            <Plus />
            Nouvelle catégorie
          </Button>
        }
      />

      <div className="mb-4 flex flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-center">
        <SearchInput
          value={q}
          onValueChange={(value) => setFilter('q', value)}
          placeholder="Rechercher une catégorie…"
          className="w-full sm:w-72"
        />
        <Select value={sort} onValueChange={(value) => setFilter('sort', value)}>
          <SelectTrigger className="w-full sm:w-56">
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
        {q ? (
          <Button variant="ghost" size="sm" onClick={() => setFilter('q', '')}>
            Réinitialiser
          </Button>
        ) : null}
      </div>

      {categoriesQuery.isError ? (
        <ErrorState
          message={categoriesQuery.error?.message ?? 'Impossible de charger les catégories.'}
          onRetry={() => void categoriesQuery.refetch()}
        />
      ) : (
        <Card>
          <CardContent className="p-0">
            {categoriesQuery.isLoading ? (
              <div className="space-y-2 p-4">
                {Array.from({ length: 6 }).map((_, i) => (
                  <Skeleton key={i} className="h-12 w-full" />
                ))}
              </div>
            ) : categories.length === 0 ? (
              <div className="flex flex-col items-center gap-2 p-10 text-center">
                <Tags className="h-8 w-8 text-muted-foreground" />
                <p className="font-medium">
                  {q ? 'Aucune catégorie ne correspond à votre recherche.' : 'Aucune catégorie pour le moment.'}
                </p>
                <p className="max-w-md text-sm text-muted-foreground">
                  {q
                    ? 'Essayez d\'autres termes de recherche.'
                    : 'Créez une catégorie pour commencer à organiser votre catalogue.'}
                </p>
              </div>
            ) : (
              <>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Nom</TableHead>
                      <TableHead className="hidden sm:table-cell">Slug</TableHead>
                      <TableHead className="hidden md:table-cell">Description</TableHead>
                      <TableHead className="text-right">Produits</TableHead>
                      <TableHead className="hidden lg:table-cell">Ajoutée le</TableHead>
                      <TableHead className="w-12 text-right">Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {categories.map((category) => (
                      <TableRow key={category.id}>
                        <TableCell className="font-medium">{category.name}</TableCell>
                        <TableCell className="hidden sm:table-cell">
                          <span className="font-mono text-xs text-muted-foreground">
                            {category.slug}
                          </span>
                        </TableCell>
                        <TableCell className="hidden max-w-xs truncate md:table-cell">
                          <span className="text-muted-foreground">
                            {category.description ?? '—'}
                          </span>
                        </TableCell>
                        <TableCell className="text-right">
                          <Badge variant={category.products_count ? 'secondary' : 'muted'}>
                            {formatNumber(category.products_count ?? 0)}
                          </Badge>
                        </TableCell>
                        <TableCell className="hidden whitespace-nowrap text-muted-foreground lg:table-cell">
                          {formatDate(category.created_at)}
                        </TableCell>
                        <TableCell className="text-right">
                          <DropdownMenu>
                            <DropdownMenuTrigger asChild>
                              <Button variant="ghost" size="icon-sm">
                                <MoreHorizontal />
                                <span className="sr-only">Actions pour {category.name}</span>
                              </Button>
                            </DropdownMenuTrigger>
                            <DropdownMenuContent align="end">
                              <DropdownMenuItem
                                onClick={() => setFormState({ open: true, category })}
                              >
                                <Pencil />
                                Modifier
                              </DropdownMenuItem>
                              {isAdmin ? (
                                <>
                                  <DropdownMenuSeparator />
                                  <DropdownMenuItem
                                    className="text-destructive focus:bg-destructive/10 focus:text-destructive"
                                    onClick={() => setDeleteCategory(category)}
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
                    ))}
                  </TableBody>
                </Table>

                <div className="border-t p-4">
                  <Pagination
                    meta={categoriesQuery.data?.meta}
                    onPageChange={(p) => setFilter('page', String(p))}
                    isFetching={categoriesQuery.isFetching}
                  />
                </div>
              </>
            )}
          </CardContent>
        </Card>
      )}

      {/* Dialogue création / édition */}
      <CategoryFormDialog
        open={formState.open}
        onOpenChange={(open) =>
          open ? setFormState({ open, category: formState.category }) : closeForm()
        }
        category={formState.category}
        onSubmit={handleSubmit}
        submitting={isSubmitting}
      />

      {/* Confirmation de suppression */}
      <ConfirmDialog
        open={deleteCategory !== null}
        onOpenChange={(open) => {
          if (!open) setDeleteCategory(null);
        }}
        title="Supprimer la catégorie"
        description={
          deleteCategory
            ? `Voulez-vous vraiment supprimer « ${deleteCategory.name} » ? Si des produits y sont rattachés, la suppression sera refusée.`
            : ''
        }
        confirmLabel="Supprimer"
        loading={deleteMutation.isPending}
        onConfirm={() => {
          if (deleteCategory) deleteMutation.mutate(deleteCategory.id);
        }}
      />
    </>
  );
}
