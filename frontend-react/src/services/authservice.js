import api from "../api/axios";

export const loginUser = async (data) => {
  const res = await api.post("/login", data);
  return res.data;
};

export const registerUser = async (data) => {
  const res = await api.post("/register", data);
  return res.data;
};

export const sendResetCode = async (data) => {
  const res = await api.post("/forgot-password/send-code", data);
  return res.data;
};

export const verifyResetCode = async (data) => {
  const res = await api.post("/forgot-password/verify-code", data);
  return res.data;
};

export const resetPassword = async (data) => {
  const res = await api.post("/forgot-password/reset", data);
  return res.data;
};

export const loginWithGoogle = async (accessToken) => {
  const res = await api.post("/login/google", {
    access_token: accessToken,
  });
  return res.data;
};

export const getUser = async () => {
  const res = await api.get("/me");
  return res.data.data;
};
