import { useState } from "react";
import { formatPhone } from "../utils/formatphone";
import { validateLogin, validateRegister } from "../utils/validation";
import toast from "../utils/toast.jsx";
import { loginUser, registerUser, resetPassword, sendResetCode, verifyResetCode } from "../services/authservice";

export const useAuthForm = (authMode, login, navigate, setAuthMode) => {
  const [form, setForm] = useState({
    name: "",
    email: "",
    password: "",
    confirmPassword: "",
    noHp: "",
    alamat: "",
    resetCode: "",
    newPassword: "",
    confirmNewPassword: "",
  });

  const [loading, setLoading] = useState(false);
  const [sendingCode, setSendingCode] = useState(false);
  const [verifyingCode, setVerifyingCode] = useState(false);
  const [codeSent, setCodeSent] = useState(false);
  const [codeVerified, setCodeVerified] = useState(false);
  const [remainingResetAttempts, setRemainingResetAttempts] = useState(5);
  const [resetLockMinutes, setResetLockMinutes] = useState(0);

  const isLogin = authMode === "login";
  const isRegister = authMode === "register";
  const isForgotPassword = authMode === "forgot";

  const handleChange = (field, value) => {
    if (field === "email" && isForgotPassword) {
      setCodeSent(false);
      setCodeVerified(false);
      setRemainingResetAttempts(5);
      setResetLockMinutes(0);
      setForm((prev) => ({
        ...prev,
        email: value,
        resetCode: "",
        newPassword: "",
        confirmNewPassword: "",
      }));
      return;
    }

    setForm((prev) => ({ ...prev, [field]: value }));
  };

  const resetForgotPasswordState = () => {
    setCodeSent(false);
    setCodeVerified(false);
    setRemainingResetAttempts(5);
    setResetLockMinutes(0);
    setForm((prev) => ({
      ...prev,
      resetCode: "",
      newPassword: "",
      confirmNewPassword: "",
    }));
  };

  const handleSendResetCode = async () => {
    const email = form.email.trim();

    if (!email) {
      toast.error("Email wajib diisi");
      return;
    }

    setSendingCode(true);

    try {
      const response = await sendResetCode({ email });

      if (response.success) {
        setCodeSent(true);
        setCodeVerified(false);
        setRemainingResetAttempts(5);
        setResetLockMinutes(0);
        setForm((prev) => ({
          ...prev,
          resetCode: "",
          newPassword: "",
          confirmNewPassword: "",
        }));
        toast.success(response.message || "Kode reset berhasil dikirim");
      }
    } catch (error) {
      const status = error.response?.status;
      const message = error.response?.data?.message;
      const minutesLeft = error.response?.data?.minutes_left;
      const errors = error.response?.data?.errors;

      if (status === 429) {
        if (typeof minutesLeft === "number") {
          setResetLockMinutes(minutesLeft);
        }
        toast.error(message || "Tunggu sebentar sebelum mengirim ulang kode");
      } else if (errors) {
        Object.values(errors).forEach((err) => toast.error(err[0]));
      } else {
        toast.error(message || "Gagal mengirim kode reset");
      }
    } finally {
      setSendingCode(false);
    }
  };

  const handleVerifyResetCode = async () => {
    const email = form.email.trim();

    if (!email) {
      toast.error("Email wajib diisi");
      return;
    }

    if (!form.resetCode || form.resetCode.length !== 6) {
      toast.error("Masukkan kode reset 6 digit");
      return;
    }

    setVerifyingCode(true);

    try {
      const response = await verifyResetCode({
        email,
        code: form.resetCode,
      });

      if (response.success) {
        setCodeVerified(true);
        setRemainingResetAttempts(5);
        setResetLockMinutes(0);
        toast.success(response.message || "Kode siap digunakan. Silakan masukkan kata sandi baru.");
      }
    } catch (error) {
      const status = error.response?.status;
      const message = error.response?.data?.message;
      const remainingAttempts = error.response?.data?.remaining_attempts;
      const minutesLeft = error.response?.data?.minutes_left;

      if (typeof remainingAttempts === "number") {
        setRemainingResetAttempts(remainingAttempts);
      }

      if (status === 429) {
        if (typeof minutesLeft === "number") {
          setResetLockMinutes(minutesLeft);
        }
        setCodeSent(false);
        setCodeVerified(false);
        setForm((prev) => ({
          ...prev,
          resetCode: "",
          newPassword: "",
          confirmNewPassword: "",
        }));
        toast.error(message || "Terlalu banyak percobaan. Silakan kirim ulang kode reset.");
      } else {
        toast.error(message || "Kode reset tidak valid");
      }
    } finally {
      setVerifyingCode(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    const cleanIdentifier = form.email.trim();
    const cleanNoHp = form.noHp.trim();

    let error = null;

    if (isLogin) {
      error = validateLogin(cleanIdentifier, form.password);
    } else if (isRegister) {
      error = validateRegister({
        ...form,
        email: cleanIdentifier,
        noHp: cleanNoHp,
      });
    } else if (isForgotPassword) {
      if (!cleanIdentifier) {
        error = "Email wajib diisi";
      } else if (!codeSent) {
        error = "Kirim kode reset dulu ke email kamu";
      } else if (!form.resetCode) {
        error = "Kode reset wajib diisi";
      } else if (!codeVerified) {
        error = "Konfirmasi kode reset dulu sebelum mengganti kata sandi";
      } else if (!form.newPassword || !form.confirmNewPassword) {
        error = "Kata sandi baru dan konfirmasi kata sandi wajib diisi";
      } else if (form.newPassword.length < 6) {
        error = "Kata sandi baru minimal 6 karakter";
      } else if (form.newPassword !== form.confirmNewPassword) {
        error = "Konfirmasi kata sandi baru tidak cocok";
      }
    }

    if (error) {
      toast.error(error);
      setLoading(false);
      return;
    }

    try {
      if (isLogin) {
        const response = await loginUser({
          email: cleanIdentifier,
          password: form.password,
        });

        login(response.data, response.token);
        toast.success("Selamat datang di ReRe PetShop!");
        navigate("/");
      } else if (isRegister) {
        await registerUser({
          ...form,
          email: cleanIdentifier,
          no_hp: formatPhone(cleanNoHp),
        });

        toast.success("Registrasi berhasil, silakan login");
        setForm({
          name: "",
          email: "",
          password: "",
          confirmPassword: "",
          noHp: "",
          alamat: "",
          resetCode: "",
          newPassword: "",
          confirmNewPassword: "",
        });
        setAuthMode("login");
      } else if (isForgotPassword) {
        const response = await resetPassword({
          email: cleanIdentifier,
          code: form.resetCode,
          password: form.newPassword,
          password_confirmation: form.confirmNewPassword,
        });

        toast.success(response.message || "Kata sandi berhasil direset");
        setAuthMode("login");
        resetForgotPasswordState();
        setForm((prev) => ({
          ...prev,
          password: "",
          resetCode: "",
          newPassword: "",
          confirmNewPassword: "",
        }));
      }
    } catch (error) {
      const status = error.response?.status;
      const message = error.response?.data?.message;
      const errors = error.response?.data?.errors;

      if (status === 401) {
        toast.error(message || "Email atau kata sandi salah!");
      } else if (status === 404) {
        toast.error(message || "Akun tidak ditemukan");
      } else if (status === 422) {
        if (errors) {
          Object.values(errors).forEach((err) => toast.error(err[0]));
        } else {
          toast.error(message || "Data yang kamu masukkan tidak valid");
        }
      } else if (status >= 500) {
        toast.error("Server sedang bermasalah, coba lagi nanti");
      } else if (!error.response) {
        toast.error("Koneksi gagal, periksa jaringanmu");
      } else {
        toast.error(message || "Terjadi kesalahan sistem");
      }
    } finally {
      setLoading(false);
    }
  };

  return {
    form,
    handleChange,
    handleSubmit,
    handleSendResetCode,
    resetForgotPasswordState,
    loading,
    sendingCode,
    verifyingCode,
    codeSent,
    codeVerified,
    remainingResetAttempts,
    resetLockMinutes,
    isLogin,
    isRegister,
    isForgotPassword,
    handleVerifyResetCode,
  };
};


