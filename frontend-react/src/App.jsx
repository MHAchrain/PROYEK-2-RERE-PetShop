import AppRoutes from './routes';
import PageLoader from './components/pageloader';
import AppToaster from './components/ui/apptoaster';
import VisitHereModal from './components/ui/VisitHereModal';
import './styles/toast.css';

export default function App() {
  return (
    <>
      <PageLoader />
      <AppToaster />
      <VisitHereModal />
      <AppRoutes />
    </>
  );
}
