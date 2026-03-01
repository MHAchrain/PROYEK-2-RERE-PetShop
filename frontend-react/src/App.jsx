import Navbar from "./components/layouts/navbar";
import AppRoutes from "./routes";
import { Routes, Route } from "react-router-dom";
import PageLoader from "./components/pageloader"

export default function App() {
  return (
    <>
      <PageLoader/>
      <AppRoutes />;
    </>
  );
}