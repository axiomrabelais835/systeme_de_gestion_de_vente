import { Compass } from 'lucide-react';
import { Link } from 'react-router-dom';

import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';

export default function NotFoundPage() {
  return (
    <div className="flex min-h-[60vh] items-center justify-center">
      <Card className="w-full max-w-md">
        <CardContent className="flex flex-col items-center gap-4 p-10 text-center">
          <span className="flex h-14 w-14 items-center justify-center rounded-full bg-primary/10 text-primary">
            <Compass className="h-7 w-7" />
          </span>
          <div>
            <p className="text-3xl font-semibold tracking-tight">404</p>
            <p className="mt-1 font-medium">Page introuvable</p>
            <p className="mt-2 text-sm text-muted-foreground">
              La page que vous cherchez n'existe pas ou a été déplacée.
            </p>
          </div>
          <Button asChild>
            <Link to="/tableau-de-bord">Retour au tableau de bord</Link>
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
