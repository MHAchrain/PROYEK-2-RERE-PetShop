import AppRoutes from './routes';
import PageLoader from './components/pageloader';
import AppToaster from './components/ui/apptoaster';
import ChatBot from './components/ChatBot/ChatBot';
import './styles/toast.css';

export default function App() {
  return (
    <>
      <PageLoader />
      <AppToaster />
      <AppRoutes />
      <ChatBot />
    </>
  );
}
