import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/features/home/providers/restaurant_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(restaurantProfileProvider);

    return profileState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $error')),
      data: (profile) {
        return RefreshIndicator(
          onRefresh: () => ref.read(restaurantProfileProvider.notifier).fetchProfile(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(context, ref, profile),
                const SizedBox(height: 16),
                _buildSummaryCards(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusCard(BuildContext context, WidgetRef ref, profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('สถานะร้านค้า', style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                Switch(
                  value: profile.isOpen,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    ref.read(restaurantProfileProvider.notifier).toggleOpenStatus(val);
                  },
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('โหมดไม่ว่าง', style: AppTypography.heading6.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                    Text('หยุดรับออเดอร์ชั่วคราว', style: AppTypography.body3.copyWith(color: AppColors.semanticGrayNeutralFgMid)),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    _showBusyModeDialog(context, ref);
                  },
                  child: const Text('ตั้งค่า'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('ออเดอร์วันนี้', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                  const SizedBox(height: 8),
                  Text('12', style: AppTypography.heading4.copyWith(color: AppColors.primary)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('รายได้', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                  const SizedBox(height: 8),
                  Text('฿ 4,500', style: AppTypography.heading4.copyWith(color: AppColors.primary)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showBusyModeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ตั้งค่าโหมดไม่ว่าง'),
        content: const Text('ต้องการตั้งค่าร้านค้าเป็นไม่ว่างเป็นเวลา 30 นาทีหรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () {
              ref.read(restaurantProfileProvider.notifier).toggleBusyMode(true, durationMin: 30);
              Navigator.pop(ctx);
            },
            child: const Text('ยืนยัน'),
          )
        ],
      ),
    );
  }
}
