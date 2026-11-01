import { zodResolver } from '@hookform/resolvers/zod';
import { Eye, EyeOff, Loader2, LockKeyhole, Mail } from 'lucide-react';
import { useEffect, useState } from 'react';
import { useForm } from 'react-hook-form';
import { Navigate, useLocation, useNavigate } from 'react-router-dom';
import { z } from 'zod';

import { Button } from '@/components/ui/button';
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { ApiError } from '@/lib/api';
import { useAuth } from '@/lib/auth';

const loginSchema = z.object({
  email: z
    .string()
    .min(1, "L'adresse e-mail est obligatoire.")
    .email("Le format de l'adresse e-mail est invalide."),
  password: z.string().min(1, 'Le mot de passe est obligatoire.'),
});

type LoginValues = z.infer<typeof loginSchema>;

const DEMO_ACCOUNTS = [
  { email: 'admin@salesstock.test', password: 'password', label: 'Administrateur' },
  { email: 'vendeur@salesstock.test', password: 'password', label: 'Vendeur' },
];

export default function LoginPage() {
  const { user, login } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [showPassword, setShowPassword] = useState(false);
  const [submitting, setSubmitting] = useState(false);

  const from = (location.state as { from?: string } | null)?.from ?? '/tableau-de-bord';

  const form = useForm<LoginValues>({
    resolver: zodResolver(loginSchema),
    defaultValues: { email: '', password: '' },
  });

  // Déjà connecté → retour vers la page demandée.
  useEffect(() => {
    if (user) {
      navigate(from, { replace: true });
    }
  }, [user, from, navigate]);

  const onSubmit = async (values: LoginValues) => {
    setSubmitting(true);
    form.clearErrors('root');
    try {
      await login(values.email, values.password);
      navigate(from, { replace: true });
    } catch (error) {
      if (error instanceof ApiError) {
        if (error.status === 422 && Object.keys(error.fieldErrors).length > 0) {
          for (const [field, messages] of Object.entries(error.fieldErrors)) {
            if (field === 'email' || field === 'password') {
              form.setError(field, { message: messages[0] });
            }
          }
        } else {
          form.setError('root', { message: error.message });
        }
      } else {
        form.setError('root', { message: 'Une erreur inattendue est survenue.' });
      }
    } finally {
      setSubmitting(false);
    }
  };

  if (user) {
    return <Navigate to={from} replace />;
  }

  const rootMessage = form.formState.errors.root?.message;

  return (
    <div className="flex min-h-screen">
      {/* Panneau de marque */}
      <div className="relative hidden w-1/2 overflow-hidden bg-gradient-to-br from-indigo-600 via-indigo-700 to-indigo-900 lg:flex lg:flex-col lg:justify-between lg:p-12">
        <div
          className="absolute inset-0 opacity-20"
          style={{
            backgroundImage:
              'radial-gradient(circle at 20% 20%, rgba(255,255,255,0.35) 0, transparent 40%), radial-gradient(circle at 80% 70%, rgba(255,255,255,0.25) 0, transparent 45%)',
          }}
          aria-hidden="true"
        />

        <div className="relative flex items-center gap-3">
          <span className="flex h-11 w-11 items-center justify-center rounded-xl bg-white/15 text-xl font-bold text-white backdrop-blur">
            S
          </span>
          <div className="leading-tight">
            <p className="text-lg font-semibold text-white">SalesStock</p>
            <p className="text-sm text-white/70">Gestion commerciale</p>
          </div>
        </div>

        <div className="relative max-w-md">
          <h1 className="text-3xl font-bold leading-tight text-white xl:text-4xl">
            Pilotez vos ventes et vos stocks en toute confiance.
          </h1>
          <p className="mt-4 text-base text-white/75">
            Une plateforme fiable pour enregistrer vos ventes, suivre vos stocks en temps réel et
            piloter votre activité.
          </p>
          <ul className="mt-8 space-y-3 text-sm text-white/90">
            {[
              'Ventes transactionnelles : plus jamais de stock négatif',
              'Alertes automatiques de stock bas et ruptures',
              'Tableau de bord avec CA, tendances et meilleures ventes',
              'Rôles et permissions : administrateur, vendeur',
            ].map((feature) => (
              <li key={feature} className="flex items-start gap-2.5">
                <span className="mt-0.5 flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-white/20 text-xs font-bold">
                  ✓
                </span>
                {feature}
              </li>
            ))}
          </ul>
        </div>

        <p className="relative text-sm text-white/60">
          © {new Date().getFullYear()} SalesStock — Tous droits réservés.
        </p>
      </div>

      {/* Formulaire */}
      <div className="flex w-full items-center justify-center px-4 py-10 sm:px-8 lg:w-1/2">
        <div className="w-full max-w-md">
          <div className="mb-8 lg:hidden">
            <span className="flex h-11 w-11 items-center justify-center rounded-xl bg-primary text-xl font-bold text-white">
              S
            </span>
          </div>

          <h2 className="text-2xl font-semibold tracking-tight">Connexion</h2>
          <p className="mt-1 text-sm text-muted-foreground">
            Accédez à votre espace SalesStock pour gérer vos ventes et vos stocks.
          </p>

          <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)} className="mt-8 space-y-5" noValidate>
              <FormField
                control={form.control}
                name="email"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Adresse e-mail</FormLabel>
                    <div className="relative">
                      <Mail className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                      <FormControl>
                        <Input
                          type="email"
                          autoComplete="email"
                          placeholder="vous@exemple.com"
                          className="pl-9"
                          {...field}
                        />
                      </FormControl>
                    </div>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="password"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Mot de passe</FormLabel>
                    <div className="relative">
                      <LockKeyhole className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                      <FormControl>
                        <Input
                          type={showPassword ? 'text' : 'password'}
                          autoComplete="current-password"
                          placeholder="••••••••"
                          className="pl-9 pr-10"
                          {...field}
                        />
                      </FormControl>
                      <button
                        type="button"
                        onClick={() => setShowPassword((v) => !v)}
                        className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground transition-colors hover:text-foreground"
                        aria-label={showPassword ? 'Masquer le mot de passe' : 'Afficher le mot de passe'}
                      >
                        {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                      </button>
                    </div>
                    <FormMessage />
                  </FormItem>
                )}
              />

              {rootMessage ? (
                <div className="rounded-md border border-destructive/30 bg-destructive/10 px-3 py-2.5 text-sm font-medium text-destructive">
                  {rootMessage}
                </div>
              ) : null}

              <Button type="submit" className="w-full" disabled={submitting}>
                {submitting ? (
                  <>
                    <Loader2 className="animate-spin" />
                    Connexion en cours…
                  </>
                ) : (
                  'Se connecter'
                )}
              </Button>
            </form>
          </Form>

          <div className="mt-6 rounded-lg border bg-muted/40 p-4">
            <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
              Comptes de démonstration
            </p>
            <div className="mt-2 space-y-2">
              {DEMO_ACCOUNTS.map((account) => (
                <button
                  key={account.email}
                  type="button"
                  onClick={() => {
                    form.setValue('email', account.email);
                    form.setValue('password', account.password);
                    form.clearErrors();
                  }}
                  className="flex w-full items-center justify-between rounded-md border bg-background px-3 py-2 text-left text-xs transition-colors hover:border-primary/50 hover:bg-accent"
                >
                  <span className="font-medium">{account.label}</span>
                  <span className="text-muted-foreground">{account.email}</span>
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
