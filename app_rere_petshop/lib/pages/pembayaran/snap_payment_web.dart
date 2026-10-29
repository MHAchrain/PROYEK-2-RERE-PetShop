// Web implementation for Snap payment
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;

void openSnapWeb({
  required String snapToken,
  required void Function(dynamic result) onSuccess,
  required void Function(dynamic result) onPending,
  required void Function(dynamic result) onError,
  required void Function() onClose,
}) {
  try {
    final snap = js.context['snap'];
    if (snap != null) {
      snap.callMethod('pay', [
        snapToken,
        js.JsObject.jsify({
          'onSuccess': (result) => onSuccess(result),
          'onPending': (result) => onPending(result),
          'onError': (result) => onError(result),
          'onClose': () => onClose(),
        }),
      ]);
    }
  } catch (_) {}
}
