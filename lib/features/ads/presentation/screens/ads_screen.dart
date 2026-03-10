import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/features/ads/providers/ad_provider.dart';

class AdsScreen extends ConsumerStatefulWidget {
  const AdsScreen({super.key});

  @override
  ConsumerState<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends ConsumerState<AdsScreen> {
  final _budgetController = TextEditingController();
  final _bidController = TextEditingController();
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    final adState = ref.watch(adProvider);

    return Scaffold(
      appBar: AppBar(title: Text('การโฆษณา', style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh))),
      body: adState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
        data: (ad) {
          if (ad != null && _budgetController.text.isEmpty) {
            _budgetController.text = ad.dailyBudget.toString();
            _bidController.text = ad.bidPerClick.toString();
            _isActive = ad.isActive;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (ad != null) _buildStatsCard(ad),
                const SizedBox(height: 24),
                Text('การตั้งค่าแคมเปญ', style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _budgetController,
                  decoration: const InputDecoration(labelText: 'งบประมาณรายวัน (บาท)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bidController,
                  decoration: const InputDecoration(labelText: 'ราคาประมูลต่อคลิก (บาท)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                if (ad != null)
                  SwitchListTile(
                    title: Text('เปิดใช้งานแคมเปญ', style: AppTypography.body1.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                    value: _isActive,
                    onChanged: (val) {
                      setState(() => _isActive = val);
                    },
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    final budget = double.tryParse(_budgetController.text) ?? 0;
                    final bid = double.tryParse(_bidController.text) ?? 0;

                    if (ad == null) {
                      ref.read(adProvider.notifier).createAd(budget, bid);
                    } else {
                      ref.read(adProvider.notifier).updateAd(budget, bid, _isActive);
                    }
                  },
                  child: Text(ad == null ? 'สร้างแคมเปญ' : 'บันทึกการเปลี่ยนแปลง', style: AppTypography.label2),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(ad) {
    return Card(
      color: AppColors.primaryLight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('ค่าโฆษณาวันนี้', style: AppTypography.body3.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
            Text('฿${ad.currentSpend}', style: AppTypography.heading4.copyWith(color: AppColors.primary)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: ad.dailyBudget > 0 ? (ad.currentSpend / ad.dailyBudget).clamp(0.0, 1.0) : 0,
              backgroundColor: Colors.white,
              color: AppColors.primary,
            ),
            const SizedBox(height: 4),
            Text('฿${ad.currentSpend} / ฿${ad.dailyBudget} (งบประมาณ)', style: AppTypography.body3.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite)),
          ],
        ),
      ),
    );
  }
}
