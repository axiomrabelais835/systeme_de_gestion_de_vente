import { Navigate, RouterProvider, createBrowserRouter } from 'react-router-dom';

import { ProtectedRoute } from '@/components/ProtectedRoute';
import { AppLayout } from '@/components/layout/AppLayout';
import CategoriesPage from '@/pages/CategoriesPage';
import CustomersPage from '@/pages/CustomersPage';
import DashboardPage from '@/pages/DashboardPage';
import LoginPage from '@/pages/LoginPage';
import NotFoundPage from '@/pages/NotFoundPage';
import ProductsPage from '@/pages/ProductsPage';
import NewSalePage from '@/pages/NewSalePage';
import SalesPage from '@/pages/SalesPage';
import SettingsPage from '@/pages/SettingsPage';
import StockMovementsPage from '@/pages/StockMovementsPage';

const router = createBrowserRouter([
  { path: '/login', element: <LoginPage /> },
  {
    path: '/',
    element: (
      <ProtectedRoute>
        <AppLayout />
      </ProtectedRoute>
    ),
    children: [
      { index: true, element: <Navigate to="/tableau-de-bord" replace /> },
      { path: 'tableau-de-bord', element: <DashboardPage /> },
      { path: 'produits', element: <ProductsPage /> },
      { path: 'ventes', element: <SalesPage /> },
      { path: 'ventes/nouvelle', element: <NewSalePage /> },
      { path: 'clients', element: <CustomersPage /> },
      { path: 'categories', element: <CategoriesPage /> },
      { path: 'mouvements', element: <StockMovementsPage /> },
      {
        path: 'parametres',
        element: (
          <ProtectedRoute adminOnly>
            <SettingsPage />
          </ProtectedRoute>
        ),
      },
      { path: '*', element: <NotFoundPage /> },
    ],
  },
]);

export default function App() {
  return <RouterProvider router={router} />;
}
