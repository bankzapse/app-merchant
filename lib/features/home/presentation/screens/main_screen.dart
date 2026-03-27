import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/core/services/socket_service.dart';
import 'package:merchant_app/features/home/presentation/screens/dashboard_screen.dart';
import 'package:merchant_app/features/orders/presentation/screens/orders_screen.dart';
import 'package:merchant_app/features/menu/presentation/screens/menu_screen.dart';
import 'package:merchant_app/features/finance/presentation/screens/finance_screen.dart';
import 'package:merchant_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:merchant_app/features/home/providers/navigation_provider.dart';
import 'package:merchant_app/features/home/providers/restaurant_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final List<Widget> _pages = const [
    DashboardScreen(),
    OrdersScreen(),
    MenuScreen(),
    FinanceScreen(),
    ProfileScreen(),
  ];



  @override
  void initState() {
    super.initState();
    // Connect socket service on startup
    socketService.connect(mockMode: true);
  }

  @override
  void dispose() {
    socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationProvider);
    final profileAsync = ref.watch(restaurantProfileProvider);

    final isPaused = profileAsync.maybeWhen(
      data: (p) => p.status == RestaurantStatus.paused,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(currentIndex),
      // Show page titles in app bar only for some pages
      appBar: _buildAppBar(currentIndex, ref),
    );
  }

  PreferredSizeWidget? _buildAppBar(int index, WidgetRef ref) {
    // Dashboard and Profile have their own header portions; for others use a simple AppBar
    if (index == 0 || index == 4) return null;

    final titles = ['หน้าแรก', 'คำสั่งซื้อ', 'เมนู', 'การเงิน', 'เพิ่มเติม'];

    return AppBar(
      title: Text(
        titles[index],
        style: AppTypography.heading5.copyWith(
          color: AppColors.semanticGrayNeutralFgHigh,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFEEEEEE)),
      ),
    );
  }

  Widget _buildPausedBanner(String? pausedUntil) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFEDEB),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.storefront, color: Color(0xFFCC0000), size: 20),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              ref.read(restaurantProfileProvider.notifier).setStatus(RestaurantStatus.open);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
            child: Text(
              'รับคำสั่งซื้อต่อ',
              style: AppTypography.label3.copyWith(
                color: const Color(0xFF0080FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(int currentIndex) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(navigationProvider.notifier).state = index,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF00B14F),
        unselectedItemColor: const Color(0xFF888888),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedLabelStyle: AppTypography.caption5
            .copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTypography.caption5,
        items: [
          BottomNavigationBarItem(
            icon: _navIcon('🏠', false, currentIndex == 0),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: _navIcon('🍽️', false, currentIndex == 1),
            label: 'คำสั่งซื้อ',
          ),
          BottomNavigationBarItem(
            icon: _navIcon('📋', false, currentIndex == 2),
            label: 'เมนู',
          ),
          BottomNavigationBarItem(
            icon: _navIcon('💰', false, currentIndex == 3),
            label: 'การเงิน',
          ),
          BottomNavigationBarItem(
            icon: _navIcon('⋯', false, currentIndex == 4),
            label: 'เพิ่มเติม',
          ),
        ],
      ),
    );
  }

  Widget _navIcon(String emoji, bool badge, bool selected) {
    final icons = {
      '🏠': selected ? Icons.home : Icons.home_outlined,
      '🍽️': selected ? Icons.receipt : Icons.receipt_outlined,
      '📋': selected ? Icons.restaurant_menu : Icons.restaurant_menu_outlined,
      '💰': selected ? Icons.account_balance_wallet : Icons.account_balance_wallet_outlined,
      '⋯': selected ? Icons.grid_view : Icons.grid_view_outlined,
    };
    return Icon(icons[emoji] ?? Icons.circle, size: 24);
  }

}
