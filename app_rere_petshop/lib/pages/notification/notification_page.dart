import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class NotificationModel {
  final String id;
  final String group; // 'today', 'yesterday', 'previous'
  final String category;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String? actionText;
  bool isUnread;

  NotificationModel({
    required this.id,
    required this.group,
    required this.category,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.actionText,
    this.isUnread = false,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String _activeTab = 'all'; // 'all' or 'unread'

  late List<NotificationModel> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      NotificationModel(
        id: '1',
        group: 'today',
        category: 'Pesanan • #RR1024',
        title: 'Pesanan Dalam Pengiriman',
        description:
            'Pesanan Anda telah dikirim oleh kurir dan sedang menuju alamat tujuan.',
        time: '10:30 WIB',
        icon: Icons.local_shipping_outlined,
        iconBg: const Color(0xFFFCECEC),
        iconColor: const Color(0xFF850909),
        actionText: 'Lihat Lacak Pesanan',
        isUnread: true,
      ),
      NotificationModel(
        id: '2',
        group: 'today',
        category: 'Grooming Service',
        title: 'Booking Grooming Dikonfirmasi',
        description:
            'Jadwal grooming untuk Milo telah dikonfirmasi untuk besok, 14:00 WIB di Cabang Dago.',
        time: '08:15 WIB',
        icon: Icons.pets,
        iconBg: const Color(0xFFFFDAD5),
        iconColor: const Color(0xFF850909),
        actionText: 'Lihat Tiket Jadwal',
        isUnread: true,
      ),
      NotificationModel(
        id: '3',
        group: 'yesterday',
        category: 'Pesanan • #RR1024',
        title: 'Pesanan Sedang Diproses',
        description:
            'Pesanan Anda sedang dikemas dan disiapkan oleh tim ReRe Petshop.',
        time: 'Kemarin, 16:45 WIB',
        icon: Icons.inventory_2_outlined,
        iconBg: const Color(0xFFF5F5F5),
        iconColor: const Color(0xFF333333),
        isUnread: true,
      ),
      NotificationModel(
        id: '4',
        group: 'yesterday',
        category: 'Pembayaran',
        title: 'Pembayaran Berhasil',
        description:
            'Pembayaran pesanan #RR1024 sebesar Rp145.000 telah berhasil diverifikasi.',
        time: 'Kemarin, 14:20 WIB',
        icon: Icons.verified_outlined,
        iconBg: const Color(0xFFECFDF5),
        iconColor: const Color(0xFF22C55E),
        isUnread: false,
      ),
      NotificationModel(
        id: '5',
        group: 'previous',
        category: 'Pesanan • #RR1024',
        title: 'Pesanan Berhasil Dibuat',
        description:
            'Pesanan #RR1024 berhasil dibuat. Menunggu konfirmasi pembayaran.',
        time: '2 hari lalu',
        icon: Icons.shopping_bag_outlined,
        iconBg: const Color(0xFFF5F5F5),
        iconColor: const Color(0xFF333333),
        isUnread: false,
      ),
      NotificationModel(
        id: '6',
        group: 'previous',
        category: 'Pesanan Selesai',
        title: 'Pesanan Selesai',
        description:
            'Pesanan #RR1019 telah selesai. Terima kasih telah berbelanja di ReRe Petshop! Berikan ulasan untuk anabul tercinta.',
        time: '5 hari lalu',
        icon: Icons.auto_awesome,
        iconBg: const Color(0xFFF5F5F5),
        iconColor: const Color(0xFF333333),
        isUnread: false,
      ),
    ];
  }

  int get _unreadCount => _notifications.where((n) => n.isUnread).length;

  List<NotificationModel> get _filteredNotifications {
    if (_activeTab == 'unread') {
      return _notifications.where((n) => n.isUnread).toList();
    }
    return _notifications;
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isUnread = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Semua notifikasi ditandai telah dibaca'),
          ],
        ),
        backgroundColor: const Color(0xFF313030),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onNotificationTap(NotificationModel item) {
    setState(() {
      item.isUnread = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka ${item.title}...'),
        backgroundColor: const Color(0xFF313030),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredNotifications;
    final todayItems = filtered.where((n) => n.group == 'today').toList();
    final yesterdayItems =
        filtered.where((n) => n.group == 'yesterday').toList();
    final previousItems =
        filtered.where((n) => n.group == 'previous').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111111)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111111),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status Info & "Tandai Semua Dibaca"
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Status: ',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13,
                          color: Color(0xFF777777),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _unreadCount > 0
                              ? const Color(0xFFFCECEC)
                              : const Color(0xFFF0EDEC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _unreadCount > 0
                              ? '$_unreadCount belum dibaca'
                              : 'Semua sudah dibaca',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _unreadCount > 0
                                ? const Color(0xFF850909)
                                : const Color(0xFF777777),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_unreadCount > 0)
                    TextButton(
                      onPressed: _markAllAsRead,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Tandai Semua Dibaca',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF850909),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Tab Filter Pill
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDEC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildFilterTab(
                        title: 'Semua',
                        count: _notifications.length,
                        isActive: _activeTab == 'all',
                        onTap: () => setState(() => _activeTab = 'all'),
                      ),
                    ),
                    Expanded(
                      child: _buildFilterTab(
                        title: 'Belum Dibaca',
                        count: _unreadCount,
                        isActive: _activeTab == 'unread',
                        isUnreadBadge: true,
                        onTap: () => setState(() => _activeTab = 'unread'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Notification List or Empty State
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      children: [
                        if (todayItems.isNotEmpty)
                          _buildGroupSection(
                            title: 'Hari Ini',
                            subtitle: 'Terbaru',
                            items: todayItems,
                          ),
                        if (yesterdayItems.isNotEmpty)
                          _buildGroupSection(
                            title: 'Kemarin',
                            subtitle: '1 Hari Lalu',
                            items: yesterdayItems,
                          ),
                        if (previousItems.isNotEmpty)
                          _buildGroupSection(
                            title: 'Sebelumnya',
                            subtitle: 'Riwayat',
                            items: previousItems,
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab({
    required String title,
    required int count,
    required bool isActive,
    bool isUnreadBadge = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? const Color(0xFF111111)
                    : const Color(0xFF777777),
              ),
            ),
            const SizedBox(width: 6),
            if (isUnreadBadge && count > 0)
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Color(0xFF850909),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            else if (count > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E2E1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSection({
    required String title,
    required String subtitle,
    required List<NotificationModel> items,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Notification Cards
          ...items.map((item) => _buildNotificationCard(item)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: item.isUnread ? const Color(0xFFFCECEC) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isUnread
              ? const Color(0xFFFFDAD5)
              : const Color(0xFFE5E5E5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _onNotificationTap(item),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      item.icon,
                      size: 20,
                      color: item.iconColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.category,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: item.isUnread
                                    ? const Color(0xFF850909)
                                    : const Color(0xFF777777),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                item.time,
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 10,
                                  color: Color(0xFF777777),
                                ),
                              ),
                              if (item.isUnread) ...[
                                const SizedBox(width: 6),
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF850909),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Title
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Description
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          color: Color(0xFF333333),
                          height: 1.35,
                        ),
                      ),

                      // Action Link (if any)
                      if (item.actionText != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              item.actionText!,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF850909),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: Color(0xFF850909),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFFCECEC),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 36,
                  color: Color(0xFF850909),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Notifikasi',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Semua kabar terbaru terkait pesanan dan anabul kamu akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                color: Color(0xFF777777),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => _activeTab = 'all'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF850909),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Tampilkan Semua Notifikasi',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

