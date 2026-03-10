import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/features/orders/providers/order_provider.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(orderProvider.notifier).fetchPendingOrders());
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(orderProvider);

    return ordersState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(child: Text('ไม่มีออเดอร์ที่รออยู่'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ออเดอร์ #${order.id.substring(0, 8)}', style: AppTypography.heading6.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getStatusText(order.status),
                            style: AppTypography.body3.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('ยอดรวม: ฿${order.totalAmount}', style: AppTypography.heading5.copyWith(color: AppColors.primary)),
                    const Divider(),
                    ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${item.quantity}x ${item.name}', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                                  Text('฿${item.subtotal}', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                                ],
                              ),
                              if (item.modifiers != null && item.modifiers!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, top: 2),
                                  child: Text(
                                    '+ ${(item.modifiers! as List).join(", ")}',
                                    style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMid),
                                  ),
                                ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 16),
                    _buildActionButtons(order.id, order.status),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PLACED':
        return AppColors.warning;
      case 'RESTAURANT_ACCEPTED':
      case 'PREPARING':
        return AppColors.info;
      case 'READY_FOR_PICKUP':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'PLACED':
        return 'ได้รับออเดอร์';
      case 'RESTAURANT_ACCEPTED':
        return 'ยืนยันออเดอร์แล้ว';
      case 'PREPARING':
        return 'กำลังเตรียมอาหาร';
      case 'READY_FOR_PICKUP':
        return 'พร้อมส่ง';
      default:
        return status;
    }
  }

  Widget _buildActionButtons(String id, String status) {
    final notifier = ref.read(orderProvider.notifier);
    
    if (status == 'PLACED') {
      return Row(
        children: [
          Expanded(child: OutlinedButton(onPressed: () => notifier.rejectOrder(id), child: const Text('ปฏิเสธ'))),
          const SizedBox(width: 16),
          Expanded(child: ElevatedButton(onPressed: () => notifier.acceptOrder(id), child: const Text('รับออเดอร์'))),
        ],
      );
    } else if (status == 'RESTAURANT_ACCEPTED') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: () => notifier.markPreparing(id), child: const Text('เริ่มเตรียมอาหาร')),
      );
    } else if (status == 'PREPARING') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: () => notifier.markReady(id), child: const Text('เตรียมเสร็จสิ้น')),
      );
    }
    return const SizedBox.shrink();
  }
}
