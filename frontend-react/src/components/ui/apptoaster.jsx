import { Toaster } from "react-hot-toast";

export default function AppToaster() {
  return (
    <Toaster
      position="top-center"
      gutter={14}
      containerClassName="rere-toast-container"
      toastOptions={{
        duration: 3600,
      }}
    />
  );
}
