import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/features/home/providers/navigation_provider.dart';
import 'package:merchant_app/features/home/providers/restaurant_provider.dart';
import 'package:merchant_app/features/home/presentation/widgets/status_bottom_sheet.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(restaurantProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
          data: (profile) => RefreshIndicator(
            color: const Color(0xFF00B14F),
            onRefresh: () => ref.read(restaurantProfileProvider.notifier).fetchProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Header ─────────────────────────────────────
                  _buildHeader(context, profile),
                  const SizedBox(height: 16),

                  // ─── Performance Section ─────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ประสิทธิภาพการขาย',
                          style: AppTypography.heading5.copyWith(
                            color: const Color(0xFF111111),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildStatusCards(context, ref, profile),
                        const SizedBox(height: 20),

                        // ─── Personalized Section ──────────────────
                        _buildPersonalizedSection(),
                        const SizedBox(height: 20),

                        // ─── Quick Access Grid ─────────────────────
                        _buildQuickAccessGrid(context, ref),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── HEADER ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, RestaurantProfile profile) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF333333)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '${profile.name}${profile.branch.isNotEmpty ? ' ${profile.branch}' : ''}',
              style: AppTypography.body2.copyWith(
                color: const Color(0xFF111111),
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Stack(
            children: [
              const Icon(Icons.notifications_outlined, size: 26, color: Color(0xFF333333)),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE74C3C),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '9',
                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── STATUS CARDS ────────────────────────────────────────────────────────────

  Widget _buildStatusCards(
    BuildContext context,
    WidgetRef ref,
    RestaurantProfile profile,
  ) {
    final isOpen = profile.status == RestaurantStatus.open;
    final statusColor = _statusColor(profile.status);
    final statusLabel = _statusLabel(profile.status);

    return Row(
      children: [
        // Status card (left)
        Expanded(
          child: GestureDetector(
            onTap: () => _showStatusSheet(context, ref, profile),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isOpen ? const Color(0xFF00B14F) : _statusBgColor(profile.status),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${profile.preparingCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'กำลังเตรียม',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Revenue card (right)
        Expanded(
          child: GestureDetector(
            onTap: () => ref.read(navigationProvider.notifier).state = 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.show_chart, size: 20, color: Color(0xFF888888)),
                      const SizedBox(width: 6),
                      Text(
                        'รายได้วันนี้',
                        style: AppTypography.body3.copyWith(color: const Color(0xFF555555)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '฿',
                    style: TextStyle(color: Color(0xFF888888), fontSize: 14),
                  ),
                  Text(
                    profile.todayRevenue.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${profile.todayOrders} คำสั่งซื้อ',
                    style: AppTypography.body3.copyWith(color: const Color(0xFF888888)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _statusColor(RestaurantStatus s) {
    switch (s) {
      case RestaurantStatus.open:
        return Colors.white;
      case RestaurantStatus.busy:
        return const Color(0xFFFFA500);
      case RestaurantStatus.paused:
        return const Color(0xFFFF6B6B);
    }
  }

  Color _statusBgColor(RestaurantStatus s) {
    switch (s) {
      case RestaurantStatus.open:
        return const Color(0xFF00B14F);
      case RestaurantStatus.busy:
        return const Color(0xFFD4870A);
      case RestaurantStatus.paused:
        return const Color(0xFFB71C1C);
    }
  }

  String _statusLabel(RestaurantStatus s) {
    switch (s) {
      case RestaurantStatus.open:
        return 'เปิดให้บริการ';
      case RestaurantStatus.busy:
        return 'ยุ่ง';
      case RestaurantStatus.paused:
        return 'หยุดชั่วคราว';
    }
  }

  // ─── PERSONALIZED SECTION ────────────────────────────────────────────────────

  Widget _buildPersonalizedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'สำหรับคุณโดยเฉพาะ',
              style: AppTypography.heading6.copyWith(
                color: const Color(0xFF111111),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '2/2',
              style: AppTypography.body3.copyWith(color: const Color(0xFF888888)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: PageView(
            children: [
              _buildPromoCard(
                icon: '🛵',
                title: 'เพิ่มยอดคำสั่งซื้อได้ 21% เพียงให้ส่วนลดค่าส่ง',
                actionText: 'ดูข้อมูลเพิ่มเติม!',
                color: const Color(0xFFFFF8F0),
              ),
              _buildPromoCard(
                icon: '🏆',
                title: 'ร้านดีการันตีคุณภาพ – ทำตามเป้าหมายทั้งหมดภายในสิ้นเดือนนี้',
                actionText: 'ดูรายละเอียด >',
                color: const Color(0xFFF0F8FF),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard({
    required String icon,
    required String title,
    required String actionText,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: AppTypography.body3.copyWith(color: const Color(0xFF333333))),
                const SizedBox(height: 4),
                Text(
                  actionText,
                  style: AppTypography.label3.copyWith(color: const Color(0xFF0066CC)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── QUICK ACCESS GRID ────────────────────────────────────────────────────────

  Widget _buildQuickAccessGrid(BuildContext context, WidgetRef ref) {
    final items = [
      _QuickItem('คำสั่งซื้อ', Icons.receipt_long_outlined, null, () => ref.read(navigationProvider.notifier).state = 1),
      _QuickItem('เมนู', Icons.menu_book_outlined, null, () => ref.read(navigationProvider.notifier).state = 2),
      _QuickItem('ผู้ช่วย AI', Icons.auto_awesome, 'ใหม่', () {}),
      _QuickItem('ร้านดีการันตีคุณภาพ', Icons.verified_outlined, null, () {}),
      _QuickItem('ฟีดแบก', Icons.rate_review_outlined, null, () {}),
      _QuickItem('ร้าน', Icons.store_outlined, null, () {}),
      _QuickItem('เพิ่มยอดขาย', Icons.campaign_outlined, 'New', () {}),
      _QuickItem('ข้อมูลเชิงลึก', Icons.timeline, 'ใหม่', () {}),
      _QuickItem('พนักงาน', Icons.people_outline, null, () {}),
      _QuickItem('Academy', Icons.school_outlined, null, () {}),
      _QuickItem('แกร็บช้อป', Icons.shopping_cart_outlined, null, () {}),
      _QuickItem('Smart Link', Icons.link, 'New', () {}),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => _buildGridItem(items[i]),
    );
  }

  Widget _buildGridItem(_QuickItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(item.icon, size: 22, color: const Color(0xFF333333)),
              ),
              if (item.badge != null)
                Positioned(
                  top: -6,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: item.badge == 'New'
                          ? const Color(0xFFE74C3C)
                          : const Color(0xFFFF6B00),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: AppTypography.caption5.copyWith(color: const Color(0xFF444444)),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showStatusSheet(BuildContext context, WidgetRef ref, RestaurantProfile profile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => StatusBottomSheet(
        currentStatus: profile.status,
        onStatusChanged: (s) => ref.read(restaurantProfileProvider.notifier).setStatus(s),
      ),
    );
  }
}

class _QuickItem {
  final String label;
  final IconData icon;
  final String? badge;
  final VoidCallback onTap;

  _QuickItem(this.label, this.icon, this.badge, this.onTap);
}
