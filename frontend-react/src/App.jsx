import Navbar from "./components/layouts/navbar";
import AuthPage from "./pages/authpage";
import { BrowserRouter } from "react-router-dom";

export default function App() {
  return (
    <BrowserRouter>
      <AuthPage />
    </BrowserRouter>
  );
}