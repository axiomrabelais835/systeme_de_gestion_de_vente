import { zodResolver } from '@hookform/resolvers/zod';
import { useQuery } from '@tanstack/react-query';
import { Loader2 } from 'lucide-react';
import { useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { z } from 'zod';

import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Switch } from '@/components/ui/switch';
import { Textarea } from '@/components/ui/textarea';
import { ApiError, apiGet } from '@/lib/api';
import type { AppSettings, Category, Product } from '@/lib/types';

/**
 * Les valeurs numériques sont saisies en chaîne (champ contrôlé) puis
 * converties à l'envoi. Cela évite les pièges de NaN/float de react-hook-form
 * et respecte la règle « montants calculés côté serveur » : on envoie des
 * nombres bruts, le serveur reste l'unique source de vérité pour les totaux.
 */
function numericString(
  label: string,
  opts: { min?: number; integer?: boolean; positive?: boolean } = {},
) {
  const { min = 0, integer = false, positive = false } = opts;
  return z
    .string()
    .trim()
    .min(1, `${label} est obligatoire.`)
    .superRefine((value, ctx) => {
      const n = Number(value.replace(',', '.'));
      if (!Number.isFinite(n)) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: `${label} doit être un nombre.`,
        });
        return;
      }
      if (integer && !Number.isInteger(n)) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: `${label} doit être un nombre entier.`,
        });
        return;
      }
      if (positive && n <= 0) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: `${label} doit être supérieur à 0.`,
        });
        return;
      }
      if (n < min) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: `${label} ne peut pas être inférieur à ${min}.`,
        });
      }
    });
}

const productBaseSchema = z.object({
  name: z
    .string()
    .trim()
    .min(1, 'Le nom du produit est obligatoire.')
    .max(200, 'Le nom ne peut pas dépasser 200 caractères.'),
  sku: z
    .string()
    .trim()
    .min(1, 'Le code SKU est obligatoire.')
    .max(60, 'Le SKU ne peut pas dépasser 60 caractères.'),
  category_id: z.string().min(1, 'La catégorie est obligatoire.'),
  description: z
    .string()
    .trim()
    .max(2000, 'La description ne peut pas dépasser 2 000 caractères.')
    .optional()
    .or(z.literal('')),
  purchase_price: numericString("Le prix d'achat", { min: 0 }),
  selling_price: numericString('Le prix de vente', { min: 0.01, positive: true }),
  low_stock_threshold: numericString('Le seuil de stock faible', { min: 0, integer: true }),
  image: z
    .string()
    .trim()
    .max(500, "L'URL de l'image ne peut pas dépasser 500 caractères.")
    .optional()
    .or(z.literal('')),
  is_active: z.boolean(),
});

// À la création uniquement : le stock initial est saisi. À l'édition, le stock
// ne se modifie jamais ici (uniquement via adjust-stock) — cf. UpdateProductRequest.
const productCreateSchema = productBaseSchema.extend({
  quantity: numericString('La quantité', { min: 0, integer: true }),
});

type ProductCreateValues = z.infer<typeof productCreateSchema>;

interface ProductFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  /** Produit à éditer, ou null pour la création. */
  product: Product | null;
  onSubmit: (payload: Record<string, unknown>) => Promise<void>;
  submitting: boolean;
}

