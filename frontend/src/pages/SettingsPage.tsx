import { zodResolver } from '@hookform/resolvers/zod';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { Building2, Loader2, Percent, Save } from 'lucide-react';
import { useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { toast } from 'sonner';
import { z } from 'zod';

import { ErrorState } from '@/components/ErrorState';
import { PageHeader } from '@/components/layout/PageHeader';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
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
import { Skeleton } from '@/components/ui/skeleton';
import { ApiError, apiGet, apiPut } from '@/lib/api';
import type { AppSettings } from '@/lib/types';

/**
 * Les valeurs numériques sont saisies en chaîne puis converties à l'envoi
 * (mêmes garde-fous que les formulaires produit).
 */
function numericString(
  label: string,
  opts: { min?: number; max?: number; integer?: boolean } = {},
) {
  const { min = 0, max, integer = false } = opts;
  return z
    .string()
    .trim()
    .min(1, `${label} est obligatoire.`)
    .superRefine((value, ctx) => {
      const n = Number(value.replace(',', '.'));
      if (!Number.isFinite(n)) {
        ctx.addIssue({ code: z.ZodIssueCode.custom, message: `${label} doit être un nombre.` });
        return;
      }
      if (integer && !Number.isInteger(n)) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: `${label} doit être un nombre entier.`,
        });
        return;
      }
      if (n < min) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: `${label} ne peut pas être inférieur à ${min}.`,
        });
        return;
      }
      if (max !== undefined && n > max) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: `${label} ne peut pas dépasser ${max}.`,
        });
      }
    });
}

const settingsSchema = z.object({
  company_name: z
    .string()
    .trim()
    .min(1, 'Le nom de la société est obligatoire.')
    .max(120, 'Le nom ne peut pas dépasser 120 caractères.'),
  currency: z
    .string()
    .trim()
    .min(1, 'La devise est obligatoire.')
    .max(12, 'La devise ne peut pas dépasser 12 caractères.'),
  currency_symbol: z
    .string()
    .trim()
    .min(1, 'Le symbole de la devise est obligatoire.')
    .max(12, 'Le symbole ne peut pas dépasser 12 caractères.'),
  default_tax_rate: numericString('Le taux de TVA', { min: 0, max: 100 }),
  default_low_stock_threshold: numericString('Le seuil de stock par défaut', {
    min: 0,
    max: 100000,
    integer: true,
  }),
});

type SettingsValues = z.infer<typeof settingsSchema>;

/* ---------------------------------- Page ---------------------------------- */

export default function SettingsPage() {
  const queryClient = useQueryClient();

  const settingsQuery = useQuery({
    queryKey: ['settings'],
    queryFn: () => apiGet<AppSettings>('/settings').then((r) => r.data),
  });

  const form = useForm<SettingsValues>({
    resolver: zodResolver(settingsSchema),
    defaultValues: {
      company_name: '',
      currency: '',
      currency_symbol: '',
      default_tax_rate: '',
      default_low_stock_threshold: '',
    },
  });

  // Pré-remplit le formulaire dès que les réglages arrivent.
  const settings = settingsQuery.data;
  useEffect(() => {
    if (!settings) return;
    form.reset({
      company_name: settings.company_name,
      currency: settings.currency,
      currency_symbol: settings.currency_symbol,
      default_tax_rate: String(settings.default_tax_rate),
      default_low_stock_threshold: String(settings.default_low_stock_threshold),
    });
  }, [settings, form]);

  const updateMutation = useMutation({
    mutationFn: (payload: Record<string, unknown>) => apiPut<AppSettings>('/settings', payload),
    onSuccess: () => {
      toast.success('Paramètres enregistrés.');
      // Rafraîchit l'écran et les pages qui lisent la TVA (estimation de vente…).
      void queryClient.invalidateQueries({ queryKey: ['settings'] });
    },
  });

  const handleValid = async (values: SettingsValues) => {
    const num = (v: string) => Number(v.replace(',', '.'));
    try {
      await updateMutation.mutateAsync({
        company_name: values.company_name,
        currency: values.currency,
        currency_symbol: values.currency_symbol,
        default_tax_rate: num(values.default_tax_rate),
        default_low_stock_threshold: num(values.default_low_stock_threshold),
      });
    } catch (error) {
      if (error instanceof ApiError && error.status === 422) {
        let applied = false;
        for (const [field, messages] of Object.entries(error.fieldErrors)) {
          if (messages?.length) {
            form.setError(field as keyof SettingsValues, { message: messages[0] });
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
    <>
      <PageHeader
        title="Paramètres"
        description="Réglages de la boutique : devise, TVA, seuils d'alerte (réservé aux administrateurs)."
      />

      {settingsQuery.isLoading ? (
        <div className="space-y-4">
          <Skeleton className="h-48 w-full" />
          <Skeleton className="h-48 w-full" />
        </div>
      ) : settingsQuery.isError || !settings ? (
        <ErrorState
          message={settingsQuery.error?.message ?? 'Impossible de charger les paramètres.'}
          onRetry={() => void settingsQuery.refetch()}
        />
      ) : (
        /* --------------------------------- Formulaire --------------------------------- */
        <Form {...form}>
          <form onSubmit={form.handleSubmit(handleValid)} className="space-y-4" noValidate>
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Building2 className="h-4 w-4" />
                  Société
                </CardTitle>
                <CardDescription>
                  Informations affichées dans l'application et les documents.
                </CardDescription>
              </CardHeader>
              <CardContent className="grid gap-4 sm:grid-cols-3">
                <FormField
                  control={form.control}
                  name="company_name"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Nom de la société</FormLabel>
                      <FormControl>
                        <Input placeholder="Ex. : SalesStock CI" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="currency"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Devise</FormLabel>
                      <FormControl>
                        <Input placeholder="Ex. : FCFA" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="currency_symbol"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Symbole</FormLabel>
                      <FormControl>
                        <Input placeholder="Ex. : F CFA" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Percent className="h-4 w-4" />
                  Ventes et stock
                </CardTitle>
                <CardDescription>
                  La TVA par défaut alimente l'estimation des ventes ; le seuil pré-remplit les
                  nouveaux produits.
                </CardDescription>
              </CardHeader>
              <CardContent className="grid gap-4 sm:grid-cols-2">
                <FormField
                  control={form.control}
                  name="default_tax_rate"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Taux de TVA par défaut (%)</FormLabel>
                      <FormControl>
                        <Input type="number" min="0" max="100" step="any" placeholder="18" {...field} />
                      </FormControl>
                      <FormDescription>Appliqué à chaque nouvelle vente (0 à 100).</FormDescription>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="default_low_stock_threshold"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Seuil d'alerte par défaut</FormLabel>
                      <FormControl>
                        <Input type="number" min="0" step="1" placeholder="5" {...field} />
                      </FormControl>
                      <FormDescription>
                        Proposé à la création d'un produit (alerte si stock ≤ seuil).
                      </FormDescription>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </CardContent>
            </Card>

            {rootMessage ? (
              <div className="rounded-md border border-destructive/30 bg-destructive/10 px-3 py-2.5 text-sm font-medium text-destructive">
                {rootMessage}
              </div>
            ) : null}

            <div className="flex justify-end">
              <Button type="submit" disabled={updateMutation.isPending}>
                {updateMutation.isPending ? <Loader2 className="animate-spin" /> : <Save />}
                Enregistrer les paramètres
              </Button>
            </div>
          </form>
        </Form>
      )}
    </>
  );
}
