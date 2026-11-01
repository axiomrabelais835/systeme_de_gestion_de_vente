import { Search } from 'lucide-react';
import { useEffect, useRef, useState } from 'react';

import { Input } from '@/components/ui/input';
import { cn } from '@/lib/utils';

interface SearchInputProps {
  value: string;
  onValueChange: (value: string) => void;
  placeholder?: string;
  className?: string;
  debounceMs?: number;
}

/** Champ de recherche avec anti-rebond, piloté par la valeur du parent. */
export function SearchInput({
  value,
  onValueChange,
  placeholder = 'Rechercher…',
  className,
  debounceMs = 350,
}: SearchInputProps) {
  const [local, setLocal] = useState(value);
  const onChangeRef = useRef(onValueChange);

  // On suit la valeur externe (ex. : remise à zéro des filtres).
  useEffect(() => {
    setLocal(value);
  }, [value]);

  // Ref pour éviter de recréer le minuteur à chaque rendu parent.
  useEffect(() => {
    onChangeRef.current = onValueChange;
  }, [onValueChange]);

  useEffect(() => {
    if (local === value) {
      return;
    }
    const timer = setTimeout(() => onChangeRef.current(local), debounceMs);
    return () => clearTimeout(timer);
  }, [local, value, debounceMs]);

  return (
    <div className={cn('relative', className)}>
      <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
      <Input
        value={local}
        onChange={(event) => setLocal(event.target.value)}
        placeholder={placeholder}
        className="pl-9"
        type="search"
      />
    </div>
  );
}
