import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/features/auth/providers/auth_provider.dart';
import 'package:merchant_app/features/home/providers/restaurant_provider.dart';
import 'package:merchant_app/features/ads/presentation/screens/ads_screen.dart';
import 'package:merchant_app/features/profile/presentation/screens/store_details_screen.dart';
import 'package:merchant_app/features/profile/presentation/screens/bank_account_screen.dart';
import 'package:merchant_app/features/profile/presentation/screens/closing_hours_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(restaurantProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Header with cover + logo ──────────────
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  profileAsync.maybeWhen(
                    data: (p) => Container(
                      height: 180,
                      decoration: BoxDecoration(
                        image: p.coverImageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(p.coverImageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: const Color(0xFFEEEEEE),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                          ),
                        ),
                      ),
                    ),
                    orElse: () => Container(
                      height: 180,
                      color: const Color(0xFFEEEEEE),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: profileAsync.maybeWhen(
                        data: (p) => p.logoUrl != null
                            ? CircleAvatar(
                                radius: 46,
                                backgroundImage: NetworkImage(p.logoUrl!),
                              )
                            : const CircleAvatar(
                                radius: 46,
                                backgroundColor: Color(0xFFF0F0F0),
                                child: Icon(Icons.storefront, size: 40, color: Color(0xFF888888)),
                              ),
                        orElse: () => const CircleAvatar(
                          radius: 46,
                          backgroundColor: Color(0xFFF0F0F0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 64),

              // ─── Name & address ─────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    profileAsync.maybeWhen(
                      data: (p) => Column(
                        children: [
                          Text(p.name,
                              style: AppTypography.heading4.copyWith(
                                color: const Color(0xFF111111),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 4),
                          if (p.address != null)
                            Text(p.address!,
                                style: AppTypography.body3.copyWith(color: const Color(0xFF888888)),
                                textAlign: TextAlign.center),
                        ],
                      ),
                      orElse: () => const CircularProgressIndicator(color: Color(0xFF00B14F)),
                    ),
                    const SizedBox(height: 28),

                    // ─── Menu Cards ──────────────────────
                    _buildMenuCard(
                      icon: Icons.store_mall_directory_outlined,
                      title: 'ร้าน',
                      subtitle: 'จัดการข้อมูลร้าน, ภาพ และที่อยู่',
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const StoreDetailsScreen())),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuCard(
                      icon: Icons.access_time_outlined,
                      title: 'เวลาเปิด-ปิด',
                      subtitle: 'วันหยุดพิเศษและเวลาจัดส่ง',
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ClosingHoursScreen())),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuCard(
                      icon: Icons.account_balance_outlined,
                      title: 'บัญชีธนาคาร',
                      subtitle: 'จัดการการรับเงินและขอถอนเงิน',
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const BankAccountScreen())),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuCard(
                      icon: Icons.campaign_outlined,
                      title: 'โปรโมทร้านค้า (Ads)',
                      subtitle: 'จัดการงบประมาณและราคาประมูลรายวัน',
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const AdsScreen())),
                    ),
                    const SizedBox(height: 32),

                    // ─── Logout ──────────────────────────
                    OutlinedButton.icon(
                      icon: const Icon(Icons.logout, color: Color(0xFFE74C3C)),
                      label: Text('ออกจากระบบ',
                          style: AppTypography.label2.copyWith(color: const Color(0xFFE74C3C))),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE74C3C), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () => ref.read(authProvider.notifier).logout(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.semanticGrayNeutralBgLightGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF00B14F), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: AppTypography.body1.copyWith(
                            color: const Color(0xFF222222),
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: AppTypography.caption5.copyWith(color: const Color(0xFF888888))),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF888888)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
