import 'package:flutter/material.dart';

class GroomingBookingStatus {
  static String label(String status) => switch (status) {
        'menunggu_pembayaran' => 'Menunggu Pembayaran',
        'terjadwal' => 'Terjadwal',
        'dikonfirmasi' => 'Dikonfirmasi',
        'selesai' => 'Selesai',
        'dibatalkan' => 'Dibatalkan',
        'gagal' => 'Gagal',
        _ => 'Status tidak diketahui',
      };

  static String description(String status) => switch (status) {
        'menunggu_pembayaran' =>
          'Booking tercatat. Selesaikan pembayaran Midtrans agar jadwal dapat diproses.',
        'terjadwal' =>
          'Pembayaran berhasil dan jadwal grooming sudah tercatat.',
        'dikonfirmasi' => 'Booking telah dikonfirmasi oleh petshop.',
        'selesai' => 'Layanan grooming untuk anabul sudah selesai.',
        'dibatalkan' => 'Booking ini telah dibatalkan.',
        'gagal' => 'Booking ini gagal diproses. Silakan hubungi ReRe Petshop jika perlu bantuan.',
        _ => 'Status booking belum tersedia.',
      };

  static Color color(String status) => switch (status) {
        'menunggu_pembayaran' => const Color(0xFFB45309),
        'terjadwal' || 'dikonfirmasi' => const Color(0xFF1683A5),
        'selesai' => const Color(0xFF16A05D),
        'dibatalkan' || 'gagal' => const Color(0xFFB42318),
        _ => const Color(0xFF777777),
      };

  static Color background(String status) => switch (status) {
        'menunggu_pembayaran' => const Color(0xFFFFF7E8),
        'terjadwal' || 'dikonfirmasi' => const Color(0xFFEAF7FB),
        'selesai' => const Color(0xFFEAF8F0),
        'dibatalkan' || 'gagal' => const Color(0xFFFFEFEE),
        _ => const Color(0xFFF3F3F3),
      };
}
