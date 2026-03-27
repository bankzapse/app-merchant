import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/features/orders/models/order.dart';
import 'package:merchant_app/features/orders/providers/order_provider.dart';
import 'package:merchant_app/features/home/providers/restaurant_provider.dart';
import 'package:merchant_app/features/home/presentation/widgets/status_bottom_sheet.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Future.microtask(() => ref.read(orderProvider.notifier).fetchOrders());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final profileAsync = ref.watch(restaurantProfileProvider);

    final statusLabel = profileAsync.maybeWhen(
      data: (p) => _statusLabel(p.status),
      orElse: () => 'ปิด',
    );
    final isOpen = profileAsync.maybeWhen(
      data: (p) => p.status == RestaurantStatus.open,
      orElse: () => false,
    );

    // Show incoming order notification
    if (orderState.hasNewOrder && orderState.newestIncomingOrder != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNewOrderSnackbar(context, ref, orderState.newestIncomingOrder!);
        ref.read(orderProvider.notifier).dismissNewOrderNotification();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          // ─── Header ─────────────────────────────────────────
          _buildHeader(context, ref, statusLabel, isOpen, profileAsync),
          // ─── Tabs ───────────────────────────────────────────
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF00B14F),
              unselectedLabelColor: const Color(0xFF888888),
              indicatorColor: const Color(0xFF00B14F),
              indicatorWeight: 2,
              labelStyle: AppTypography.label3.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTypography.label3,
              tabs: const [
                Tab(text: 'กำลังเตรียม'),
                Tab(text: 'พร้อมจัดส่ง'),
                Tab(text: 'ที่กำลังจะถึง'),
                Tab(text: 'ประวัติ'),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: orderState.isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F)))
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrderList(orderState.preparing, tab: 0),
                      _buildOrderList(orderState.ready, tab: 1),
                      _buildOrderList(orderState.delivering, tab: 2),
                      _buildOrderList(orderState.history, tab: 3),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, String statusLabel, bool isOpen,
      AsyncValue<RestaurantProfile> profileAsync) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'คำสั่งซื้อ',
            style: AppTypography.heading4.copyWith(
              color: const Color(0xFF111111),
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  final profile = profileAsync.valueOrNull;
                  if (profile == null) return;
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => StatusBottomSheet(
                      currentStatus: profile.status,
                      onStatusChanged: (s) =>
                          ref.read(restaurantProfileProvider.notifier).setStatus(s),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFCCCCCC)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isOpen ? const Color(0xFF00B14F) : const Color(0xFF888888),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        statusLabel,
                        style: AppTypography.body3.copyWith(
                          color: const Color(0xFF333333),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.more_vert, color: Color(0xFF555555)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders, {required int tab}) {
    if (orders.isEmpty) {
      return tab == 0
          ? _buildEmptyPreparingState()
          : _buildEmptyState(tab);
    }

    return RefreshIndicator(
      color: const Color(0xFF00B14F),
      onRefresh: () => ref.read(orderProvider.notifier).fetchOrders(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (_, i) => _buildOrderCard(orders[i]),
      ),
    );
  }

  Widget _buildEmptyPreparingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(
            'ยังไม่มีคำสั่งซื้อใหม่ในตอนนี้',
            style: AppTypography.body2.copyWith(color: const Color(0xFF888888)),
          ),
          const SizedBox(height: 20),
          // Tips card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ระหว่างรอคำสั่งซื้อ...',
                    style: AppTypography.heading6.copyWith(
                      color: const Color(0xFF111111),
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 12),
                _buildTipRow('🔄', 'ตรวจสอบความพร้อมจำหน่ายสินค้า', 'เพื่อป้องกันการยกเลิก'),
                const Divider(height: 16, color: Color(0xFFF0F0F0)),
                _buildTipRow('⏱️', 'เตรียมให้เสร็จก่อนหมดเวลา', 'เพื่อไม่ให้การจัดส่งคำสั่งซื้อล่าช้า'),
                const Divider(height: 16, color: Color(0xFFF0F0F0)),
                _buildTipRow('⭐', 'อ่านฟีดแบกลูกค้า', 'เพื่อนำมาปรับปรุงสินค้าและบริการให้ลูกค้าพอใจมากขึ้น'),
                const Divider(height: 16, color: Color(0xFFF0F0F0)),
                _buildTipRow('✨', 'แชทกับผู้ช่วย AI', 'เพื่อหาแนวทางพัฒนาธุรกิจ'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // KPI card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ติดตามตัวชี้วัดผลการดำเนินงาน',
                    style: AppTypography.body2.copyWith(
                      color: const Color(0xFF111111),
                      fontWeight: FontWeight.w500,
                    )),
                const Icon(Icons.chevron_right, color: Color(0xFF888888)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipRow(String emoji, String title, String subtitle) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.body2.copyWith(color: const Color(0xFF333333))),
              Text(subtitle, style: AppTypography.body3.copyWith(color: const Color(0xFF888888))),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, size: 18, color: Color(0xFF888888)),
      ],
    );
  }

  Widget _buildEmptyState(int tab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📋', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            tab == 1 ? 'ยังไม่มีออเดอร์พร้อมจัดส่ง' :
            tab == 2 ? 'ไม่มีออเดอร์กำลังจัดส่ง' : 'ยังไม่มีประวัติคำสั่งซื้อ',
            style: AppTypography.body1.copyWith(color: const Color(0xFF888888)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final isPending = order.status == 'PLACED';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isPending ? Border.all(color: const Color(0xFFFF8C00), width: 1.5) : Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // ─── Card Header ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${order.shortId}',
                  style: AppTypography.heading6.copyWith(
                    color: const Color(0xFF111111),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
          ),

          // ─── Items ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B14F),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: AppTypography.body2.copyWith(color: const Color(0xFF333333))),
                          if (item.selectedModifiers.isNotEmpty)
                            Text(
                              item.selectedModifiers.join(', '),
                              style: AppTypography.body3.copyWith(color: const Color(0xFF888888)),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '฿${item.subtotal.toStringAsFixed(0)}',
                      style: AppTypography.body2.copyWith(color: const Color(0xFF333333)),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),

          const Divider(height: 16, indent: 14, endIndent: 14, color: Color(0xFFF0F0F0)),

          // ─── Totals & Payment ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _paymentIcon(order.paymentMethod),
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'รวม ฿${order.totalAmount.toStringAsFixed(0)}',
                  style: AppTypography.heading6.copyWith(
                    color: const Color(0xFF111111),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ─── Action Buttons ────────────────────────────────
          if (_shouldShowActions(order.status))
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: _buildActionButtons(order),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final info = _statusInfo(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: info['bg'] as Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        info['label'] as String,
        style: TextStyle(
          color: info['text'] as Color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Map<String, dynamic> _statusInfo(String status) {
    switch (status) {
      case 'PLACED':
        return {'label': 'ได้รับออเดอร์', 'bg': const Color(0xFFFFF3E0), 'text': const Color(0xFFE65100)};
      case 'RESTAURANT_ACCEPTED':
        return {'label': 'รับแล้ว', 'bg': const Color(0xFFE3F2FD), 'text': const Color(0xFF1565C0)};
      case 'PREPARING':
        return {'label': 'กำลังเตรียม', 'bg': const Color(0xFFF3E5F5), 'text': const Color(0xFF6A1B9A)};
      case 'READY_FOR_PICKUP':
        return {'label': 'พร้อมส่ง', 'bg': const Color(0xFFE8F5E9), 'text': const Color(0xFF1B5E20)};
      case 'DELIVERY':
        return {'label': 'กำลังส่ง', 'bg': const Color(0xFFE0F7FA), 'text': const Color(0xFF006064)};
      case 'COMPLETED':
        return {'label': 'ส่งเรียบร้อย', 'bg': const Color(0xFFE8F5E9), 'text': const Color(0xFF2E7D32)};
      default:
        return {'label': status, 'bg': const Color(0xFFEEEEEE), 'text': const Color(0xFF555555)};
    }
  }

  bool _shouldShowActions(String status) =>
      ['PLACED', 'RESTAURANT_ACCEPTED', 'PREPARING'].contains(status);

  Widget _buildActionButtons(Order order) {
    final notifier = ref.read(orderProvider.notifier);

    if (order.status == 'PLACED') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => notifier.rejectOrder(order.id),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE74C3C),
                side: const BorderSide(color: Color(0xFFE74C3C)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text('ปฏิเสธ', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => notifier.acceptOrder(order.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B14F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text('รับออเดอร์', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      );
    } else if (order.status == 'RESTAURANT_ACCEPTED') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => notifier.markPreparing(order.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B14F),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: const Text('เริ่มเตรียมอาหาร', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      );
    } else if (order.status == 'PREPARING') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => notifier.markReady(order.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B14F),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: const Text('อาหารเสร็จแล้ว / พร้อมส่ง', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String _paymentIcon(String method) {
    switch (method) {
      case 'credit_card': return '💳 บัตรเครดิต';
      case 'grab_pay': return '💚 GrabPay';
      case 'cash': return '💵 เงินสด';
      default: return '💵 $method';
    }
  }

  String _statusLabel(RestaurantStatus s) {
    switch (s) {
      case RestaurantStatus.open: return 'เปิด';
      case RestaurantStatus.busy: return 'ยุ่ง';
      case RestaurantStatus.paused: return 'ปิด';
    }
  }

  void _showNewOrderSnackbar(BuildContext context, WidgetRef ref, Order order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF00B14F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Text('🛵', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('มีออเดอร์ใหม่เข้ามา!',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(
                    '${order.items.length} รายการ • ฿${order.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              child: const Text('ดู', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
