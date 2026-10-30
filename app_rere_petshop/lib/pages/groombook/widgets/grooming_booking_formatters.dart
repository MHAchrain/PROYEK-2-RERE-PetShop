class GroomingBookingFormatters {
  static int number(dynamic value) => value is num
      ? value.round()
      : double.tryParse('$value')?.round() ?? 0;

  static String rupiah(int value) {
    final digits = value.toString().split('').reversed.toList();
    final grouped = <String>[];
    for (var i = 0; i < digits.length; i += 3) {
      grouped.add(digits.skip(i).take(3).toList().reversed.join());
    }
    return 'Rp${grouped.reversed.join('.')}';
  }

  static String dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static String weekday(DateTime date) =>
      const ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'][date.weekday - 1];

  static String monthShort(int month) =>
      const ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'][month - 1];

  static String longDate(DateTime date) =>
      '${weekday(date)}, ${date.day} ${monthShort(date.month)} ${date.year}';

  static int hour(Map<String, dynamic> slot) =>
      int.tryParse('${slot['time']}'.split(':').first) ?? 0;
}
