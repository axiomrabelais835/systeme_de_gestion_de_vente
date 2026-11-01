import { zodResolver } from '@hookform/resolvers/zod';
import { Loader2, Minus, PackagePlus, Plus } from 'lucide-react';
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
import { ApiError } from '@/lib/api';
import { formatNumber } from '@/lib/format';
import type { Product } from '@/lib/types';

const adjustSchema = z.object({
  quantity_delta: z
    .string()
    .trim()
    .min(1, "La quantité d'ajustement est obligatoire.")
    .refine((value) => {
      const n = Number(value.replace(',', '.'));
      return Number.isInteger(n) && n !== 0;
    }, "L'ajustement doit être un nombre entier non nul."),
  reason: z
    .string()
    .trim()
    .max(255, 'Le motif ne peut pas dépasser 255 caractères.')
    .optional()
    .or(z.literal('')),
});

type AdjustValues = z.infer<typeof adjustSchema>;

interface AdjustStockDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  product: Product | null;
  onSubmit: (payload: { quantity_delta: number; reason: string | null }) => Promise<void>;
  submitting: boolean;
}

/** Ajustement rapide de stock (+ / −) avec aperçu du nouveau solde et traçabilité. */
export function AdjustStockDialog({
  open,
  onOpenChange,
  product,
  onSubmit,
  submitting,
}: AdjustStockDialogProps) {
  const form = useForm<AdjustValues>({
    resolver: zodResolver(adjustSchema),
    defaultValues: { quantity_delta: '', reason: '' },
  });

  useEffect(() => {
    if (open) {
      form.reset({ quantity_delta: '', reason: '' });
    }
  }, [open, form]);

  const rawDelta = form.watch('quantity_delta');
  const delta = Number(String(rawDelta ?? '').replace(',', '.'));
  const current = product?.quantity ?? 0;
  const hasNext = Number.isFinite(delta);
  const next = hasNext ? current + delta : null;
  const wouldBeNegative = next !== null && next < 0;

  const handleValid = async (values: AdjustValues) => {
    const payload = {
      quantity_delta: Number(values.quantity_delta.replace(',', '.')),
      reason: values.reason?.trim() || null,
    };
    try {
      await onSubmit(payload);
    } catch (error) {
      if (error instanceof ApiError && error.status === 422) {
        let applied = false;
        for (const [field, messages] of Object.entries(error.fieldErrors)) {
          if (messages?.length) {
            form.setError(field as keyof AdjustValues, { message: messages[0] });
            applied = true;
          }
        }
        if (!applied) form.setError('root', { message: error.message });
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
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <PackagePlus className="h-5 w-5 text-primary" />
            Ajuster le stock
          </DialogTitle>
          <DialogDescription>
            {product ? `${product.name} · ${product.sku}` : ''}
          </DialogDescription>
        </DialogHeader>

        {/* Aperçu du solde */}
        <div className="grid grid-cols-3 items-center gap-2 rounded-lg border bg-muted/40 p-3 text-center">
          <div>
            <p className="text-xs text-muted-foreground">Stock actuel</p>
            <p className="text-lg font-semibold">{formatNumber(current)}</p>
          </div>
          <div className="text-muted-foreground">
            {hasNext ? (delta > 0 ? <Plus className="mx-auto h-4 w-4" /> : <Minus className="mx-auto h-4 w-4" />) : <span className="text-lg">→</span>}
          </div>
          <div>
            <p className="text-xs text-muted-foreground">Nouveau stock</p>
            <p
              className={
                next === null
                  ? 'text-lg font-semibold text-muted-foreground'
                  : wouldBeNegative
                    ? 'text-lg font-semibold text-destructive'
                    : 'text-lg font-semibold text-primary'
              }
            >
              {next === null ? '—' : formatNumber(next)}
            </p>
          </div>
        </div>
        {wouldBeNegative ? (
          <p className="text-xs font-medium text-destructive">
            Le stock ne peut pas passer sous zéro : le serveur refusera cet ajustement.
          </p>
        ) : null}

        <Form {...form}>
          <form onSubmit={form.handleSubmit(handleValid)} className="space-y-4" noValidate>
            <FormField
              control={form.control}
              name="quantity_delta"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Quantité d'ajustement</FormLabel>
                  <FormControl>
                    <Input type="number" step="1" placeholder="Ex. : 10 ou -5" {...field} />
                  </FormControl>
                  <FormDescription>
                    Entier positif pour une entrée, négatif pour une sortie. Zéro refusé.
                  </FormDescription>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name="reason"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Motif</FormLabel>
                  <FormControl>
                    <Input placeholder="Ex. : Réapprovisionnement fournisseur" {...field} />
                  </FormControl>
                  <FormDescription>Facultatif, mais recommandé pour la traçabilité.</FormDescription>
                  <FormMessage />
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
                Valider l'ajustement
              </Button>
            </DialogFooter>
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  );
}
