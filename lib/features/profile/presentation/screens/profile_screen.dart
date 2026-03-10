import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/features/auth/providers/auth_provider.dart';
import 'package:merchant_app/features/ads/presentation/screens/ads_screen.dart';
import 'package:merchant_app/features/profile/presentation/screens/store_details_screen.dart';
import 'package:merchant_app/features/profile/presentation/screens/bank_account_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 3D Header Section with Cover Image and Overlapping Avatar
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.background,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1514933651103-005eec06c04b?ixlib=rb-1.2.1&auto=format&fit=crop&w=200&q=80'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60), // Spacing for overlapping avatar
          
          // Profile Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  'ร้านค้า แมส มาร์แชนท์',
                  style: AppTypography.heading3.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '123 ถนนสุขุมวิท, กรุงเทพมหานคร',
                  style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgMid),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Elevated Menu Cards (3D Effect)
                _buildElevatedMenuCard(
                  icon: Icons.store_mall_directory_outlined,
                  title: 'รายละเอียดร้านค้า',
                  subtitle: 'อัปเดตโลโก้, ภาพหน้าปก และที่อยู่',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const StoreDetailsScreen()));
                  },
                ),
                const SizedBox(height: 16),
                _buildElevatedMenuCard(
                  icon: Icons.account_balance_outlined,
                  title: 'บัญชีธนาคาร',
                  subtitle: 'จัดการการรับเงินและขอถอนเงิน',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const BankAccountScreen()));
                  },
                ),
                const SizedBox(height: 16),
                _buildElevatedMenuCard(
                  icon: Icons.campaign_outlined,
                  title: 'โปรโมทร้านค้า (Ads)',
                  subtitle: 'จัดการงบประมาณและราคาประมูลรายวัน',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AdsScreen()));
                  },
                ),
                const SizedBox(height: 48),
                
                // Logout Button
                OutlinedButton.icon(
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text('ออกจากระบบ', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElevatedMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.heading6.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: AppTypography.caption1.copyWith(color: AppColors.semanticGrayNeutralFgMid)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
