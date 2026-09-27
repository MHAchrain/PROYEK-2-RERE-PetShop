import { useLocation } from 'react-router-dom';
import AppRoutes from './routes';
import PageLoader from './components/pageloader';
import AppToaster from './components/ui/apptoaster';
import ChatBot from './components/ChatBot/ChatBot';
import './styles/toast.css';

export default function App() {
  const location = useLocation();

  // Halaman yang GAK boleh ada chatbot
  const hideChatbotPages = ['/auth'];
  const hideChatbot = hideChatbotPages.includes(location.pathname);

  return (
    <>
      <PageLoader />
      <AppToaster />
      <AppRoutes />
      {!hideChatbot && <ChatBot />}
    </>
  );
}
