export const validateRegister = ({
    name,
    email,
    password,
    confirmPassword,
    noHp,
}) => {
    if (!name || !email || !password || !confirmPassword || !noHp) {
        return "Semua field wajib diisi!";
    }

    if (!/^[0-9]{10,15}$/.test(noHp)) {
        return "Nomor HP harus 10-15 digit angka!";
    }

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        return "Format email tidak valid!";
    }

    if (password.length < 8) {
        return "Password minimal 8 karakter!";
    }

    if (password !== confirmPassword) {
        return "Password tidak sama!";
    }

    return null;
};

export const validateLogin = (identifier, password) => {
    if (!identifier || !password) {
        return "Email / No HP dan password wajib diisi!";
    }

    const isEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(identifier);
    const isPhone = /^[0-9]{10,15}$/.test(identifier);

    if (!isEmail && !isPhone) {
        return "Masukkan email yang valid!";
    }

    return null;
};