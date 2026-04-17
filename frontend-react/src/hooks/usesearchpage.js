import { useEffect, useRef, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { getProducts, searchProducts } from "../services/productservice";
import { normalizeSearchQuery } from "../utils/searchutils";

export const useSearchPage = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [searchInput, setSearchInput] = useState("");
  const [results, setResults] = useState([]);
  const [recommendedProducts, setRecommendedProducts] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isRecommendedLoading, setIsRecommendedLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const requestIdRef = useRef(0);

  const submittedQuery = normalizeSearchQuery(searchParams.get("q") || "");

  useEffect(() => {
    setSearchInput(submittedQuery);
  }, [submittedQuery]);

  useEffect(() => {
    const loadRecommendedProducts = async () => {
      try {
        setIsRecommendedLoading(true);
        const data = await getProducts();
        setRecommendedProducts(Array.isArray(data) ? data.slice(0, 8) : []);
      } catch (error) {
        console.error("Gagal memuat rekomendasi produk:", error);
      } finally {
        setIsRecommendedLoading(false);
      }
    };

    loadRecommendedProducts();
  }, []);

  useEffect(() => {
    const currentRequestId = requestIdRef.current + 1;
    requestIdRef.current = currentRequestId;

    if (!submittedQuery) {
      setResults([]);
      setErrorMessage("");
      setIsLoading(false);
      return;
    }

    const loadSearchResults = async () => {
      try {
        setIsLoading(true);
        setErrorMessage("");

        const data = await searchProducts(submittedQuery);

        if (requestIdRef.current !== currentRequestId) {
          return;
        }

        setResults(Array.isArray(data) ? data : []);
      } catch (error) {
        if (requestIdRef.current !== currentRequestId) {
          return;
        }

        const status = error.response?.status;
        const message = error.response?.data?.message;

        if (status === 422) {
          setErrorMessage(message || "Kata kunci pencarian tidak valid");
          setResults([]);
          return;
        }

        setErrorMessage("Terjadi kesalahan saat mencari produk");
        setResults([]);
      } finally {
        if (requestIdRef.current === currentRequestId) {
          setIsLoading(false);
        }
      }
    };

    loadSearchResults();
  }, [submittedQuery]);

  const submitSearch = () => {
    const nextQuery = normalizeSearchQuery(searchInput);

    if (!nextQuery) {
      navigate("/search", { replace: false });
      return;
    }

    navigate(`/search?q=${encodeURIComponent(nextQuery)}`);
  };

  return {
    searchInput,
    setSearchInput,
    submitSearch,
    submittedQuery,
    results,
    recommendedProducts,
    isLoading,
    isRecommendedLoading,
    errorMessage,
  };
};

