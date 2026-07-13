import { CheckCircle2, LoaderCircle, OctagonAlert, X } from "lucide-react";
import { toast as hotToast } from "react-hot-toast";

const variantMap = {
  success: {
    icon: CheckCircle2,
  },
  error: {
    icon: OctagonAlert,
  },
  loading: {
    icon: LoaderCircle,
  },
};

export default function ToastCard({ t, message, variant = "success" }) {
  const config = variantMap[variant] || variantMap.success;
  const Icon = config.icon;

  return (
    <div
      className={`rere-toast-card rere-toast-card-${variant} ${
        t.visible ? "animate-enter" : "animate-leave"
      }`}
    >

      <div className="rere-toast-body">
        <div className="rere-toast-icon-wrap">
          <Icon
            size={20}
            className={`rere-toast-icon ${variant === "loading" ? "rere-toast-spin" : ""}`}
          />
        </div>

        <div className="rere-toast-copy">
          <p className="rere-toast-title">
            {variant === "success" && "BERHASIL"}
            {variant === "error" && "GAGAL"}
            {variant === "loading" && "Sedang diproses"}
          </p>
          <p className="rere-toast-message">{message}</p>
        </div>

        <button
          type="button"
          onClick={() => hotToast.dismiss(t.id)}
          className="rere-toast-close"
          aria-label="Tutup notifikasi"
        >
          <X size={16} />
        </button>
      </div>
    </div>
  );
}
