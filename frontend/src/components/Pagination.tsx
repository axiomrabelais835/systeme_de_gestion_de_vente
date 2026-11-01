import { ChevronLeft, ChevronRight } from 'lucide-react';

import { Button } from '@/components/ui/button';
import type { PaginationMeta } from '@/lib/api';
import { formatNumber } from '@/lib/format';

interface PaginationProps {
  meta?: PaginationMeta;
  onPageChange: (page: number) => void;
  /** Désactive les boutons pendant le chargement de la page cible. */
  isFetching?: boolean;
}

/** Pagination standardisée pilotée par la méta de l'API ({ current_page, last_page, total }). */
export function Pagination({ meta, onPageChange, isFetching = false }: PaginationProps) {
  const current = meta?.current_page ?? 1;
  const last = Math.max(meta?.last_page ?? 1, 1);
  const total = meta?.total ?? 0;

  // Une seule page et aucun élément : rien à paginer.
  if (last <= 1 && total === 0) {
    return null;
  }

  return (
    <div className="flex flex-col items-center justify-between gap-3 sm:flex-row">
      <p className="text-sm text-muted-foreground">
        {formatNumber(total)} élément(s) · Page {formatNumber(current)} sur {formatNumber(last)}
      </p>
      <div className="flex items-center gap-2">
        <Button
          variant="outline"
          size="sm"
          disabled={current <= 1 || isFetching}
          onClick={() => onPageChange(current - 1)}
        >
          <ChevronLeft />
          Précédent
        </Button>
        <Button
          variant="outline"
          size="sm"
          disabled={current >= last || isFetching}
          onClick={() => onPageChange(current + 1)}
        >
          Suivant
          <ChevronRight />
        </Button>
      </div>
    </div>
  );
}
