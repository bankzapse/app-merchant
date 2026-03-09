import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/features/auth/providers/auth_provider.dart';
import 'package:merchant_app/features/ads/presentation/screens/ads_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.border,
            child: Icon(Icons.store, size: 50, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 16),
          Text(
            'Mass Merchant Shop',
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '123 Main St, Bangkok',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildMenuOption(
            icon: Icons.campaign_outlined,
            title: 'Promote Restaurant (Ads)',
            subtitle: 'Manage your daily budget and bids',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdsScreen()));
            },
          ),
          const Divider(),
          _buildMenuOption(
            icon: Icons.account_balance_outlined,
            title: 'Bank Account',
            subtitle: 'Manage payouts',
            onTap: () {},
          ),
          const Divider(),
          _buildMenuOption(
            icon: Icons.store_mall_directory_outlined,
            title: 'Store Details',
            subtitle: 'Update logo, cover, and address',
            onTap: () {},
          ),
          const Divider(),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout, color: AppColors.error),
            label: const Text('Log Out', style: TextStyle(color: AppColors.error)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
            ),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTypography.titleMedium),
      subtitle: Text(subtitle, style: AppTypography.bodySmall),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
