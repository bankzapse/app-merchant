import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/features/menu/providers/menu_provider.dart';
import 'package:merchant_app/features/menu/presentation/widgets/add_category_dialog.dart';
import 'package:merchant_app/features/menu/presentation/widgets/add_menu_item_dialog.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          // ─── Tabs ─────────────────────────────────────────
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
                Tab(text: 'เมนู'),
                Tab(text: 'ตัวเลือกเสริม'),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMenuTab(),
                _buildModifiersTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  // ─── MENU TAB ───────────────────────────────────────────────────────────────

  Widget _buildMenuTab() {
    final menuState = ref.watch(menuProvider);
    return menuState.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F))),
      error: (e, _) => Center(
        child: Text('เกิดข้อผิดพลาด: $e',
            style: AppTypography.body1.copyWith(color: AppColors.semanticErrorFgHigh)),
      ),
      data: (categories) {
        if (categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.restaurant_menu, size: 60, color: Color(0xFFCCCCCC)),
                const SizedBox(height: 16),
                Text('ยังไม่มีรายการเมนู',
                    style: AppTypography.heading5.copyWith(color: const Color(0xFF555555))),
                const SizedBox(height: 8),
                Text('กด + เพื่อเพิ่มหมวดหมู่แรก',
                    style: AppTypography.body3.copyWith(color: const Color(0xFF888888))),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                iconColor: const Color(0xFF555555),
                collapsedIconColor: const Color(0xFF888888),
                title: Text(cat.name,
                    style: AppTypography.body1.copyWith(
                      color: const Color(0xFF111111),
                      fontWeight: FontWeight.bold,
                    )),
                subtitle: Text('${cat.items.length} รายการ',
                    style: AppTypography.body3.copyWith(color: const Color(0xFF888888))),
                children: cat.items.map((item) {
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item.imageUrl != null
                          ? Image.network(
                              item.imageUrl!,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _imagePlaceholder(),
                            )
                          : _imagePlaceholder(),
                    ),
                    title: Text(item.name,
                        style: AppTypography.body2.copyWith(color: const Color(0xFF222222))),
                    subtitle: Row(
                      children: [
                        Text(
                          '฿${item.price.toStringAsFixed(0)}',
                          style: AppTypography.body3.copyWith(
                            color: const Color(0xFF00B14F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.isAvailable
                                ? const Color(0xFFE8F5E9)
                                : const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.isAvailable ? 'พร้อมขาย' : 'สินค้าหมด',
                            style: TextStyle(
                              color: item.isAvailable
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFC62828),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF888888)),
                      onPressed: () {},
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.fastfood, color: Color(0xFFCCCCCC), size: 24),
    );
  }

  // ─── MODIFIER GROUPS TAB ──────────────────────────────────────────────────

  Widget _buildModifiersTab() {
    final groupsAsync = ref.watch(modifierGroupProvider);
    return groupsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F))),
      error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
      data: (groups) {
        if (groups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.tune, size: 60, color: Color(0xFFCCCCCC)),
                const SizedBox(height: 16),
                Text('ยังไม่มีตัวเลือกเสริม',
                    style: AppTypography.heading5.copyWith(color: const Color(0xFF555555))),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: groups.length,
          itemBuilder: (_, i) => _buildModifierGroupTile(groups[i]),
        );
      },
    );
  }

  Widget _buildModifierGroupTile(ModifierGroup group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: const Color(0xFF555555),
        collapsedIconColor: const Color(0xFF888888),
        title: Text(group.name,
            style: AppTypography.body1.copyWith(
              color: const Color(0xFF111111),
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text(
          'ใช้กับ ${group.itemCount} รายการ',
          style: AppTypography.body3.copyWith(color: const Color(0xFF888888)),
        ),
        children: [
          ...group.modifiers.map((mod) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00B14F),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(mod.name,
                            style: AppTypography.body2.copyWith(
                                color: const Color(0xFF333333))),
                      ],
                    ),
                    Text(
                      mod.price > 0 ? '+฿${mod.price.toStringAsFixed(0)}' : 'ฟรี',
                      style: AppTypography.body3.copyWith(
                        color: mod.price > 0
                            ? const Color(0xFF00B14F)
                            : const Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─── FAB ────────────────────────────────────────────────────────────────────

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFF00B14F),
      onPressed: () => _showAddMenu(context),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.category_outlined, color: Color(0xFF00B14F)),
                title: Text('เพิ่มหมวดหมู่',
                    style: AppTypography.body1.copyWith(color: const Color(0xFF222222))),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(context: context,
                      builder: (_) => const AddCategoryDialog());
                },
              ),
              ListTile(
                leading: const Icon(Icons.fastfood_outlined, color: Color(0xFF00B14F)),
                title: Text('เพิ่มรายการเมนู',
                    style: AppTypography.body1.copyWith(color: const Color(0xFF222222))),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(context: context,
                      builder: (_) => const AddMenuItemDialog());
                },
              ),
              ListTile(
                leading: const Icon(Icons.tune, color: Color(0xFF00B14F)),
                title: Text('เพิ่มกลุ่มตัวเลือกเสริม',
                    style: AppTypography.body1.copyWith(color: const Color(0xFF222222))),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
