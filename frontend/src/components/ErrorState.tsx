import { RefreshCw, TriangleAlert } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';

interface ErrorStateProps {
  message: string;
  onRetry: () => void;
}

/** Bloc d'erreur standardisé affiché quand une liste ne peut pas être chargée. */
export function ErrorState({ message, onRetry }: ErrorStateProps) {
  return (
    <Card className="border-destructive/30">
      <CardContent className="flex flex-col items-center gap-3 p-10 text-center">
        <TriangleAlert className="h-8 w-8 text-destructive" />
        <p className="text-sm font-medium">{message}</p>
        <Button variant="outline" size="sm" onClick={onRetry}>
          <RefreshCw />
          Réessayer
        </Button>
      </CardContent>
    </Card>
  );
}
