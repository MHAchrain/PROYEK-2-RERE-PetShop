import { useState } from "react";
import { formatPhone } from "../utils/formatphone";
import { validateLogin, validateRegister } from "../utils/validation";
import axios from "axios";
import toast from "react-hot-toast";

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

        const endpoint = isLogin ? "login" : "register";

        try {
            const response = await axios.post(
                `http://127.0.0.1:8000/api/${endpoint}`,
                isLogin
                    ? {
                        email: cleanIdentifier,
                        password: form.password,
                    }
                    : {
                        ...form,
                        email: cleanIdentifier,
                        no_hp: formatPhone(cleanNoHp),
                    }
            );

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
            const errors = error.response?.data?.errors;

            if (errors) {
                Object.values(errors).forEach((err) =>
                    toast.error(err[0])
                );
            } else {
                toast.error("Terjadi kesalahan");
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