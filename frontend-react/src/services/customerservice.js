import axios from "../api/axios";

export const customerService = {
  getProfile: async () => {
    const res = await axios.get("/api/pelanggan");
    return res.data;
  },

  updateProfile: async (data) => {
    const res = await axios.put("/api/pelanggan", data);
    return res.data;
  },
};