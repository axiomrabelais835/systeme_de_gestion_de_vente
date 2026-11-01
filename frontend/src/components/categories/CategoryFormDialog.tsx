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
import type { Category } from '@/lib/types';

const categorySchema = z.object({
  name: z
    .string()
    .trim()
    .min(1, 'Le nom de la catégorie est obligatoire.')
    .max(120, 'Le nom ne peut pas dépasser 120 caractères.'),
  description: z
    .string()
    .trim()
    .max(1000, 'La description ne peut pas dépasser 1 000 caractères.')
    .optional()
    .or(z.literal('')),
});

type CategoryValues = z.infer<typeof categorySchema>;

interface CategoryFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  /** Catégorie à éditer, ou null pour la création. */
  category: Category | null;
  onSubmit: (payload: { name: string; description: string | null }) => Promise<void>;
  submitting: boolean;
}

/** Création / édition d'une catégorie. Le slug est régénéré côté serveur au renommage. */
export function CategoryFormDialog({
  open,
  onOpenChange,
  category,
  onSubmit,
  submitting,
}: CategoryFormDialogProps) {
  const isCreate = category === null;

  const form = useForm<CategoryValues>({
    resolver: zodResolver(categorySchema),
    defaultValues: { name: '', description: '' },
  });

  useEffect(() => {
    if (!open) return;
    form.reset({
      name: category?.name ?? '',
      description: category?.description ?? '',
    });
  }, [open, category, form]);

  const handleValid = async (values: CategoryValues) => {
    try {
      await onSubmit({ name: values.name, description: values.description?.trim() || null });
    } catch (error) {
      if (error instanceof ApiError && error.status === 422) {
        let applied = false;
        for (const [field, messages] of Object.entries(error.fieldErrors)) {
          if (messages?.length) {
            form.setError(field as keyof CategoryValues, { message: messages[0] });
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
          <DialogTitle>{isCreate ? 'Nouvelle catégorie' : 'Modifier la catégorie'}</DialogTitle>
          <DialogDescription>
            {isCreate
              ? 'Ajoutez une catégorie pour organiser votre catalogue de produits.'
              : 'Renommez la catégorie ou modifiez sa description.'}
          </DialogDescription>
        </DialogHeader>

        <Form {...form}>
          <form onSubmit={form.handleSubmit(handleValid)} className="space-y-4" noValidate>
            <FormField
              control={form.control}
              name="name"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Nom de la catégorie</FormLabel>
                  <FormControl>
                    <Input placeholder="Ex. : Informatique" {...field} />
                  </FormControl>
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
                      placeholder="Description facultative…"
                      rows={3}
                      {...field}
                    />
                  </FormControl>
                  <FormDescription>
                    Facultative. Le slug est généré automatiquement à partir du nom.
                  </FormDescription>
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
                {isCreate ? 'Créer la catégorie' : 'Enregistrer'}
              </Button>
            </DialogFooter>
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  );
}
