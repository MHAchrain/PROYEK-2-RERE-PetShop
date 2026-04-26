import { useState } from "react";
import toast from "../utils/toast.jsx";
import { updateCustomerProfile } from "../services/profileservice";

export const useSecurityForm = ({ updateUser }) => {
  const [isLoading, setIsLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [pwdData, setPwdData] = useState({
    password: "",
    password_confirmation: "",
  });

  const handleChange = (field, value) => {
    setPwdData((prev) => ({ ...prev, [field]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (pwdData.password.length < 6) {
      toast.error("Password minimal 6 karakter");
      return;
    }

    if (pwdData.password !== pwdData.password_confirmation) {
      toast.error("Konfirmasi password tidak cocok!");
      return;
    }

    const toastId = toast.loading("Mengubah password...");
    setIsLoading(true);

    try {
      const response = await updateCustomerProfile(pwdData);

      if (response.success) {
        toast.success("Password berhasil diubah!", { id: toastId });
        updateUser(response.data);
        setPwdData({ password: "", password_confirmation: "" });
      }
    } catch (error) {
      toast.error(error.response?.data?.message || "Terjadi Kesalahan Sistem", { id: toastId });
    } finally {
      setIsLoading(false);
    }
  };

  return {
    isLoading,
    showPassword,
    setShowPassword,
    showConfirmPassword,
    setShowConfirmPassword,
    pwdData,
    handleChange,
    handleSubmit,
  };
};


