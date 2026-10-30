import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class BookingDetailBottomBar extends StatelessWidget {
  const BookingDetailBottomBar({
    super.key,
    required this.status,
    required this.loading,
    required this.onPay,
    required this.onBack,
  });

  final String status;
  final bool loading;
  final VoidCallback onPay;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final needsPayment = status == 'menunggu_pembayaran';
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: const Border(top: BorderSide(color: Color(0xFFE5E5E5))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 14,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: loading ? null : (needsPayment ? onPay : onBack),
            icon: loading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(needsPayment ? Icons.payment : Icons.arrow_back),
            label: Text(needsPayment ? 'Bayar Sekarang' : 'Kembali ke Grooming'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
