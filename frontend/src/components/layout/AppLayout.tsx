import { useState } from 'react';
import { Outlet } from 'react-router-dom';

import { Sidebar } from './Sidebar';
import { Topbar } from './Topbar';

/** Coquille de l'application : barre latérale + barre supérieure + contenu. */
export function AppLayout() {
  const [sidebarOpen, setSidebarOpen] = useState(false);

  return (
    <div className="min-h-screen bg-background">
      <Sidebar open={sidebarOpen} onClose={() => setSidebarOpen(false)} />

      <div className="flex min-h-screen flex-col lg:pl-[260px]">
        <Topbar onOpenSidebar={() => setSidebarOpen(true)} />

        <main className="flex-1 p-4 sm:p-6 lg:p-8">
          <div className="mx-auto w-full max-w-[1400px] animate-fade-in-up">
            <Outlet />
          </div>
        </main>
      </div>
    </div>
  );
}
