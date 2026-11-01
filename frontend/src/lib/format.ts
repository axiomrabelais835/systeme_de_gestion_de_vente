/** Formatters français : FCFA, dates JJ/MM/AAAA, pourcentages. */

const NBSP = /[\u00a0\u202f]/g;

/** 154698 → « 154 698 » (espace fine insécable remplacée par une espace simple). */
export function formatNumber(value: number | string | null | undefined, decimals = 0): string {
  const n = Number(value ?? 0);
  if (!Number.isFinite(n)) {
    return '0';
  }
  return n
    .toLocaleString('fr-FR', {
      minimumFractionDigits: decimals,
      maximumFractionDigits: decimals,
    })
    .replace(NBSP, ' ');
}

/** 154698 → « 154 698 F CFA ». */
export function formatFCFA(value: number | string | null | undefined): string {
  const n = Number(value ?? 0);
  if (!Number.isFinite(n)) {
    return '0 F CFA';
  }
  return `${formatNumber(n, 0)} F CFA`;
}

/** 12.5 → « 12,5 % ». */
export function formatPercent(value: number | string | null | undefined, decimals = 1): string {
  const n = Number(value ?? 0);
  if (!Number.isFinite(n)) {
    return '0 %';
  }
  return `${formatNumber(n, decimals)} %`;
}

const dateFormatter = new Intl.DateTimeFormat('fr-FR', {
  day: '2-digit',
  month: '2-digit',
  year: 'numeric',
});

const dateTimeFormatter = new Intl.DateTimeFormat('fr-FR', {
  day: '2-digit',
  month: '2-digit',
  year: 'numeric',
  hour: '2-digit',
  minute: '2-digit',
});

/** ISO → « 27/10/2026 ». */
export function formatDate(value: string | null | undefined): string {
  if (!value) {
    return '—';
  }
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? '—' : dateFormatter.format(date);
}

/** ISO → « 27/10/2026 14:30 ». */
export function formatDateTime(value: string | null | undefined): string {
  if (!value) {
    return '—';
  }
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? '—' : dateTimeFormatter.format(date);
}
