import Navbar from './components/layouts/navbar';
import AppRoutes from './routes';
import { Routes, Route } from 'react-router-dom';
import PageLoader from './components/pageloader';
import { Toaster } from 'react-hot-toast';

export default function App() {
  return (
    <>
      <PageLoader />
      <Toaster />
      <AppRoutes />
    </>
  );
}
