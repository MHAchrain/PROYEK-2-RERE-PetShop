import { useEffect, useState } from "react";
import toast from "../utils/toast.jsx";
import { updateCustomerProfile } from "../services/profileservice";

export const useAddressSection = ({ user, updateUser }) => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [alamatInput, setAlamatInput] = useState("");
  const pelanggan = user?.pelanggan || user?.data?.pelanggan;

  useEffect(() => {
    setAlamatInput(pelanggan?.alamat || "");
  }, [isModalOpen, pelanggan]);

  const handleUpdateAlamat = async (e) => {
    e.preventDefault();
    const toastId = toast.loading("Memperbarui alamat...");
    setLoading(true);

    try {
      const response = await updateCustomerProfile({ alamat: alamatInput });

      if (response.success) {
        toast.success("Alamat diperbarui!", { id: toastId });
        updateUser(response.data);
        setIsModalOpen(false);
      }
    } catch (error) {
      toast.error("Gagal update alamat", { id: toastId });
    } finally {
      setLoading(false);
    }
  };

  return {
    pelanggan,
    isModalOpen,
    setIsModalOpen,
    loading,
    alamatInput,
    setAlamatInput,
    handleUpdateAlamat,
  };
};


