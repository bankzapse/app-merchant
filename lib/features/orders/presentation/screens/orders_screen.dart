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
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(child: Text('No pending orders'));
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
                        Text('Order #${order.id.substring(0, 8)}', style: AppTypography.titleMedium),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            order.status,
                            style: AppTypography.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Total: ฿${order.totalAmount}', style: AppTypography.titleLarge.copyWith(color: AppColors.primary)),
                    const Divider(),
                    ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.quantity}x ${item.name}'),
                              Text('฿${item.subtotal}'),
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

  Widget _buildActionButtons(String id, String status) {
    final notifier = ref.read(orderProvider.notifier);
    
    if (status == 'PLACED') {
      return Row(
        children: [
          Expanded(child: OutlinedButton(onPressed: () => notifier.rejectOrder(id), child: const Text('Reject'))),
          const SizedBox(width: 16),
          Expanded(child: ElevatedButton(onPressed: () => notifier.acceptOrder(id), child: const Text('Accept'))),
        ],
      );
    } else if (status == 'RESTAURANT_ACCEPTED') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: () => notifier.markPreparing(id), child: const Text('Start Preparing')),
      );
    } else if (status == 'PREPARING') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: () => notifier.markReady(id), child: const Text('Ready for Pickup')),
      );
    }
    return const SizedBox.shrink();
  }
}
