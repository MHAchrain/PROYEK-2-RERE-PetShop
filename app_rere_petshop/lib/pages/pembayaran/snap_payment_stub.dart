// Stub implementation for platforms other than web
void openSnapWeb({
  required String snapToken,
  required void Function(dynamic result) onSuccess,
  required void Function(dynamic result) onPending,
  required void Function(dynamic result) onError,
  required void Function() onClose,
}) {
  // No-op on mobile/desktop since WebView is used instead
}
