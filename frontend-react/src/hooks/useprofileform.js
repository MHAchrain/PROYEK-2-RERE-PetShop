import { useEffect, useState } from "react";
import toast from "../utils/toast.jsx";
import { formatPhone } from "../utils/formatphone";
import { updateCustomerProfile } from "../services/profileservice";

export const useProfileForm = ({ user, updateUser }) => {
  const pelanggan = user?.pelanggan || user?.data?.pelanggan;
  const akunUser = user?.user || user?.data?.user || user;
  const [isLoading, setIsLoading] = useState(false);
  const [formData, setFormData] = useState({
    nama: "",
    no_hp: "",
  });

  useEffect(() => {
    if (!user) return;

    setFormData({
      nama: pelanggan?.nama || akunUser?.name || "",
      no_hp: pelanggan?.no_hp || "",
    });
  }, [user, pelanggan, akunUser]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    const sanitizedValue = name === "no_hp" ? value.replace(/\D/g, "") : value;

    setFormData((prev) => ({
      ...prev,
      [name]: name === "no_hp" ? (sanitizedValue ? formatPhone(sanitizedValue) : "") : sanitizedValue,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const toastId = toast.loading("Menyimpan perubahan...");
    setIsLoading(true);

    try {
      const response = await updateCustomerProfile({
        nama: formData.nama,
        no_hp: formData.no_hp,
      });

      if (response.success) {
        toast.success("Profil berhasil diperbarui!", { id: toastId });
        updateUser(response.data);
      }
    } catch (error) {
      console.error("Error Detail:", error.response?.data);
      toast.error(error.response?.data?.message || "Gagal memperbarui profil", { id: toastId });
    } finally {
      setIsLoading(false);
    }
  };

  return {
    akunUser,
    formData,
    isLoading,
    handleChange,
    handleSubmit,
  };
};


