import { zodResolver } from '@hookform/resolvers/zod';
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
import { Textarea } from '@/components/ui/textarea';
import { ApiError } from '@/lib/api';
import type { Customer } from '@/lib/types';

const customerSchema = z.object({
  name: z
    .string()
    .trim()
    .min(1, 'Le nom du client est obligatoire.')
    .max(200, 'Le nom ne peut pas dépasser 200 caractères.'),
  email: z
    .string()
    .trim()
    .email("L'adresse e-mail est invalide.")
    .max(200, "L'adresse e-mail ne peut pas dépasser 200 caractères.")
    .optional()
    .or(z.literal('')),
  phone: z
    .string()
    .trim()
    .max(50, 'Le téléphone ne peut pas dépasser 50 caractères.')
    .optional()
    .or(z.literal('')),
  address: z
    .string()
    .trim()
    .max(255, "L'adresse ne peut pas dépasser 255 caractères.")
    .optional()
    .or(z.literal('')),
  notes: z
    .string()
    .trim()
    .max(2000, 'Les notes ne peuvent pas dépasser 2 000 caractères.')
    .optional()
    .or(z.literal('')),
});

type CustomerValues = z.infer<typeof customerSchema>;

interface CustomerFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  /** Client à éditer, ou null pour la création. */
  customer: Customer | null;
  onSubmit: (payload: Record<string, unknown>) => Promise<void>;
  submitting: boolean;
}

export function CustomerFormDialog({
  open,
  onOpenChange,
  customer,
  onSubmit,
  submitting,
}: CustomerFormDialogProps) {
  const isCreate = customer === null;

  const form = useForm<CustomerValues>({
    resolver: zodResolver(customerSchema),
    defaultValues: {
      name: '',
      email: '',
      phone: '',
      address: '',
      notes: '',
    },
  });

  // Réinitialise le formulaire à chaque ouverture (création ou édition).
  useEffect(() => {
    if (!open) return;
    form.reset({
      name: customer?.name ?? '',
      email: customer?.email ?? '',
      phone: customer?.phone ?? '',
      address: customer?.address ?? '',
      notes: customer?.notes ?? '',
    });
  }, [open, customer, form]);

  const handleValid = async (values: CustomerValues) => {
    const payload: Record<string, unknown> = {
      name: values.name,
      email: values.email || null,
      phone: values.phone || null,
      address: values.address || null,
      notes: values.notes || null,
    };

    try {
      await onSubmit(payload);
    } catch (error) {
      // Remontée des erreurs 422 champ par champ (libellés français du serveur).
      if (error instanceof ApiError && error.status === 422) {
        let applied = false;
        for (const [field, messages] of Object.entries(error.fieldErrors)) {
          if (messages?.length) {
            form.setError(field as keyof CustomerValues, { message: messages[0] });
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
      <DialogContent className="max-h-[90vh] overflow-y-auto sm:max-w-xl">
        <DialogHeader>
          <DialogTitle>{isCreate ? 'Nouveau client' : 'Modifier le client'}</DialogTitle>
          <DialogDescription>
            {isCreate
              ? "Renseignez les coordonnées du client. Seul le nom est obligatoire."
              : 'Modifiez les coordonnées du client. Son historique d\'achats est conservé.'}
          </DialogDescription>
        </DialogHeader>

        <Form {...form}>
          <form onSubmit={form.handleSubmit(handleValid)} className="space-y-4" noValidate>
            <FormField
              control={form.control}
              name="name"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Nom du client</FormLabel>
                  <FormControl>
                    <Input placeholder="Ex. : Aminata Koné" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <div className="grid gap-4 sm:grid-cols-2">
              <FormField
                control={form.control}
                name="email"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Adresse e-mail</FormLabel>
                    <FormControl>
                      <Input type="email" placeholder="client@exemple.ci (facultatif)" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="phone"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Téléphone</FormLabel>
                    <FormControl>
                      <Input placeholder="+225 07 00 00 00 00 (facultatif)" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <FormField
              control={form.control}
              name="address"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Adresse</FormLabel>
                  <FormControl>
                    <Input placeholder="Quartier, ville (facultatif)" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name="notes"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Notes</FormLabel>
                  <FormControl>
                    <Textarea
                      placeholder="Préférences, conditions particulières… (facultatif)"
                      rows={3}
                      {...field}
                    />
                  </FormControl>
                  <FormDescription>Visibles uniquement par votre équipe.</FormDescription>
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
                {isCreate ? 'Créer le client' : 'Enregistrer'}
              </Button>
            </DialogFooter>
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  );
}
