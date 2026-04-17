import { useEffect, useState } from "react";
import { useLocation, useNavigate, useSearchParams } from "react-router-dom";
import { normalizeSearchQuery } from "../utils/searchutils";

export const useNavbarSearch = (setMobileOpen) => {
  const navigate = useNavigate();
  const location = useLocation();
  const [searchParams] = useSearchParams();
  const [desktopQuery, setDesktopQuery] = useState("");
  const [mobileQuery, setMobileQuery] = useState("");

  useEffect(() => {
    const currentQuery = location.pathname === "/search"
      ? normalizeSearchQuery(searchParams.get("q") || "")
      : "";

    setDesktopQuery(currentQuery);
    setMobileQuery(currentQuery);
  }, [location.pathname, searchParams]);

  const goToSearch = (rawQuery) => {
    const nextQuery = normalizeSearchQuery(rawQuery);

    if (!nextQuery) {
      navigate("/search");
      setMobileOpen(false);
      return;
    }

    navigate(`/search?q=${encodeURIComponent(nextQuery)}`);
    setMobileOpen(false);
  };

  const handleDesktopSubmit = (event) => {
    event.preventDefault();
    goToSearch(desktopQuery);
  };

  const handleMobileSubmit = (event) => {
    event.preventDefault();
    goToSearch(mobileQuery);
  };

  return {
    desktopQuery,
    setDesktopQuery,
    mobileQuery,
    setMobileQuery,
    handleDesktopSubmit,
    handleMobileSubmit,
  };
};