export function ProductFormDialog({
  open,
  onOpenChange,
  product,
  onSubmit,
  submitting,
}: ProductFormDialogProps) {
  const isCreate = product === null;

  const categoriesQuery = useQuery({
    queryKey: ['categories', 'options'],
    queryFn: () => apiGet<Category[]>('/categories', { per_page: 100, sort: 'name' }),
    enabled: open,
    staleTime: 60_000,
  });

  // Seuil par défaut des paramètres : pré-remplit le champ à la création.
  const settingsQuery = useQuery({
    queryKey: ['settings'],
    queryFn: () => apiGet<AppSettings>('/settings').then((r) => r.data),
    enabled: open,
    staleTime: 60_000,
  });

  const form = useForm<ProductCreateValues>({
    resolver: zodResolver(isCreate ? productCreateSchema : productBaseSchema),
    defaultValues: {
      name: '',
      sku: '',
      category_id: '',
      description: '',
      purchase_price: '',
      selling_price: '',
      quantity: '',
      low_stock_threshold: '',
      image: '',
      is_active: true,
    },
  });

  // Réinitialise le formulaire à chaque ouverture (création ou édition).
  useEffect(() => {
    if (!open) return;
    if (product) {
      form.reset({
        name: product.name,
        sku: product.sku,
        category_id: String(product.category_id),
        description: product.description ?? '',
        purchase_price: String(product.purchase_price),
        selling_price: String(product.selling_price),
        quantity: '',
        low_stock_threshold: String(product.low_stock_threshold),
        image: product.image ?? '',
        is_active: product.is_active,
      });
    } else {
      form.reset({
        name: '',
        sku: '',
        category_id: '',
        description: '',
        purchase_price: '',
        selling_price: '',
        quantity: '',
        low_stock_threshold: '',
        image: '',
        is_active: true,
      });
    }
  }, [open, product, form]);

  // Pré-remplit le seuil avec le réglage par défaut (création uniquement, et
  // seulement si le champ est encore vide pour ne jamais écraser une saisie).
  useEffect(() => {
    if (!open || product) return;
    const threshold = settingsQuery.data?.default_low_stock_threshold;
    if (threshold === undefined) return;
    if (form.getValues('low_stock_threshold') === '') {
      form.setValue('low_stock_threshold', String(threshold));
    }
  }, [open, product, settingsQuery.data, form]);

  const handleValid = async (values: ProductCreateValues) => {
    const num = (v: string) => Number(v.replace(',', '.'));
    const payload: Record<string, unknown> = {
      name: values.name,
      sku: values.sku,
      category_id: Number(values.category_id),
      description: values.description || null,
      purchase_price: num(values.purchase_price),
      selling_price: num(values.selling_price),
      low_stock_threshold: num(values.low_stock_threshold),
      image: values.image || null,
      is_active: values.is_active,
    };
    if (isCreate) {
      payload.quantity = num(values.quantity);
    }

    try {
      await onSubmit(payload);
    } catch (error) {
      // Remontée des erreurs 422 champ par champ (libellés français du serveur).
      if (error instanceof ApiError && error.status === 422) {
        let applied = false;
        for (const [field, messages] of Object.entries(error.fieldErrors)) {
          if (messages?.length) {
            form.setError(field as keyof ProductCreateValues, { message: messages[0] });
            applied = true;
          }
        }
        if (!applied) {
          form.setError('root', { message: error.message });
        }
      } else if (error instanceof ApiError) {
        form.setError('root', { message: error.message });
      } else {
        form.setError('root', { message: 'Une erreur inattendue est survenue.' });
      }
    }
  };

  const rootMessage = form.formState.errors.root?.message;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-h-[90vh] overflow-y-auto sm:max-w-2xl">
        <DialogHeader>
          <DialogTitle>{isCreate ? 'Nouveau produit' : 'Modifier le produit'}</DialogTitle>
          <DialogDescription>
            {isCreate
              ? 'Renseignez les informations du produit. Le stock initial sera enregistré comme une entrée traçable.'
              : 'Modifiez les informations du produit. Le stock se ajuste uniquement via « Ajuster le stock ».'}
          </DialogDescription>
        </DialogHeader>

        <Form {...form}>
          <form onSubmit={form.handleSubmit(handleValid)} className="space-y-4" noValidate>
            <div className="grid gap-4 sm:grid-cols-2">
              <FormField
                control={form.control}
                name="name"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Nom du produit</FormLabel>
                    <FormControl>
                      <Input placeholder={'Ex. : Écran LED 24" Full HD'} {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="sku"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Code SKU</FormLabel>
                    <FormControl>
                      <Input placeholder="Ex. : INFO-0003" className="font-mono" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <FormField
              control={form.control}
              name="category_id"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Catégorie</FormLabel>
                  <Select onValueChange={field.onChange} value={field.value}>
                    <FormControl>
                      <SelectTrigger>
                        <SelectValue placeholder="Sélectionner une catégorie" />
                      </SelectTrigger>
                    </FormControl>
                    <SelectContent>
                      {categoriesQuery.data?.data.map((category) => (
                        <SelectItem key={category.id} value={String(category.id)}>
                          {category.name}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name="description"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Description</FormLabel>
                  <FormControl>
                    <Textarea
                      placeholder="Description facultative du produit…"
                      rows={3}
                      {...field}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <div className="grid gap-4 sm:grid-cols-2">
              <FormField
                control={form.control}
                name="purchase_price"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Prix d'achat (FCFA)</FormLabel>
                    <FormControl>
                      <Input type="number" min="0" step="any" placeholder="0" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="selling_price"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Prix de vente (FCFA)</FormLabel>
                    <FormControl>
                      <Input type="number" min="0" step="any" placeholder="0" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <div className="grid gap-4 sm:grid-cols-2">
              {isCreate ? (
                <FormField
                  control={form.control}
                  name="quantity"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Stock initial</FormLabel>
                      <FormControl>
                        <Input type="number" min="0" step="1" placeholder="0" {...field} />
                      </FormControl>
                      <FormDescription>Enregistré comme une entrée de stock.</FormDescription>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              ) : (
                <FormItem>
                  <FormLabel>Stock actuel</FormLabel>
                  <div className="flex h-9 items-center rounded-md border bg-muted/40 px-3 text-sm font-semibold">
                    {product?.quantity ?? 0} unité(s)
                  </div>
                  <FormDescription>
                    Utilisez « Ajuster le stock » pour le modifier (traçabilité).
                  </FormDescription>
                </FormItem>
              )}
              <FormField
                control={form.control}
                name="low_stock_threshold"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Seuil d'alerte</FormLabel>
                    <FormControl>
                      <Input type="number" min="0" step="1" placeholder="0" {...field} />
                    </FormControl>
                    <FormDescription>Alerte si le stock ≤ ce seuil.</FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <FormField
              control={form.control}
              name="image"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>URL de l'image</FormLabel>
                  <FormControl>
                    <Input placeholder="https://… (facultatif)" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name="is_active"
              render={({ field }) => (
                <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3">
                  <div className="space-y-0.5">
                    <FormLabel>Produit actif</FormLabel>
                    <FormDescription>
                      Un produit inactif est retiré du catalogue de vente mais conservé pour
                      l'historique.
                    </FormDescription>
                  </div>
                  <FormControl>
                    <Switch checked={field.value} onCheckedChange={field.onChange} />
                  </FormControl>
                </FormItem>
              )}
            />

            {rootMessage ? (
              <div className="rounded-md border border-destructive/30 bg-destructive/10 px-3 py-2.5 text-sm font-medium text-destructive">
                {rootMessage}
              </div>
            ) : null}

            <DialogFooter>
              <Button
                type="button"
                variant="outline"
                onClick={() => onOpenChange(false)}
                disabled={submitting}
              >
                Annuler
              </Button>
              <Button type="submit" disabled={submitting}>
                {submitting ? <Loader2 className="animate-spin" /> : null}
                {isCreate ? 'Créer le produit' : 'Enregistrer'}
              </Button>
            </DialogFooter>
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  );
}
