import { useState } from "react";
import { formatPhone } from "../utils/formatphone";
import { validateLogin, validateRegister } from "../utils/validation";
import toast from "react-hot-toast";
import { loginUser, registerUser } from "../services/authservice";

export const useAuthForm = (isLogin, login, navigate, setIsLogin) => {
    const [form, setForm] = useState({
        name: "",
        email: "",
        password: "",
        confirmPassword: "",
        noHp: "",
        alamat: "",
    });

    const [loading, setLoading] = useState(false);

    const handleChange = (field, value) => {
        setForm((prev) => ({ ...prev, [field]: value }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);

        const cleanIdentifier = form.email.trim();
        const cleanNoHp = form.noHp.trim();

        // VALIDASI
        let error = null;

        if (isLogin) {
            error = validateLogin(cleanIdentifier, form.password);
        } else {
            error = validateRegister({
                ...form,
                email: cleanIdentifier,
                noHp: cleanNoHp,
            });
        }

        if (error) {
            toast.error(error);
            setLoading(false);
            return;
        }

        try {
            const response = isLogin
                ? await loginUser({
                    email: cleanIdentifier,
                    password: form.password,
                })
                : await registerUser({
                    ...form,
                    email: cleanIdentifier,
                    no_hp: formatPhone(cleanNoHp),
                });

            if (isLogin) {
                login(response.data.data, response.data.token);
                toast.success("Selamat datang di ReRe PetShop!");
                navigate("/");
            } else {
                toast.success("Registrasi berhasil, silakan login");

                setForm({
                    name: "",
                    email: "",
                    password: "",
                    confirmPassword: "",
                    noHp: "",
                    alamat: "",
                });

                setIsLogin(true);
            }

        } catch (error) {
            const status = error.response?.status;
            const message = error.response?.data?.message;
            const errors = error.response?.data?.errors;

            if (status === 401) {
                // Biasanya untuk Password Salah
                toast.error(message || "Email atau password salah!");
            } else if (status === 404) {
                // Jika endpoint atau user tidak ditemukan
                toast.error("Akun tidak ditemukan, silakan register terlebih dahulu");
            } else if (status === 422) {
                // Error validasi dari Laravel (email sudah ada, password kurang panjang, dll)
                if (errors) {
                    Object.values(errors).forEach((err) => toast.error(err[0]));
                } else {
                    toast.error(message || "Data yang kamu masukkan tidak valid");
                }
            } else if (status >= 500) {
                // Error Server
                toast.error("Server sedang bermasalah, coba lagi nanti");
            } else if (!error.response) {
                // Error Jaringan (backend mati atau tidak terjangkau)
                toast.error("Koneksi gagal, pastikan backend sudah jalan");
            } else {
                // Error lainnya
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
        loading,
    };
};
