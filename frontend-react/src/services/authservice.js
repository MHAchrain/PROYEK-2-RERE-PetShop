import api from "../api/axios";

export const loginUser = async (data) => {
  const res = await api.post("/login", data);
  return res.data;
};

export const registerUser = async (data) => {
  const res = await api.post("/register", data);
  return res.data;
};

export const getUser = async () => {
  const res = await api.get("/me");
  return res.data.data;
};