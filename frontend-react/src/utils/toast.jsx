import { toast as hotToast } from "react-hot-toast";
import ToastCard from "../components/ui/toastcard";

const DEFAULT_DURATION = 3600;

const showToast = (variant, message, options = {}) => {
  const { duration = variant === "loading" ? Infinity : DEFAULT_DURATION, id } = options;

  return hotToast.custom((t) => <ToastCard t={t} message={message} variant={variant} />, {
    id,
    duration,
  });
};

const toast = {
  success(message, options) {
    return showToast("success", message, options);
  },
  error(message, options) {
    return showToast("error", message, options);
  },
  loading(message, options) {
    return showToast("loading", message, options);
  },
  dismiss(toastId) {
    return hotToast.dismiss(toastId);
  },
  remove(toastId) {
    return hotToast.remove(toastId);
  },
};

export const showSuccessToast = toast.success;
export const showErrorToast = toast.error;
export const showLoadingToast = toast.loading;
export const dismissToast = toast.dismiss;

export default toast;
