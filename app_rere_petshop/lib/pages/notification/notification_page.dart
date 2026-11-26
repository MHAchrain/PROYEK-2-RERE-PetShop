import 'package:flutter/material.dart';
import 'package:app_rere_petshop/models/notification_model.dart';
import 'package:app_rere_petshop/services/notification_service.dart';
import 'package:app_rere_petshop/pages/order/order_detail_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String _activeTab = 'all'; // 'all' or 'unread'
  bool _isLoading = true;
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final list = await NotificationService.instance.getNotifications();
    if (!mounted) return;
    setState(() {
      _notifications = list;
      _isLoading = false;
    });
  }

  int get _unreadCount => _notifications.where((n) => n.isUnread).length;

  List<NotificationModel> get _filteredNotifications {
    if (_activeTab == 'unread') {
      return _notifications.where((n) => n.isUnread).toList();
    }
    return _notifications;
  }

  Future<void> _markAllAsRead() async {
    await NotificationService.instance.markAllAsRead();
    if (!mounted) return;
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

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Notifikasi'),
        content: const Text(
            'Apakah kamu yakin ingin menghapus semua notifikasi untuk akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF850909),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await NotificationService.instance.clearAll();
      if (!mounted) return;
      setState(() {
        _notifications.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Semua notifikasi akun ini berhasil dihapus'),
          backgroundColor: const Color(0xFF313030),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _onNotificationTap(NotificationModel item) async {
    if (item.isUnread) {
      await NotificationService.instance.markAsRead(item.id);
      if (!mounted) return;
      setState(() {
        item.isUnread = false;
      });
    }

    if (!mounted) return;
    if (item.orderId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderDetailPage(orderId: item.orderId!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(item.title),
          backgroundColor: const Color(0xFF313030),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          duration: const Duration(seconds: 1),
        ),
      );
    }
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
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111111),
          ),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Color(0xFF111111)),
              onSelected: (value) {
                if (value == 'read_all') {
                  _markAllAsRead();
                } else if (value == 'clear_all') {
                  _clearAll();
                }
              },
              itemBuilder: (context) => [
                if (_unreadCount > 0)
                  const PopupMenuItem(
                    value: 'read_all',
                    child: Row(
                      children: [
                        Icon(Icons.done_all, size: 18, color: Color(0xFF333333)),
                        SizedBox(width: 8),
                        Text('Tandai Semua Dibaca'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline,
                          size: 18, color: Color(0xFF850909)),
                      SizedBox(width: 8),
                      Text('Hapus Semua',
                          style: TextStyle(color: Color(0xFF850909))),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF850909)),
              ),
            )
          : RefreshIndicator(
              color: const Color(0xFF850909),
              onRefresh: _loadNotifications,
              child: Column(
                children: [
                  // Header Bar Status
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Aktivitas Akun Kamu',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111111),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _unreadCount > 0
                                    ? const Color(0xFFFCECEC)
                                    : const Color(0xFFF0EDEC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _unreadCount > 0
                                    ? '$_unreadCount Baru'
                                    : 'Sudah Dibaca',
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
                              'Tandai Dibaca',
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                              onTap: () =>
                                  setState(() => _activeTab = 'unread'),
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
                            physics: const AlwaysScrollableScrollPhysics(),
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
                    color: Colors.black.withValues(alpha: 0.04),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
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
            color: Colors.black.withValues(alpha: 0.02),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          color: Color(0xFF333333),
                          height: 1.35,
                        ),
                      ),
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
    final isUnreadFilterWithItems =
        _activeTab == 'unread' && _notifications.isNotEmpty;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
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
              child: Center(
                child: Icon(
                  isUnreadFilterWithItems
                      ? Icons.mark_email_read_outlined
                      : Icons.notifications_none_rounded,
                  size: 36,
                  color: const Color(0xFF850909),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isUnreadFilterWithItems
                  ? 'Tidak Ada Notifikasi Baru'
                  : 'Belum Ada Notifikasi',
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isUnreadFilterWithItems
                  ? 'Semua notifikasi kamu telah dibaca. Periksa tab Semua untuk melihat riwayat lengkap.'
                  : 'Notifikasi terkait pesanan, booking, dan transaksi akun kamu akan muncul di sini.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                color: Color(0xFF777777),
                height: 1.4,
              ),
            ),
            if (isUnreadFilterWithItems) ...[
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
          ],
        ),
      ),
    );
  }
}
