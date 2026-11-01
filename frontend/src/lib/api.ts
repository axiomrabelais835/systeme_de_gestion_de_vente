import axios, { AxiosError, type InternalAxiosRequestConfig } from 'axios';

/** URL de base de l'API (CORS autorise http://localhost:5173). */
export const API_BASE_URL =
  (import.meta.env.VITE_API_URL as string | undefined) ?? 'http://127.0.0.1:8000/api/v1';

export const TOKEN_STORAGE_KEY = 'salesstock_token';
export const USER_STORAGE_KEY = 'salesstock_user';
export const SESSION_EXPIRED_EVENT = 'salesstock:session-expired';

/** Enveloppe de succès : { success, data, meta }. */
export interface ApiEnvelope<T> {
  success: boolean;
  data: T;
  meta: PaginationMeta;
}

/** Enveloppe d'erreur : { success, message, errors }. */
export interface ApiErrorEnvelope {
  success: false;
  message: string;
  errors?: Record<string, string[]>;
}

export interface PaginationMeta {
  current_page: number;
  per_page: number;
  total: number;
  last_page: number;
}

/** Erreur normalisée du client API (messages en français). */
export class ApiError extends Error {
  readonly status: number;
  readonly errors: Record<string, string[]>;

  constructor(message: string, status: number, errors: Record<string, string[]> = {}) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
    this.errors = errors;
  }

  /** Erreurs de validation champ par champ (422). */
  get fieldErrors(): Record<string, string[]> {
    return this.errors;
  }
}

export const api = axios.create({
  baseURL: API_BASE_URL,
  headers: { Accept: 'application/json' },
});

api.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  const token = localStorage.getItem(TOKEN_STORAGE_KEY);
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error: AxiosError<ApiErrorEnvelope>) => {
    const status = error.response?.status ?? 0;
    const body = error.response?.data;

    if (status === 401) {
      // Session expirée ou token révoqué : on purge le stockage local et on
      // notifie l'application (ProtectedRoute redirige vers /login).
      localStorage.removeItem(TOKEN_STORAGE_KEY);
      localStorage.removeItem(USER_STORAGE_KEY);
      window.dispatchEvent(new Event(SESSION_EXPIRED_EVENT));
    }

    let message: string;
    if (status === 0) {
      message =
        'Impossible de contacter le serveur. Vérifiez que le backend est démarré (php artisan serve).';
    } else if (typeof body?.message === 'string' && body.message.length > 0) {
      message = body.message;
    } else if (status === 403) {
      message = "Vous n'avez pas les permissions nécessaires pour effectuer cette action.";
    } else if (status === 404) {
      message = 'Ressource introuvable.';
    } else if (status === 429) {
      message = 'Trop de tentatives. Veuillez réessayer dans quelques instants.';
    } else {
      message = 'Une erreur est survenue. Veuillez réessayer.';
    }

    return Promise.reject(new ApiError(message, status, body?.errors ?? {}));
  },
);

/** GET renvoyant la donnée et la méta de pagination. */
export async function apiGet<T>(
  url: string,
  params?: Record<string, unknown>,
): Promise<{ data: T; meta: PaginationMeta }> {
  const { data } = await api.get<ApiEnvelope<T>>(url, { params });
  return { data: data.data, meta: data.meta ?? ({} as PaginationMeta) };
}

/** POST renvoyant la donnée. */
export async function apiPost<T>(url: string, body?: unknown): Promise<T> {
  const { data } = await api.post<ApiEnvelope<T>>(url, body);
  return data.data;
}

/** PUT renvoyant la donnée. */
export async function apiPut<T>(url: string, body?: unknown): Promise<T> {
  const { data } = await api.put<ApiEnvelope<T>>(url, body);
  return data.data;
}

/** PATCH renvoyant la donnée. */
export async function apiPatch<T>(url: string, body?: unknown): Promise<T> {
  const { data } = await api.patch<ApiEnvelope<T>>(url, body);
  return data.data;
}

/** DELETE renvoyant la donnée. */
export async function apiDelete<T>(url: string): Promise<T> {
  const { data } = await api.delete<ApiEnvelope<T>>(url);
  return data.data;
}

export default api;
