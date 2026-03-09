import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/menu_provider.dart';
import '../../auth/providers/auth_provider.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  
  @override
  void initState() {
    super.initState();
    // Assuming we fetch the menu right away. In a real app we'd need the rest ID.
    // For this prototype, the endpoint might not need ID if the auth token resolves it,
    // but RESTAURANT_API_GUIDE.md says customer endpoint needs ID.
    // Wait, let's use a workaround to get categories for the merchant directly.
    Future.microtask(() => _fetchMerchantMenu());
  }

  Future<void> _fetchMerchantMenu() async {
    try {
      // Fetch categories. The API doc says GET /api/food/restaurant/menu/categories for the merchant
      // And we might need to fetch items separately or build a combined provider.
      // Let's rely on the menuProvider but we need to adjust it to use the merchant endpoints if we don't know the restaurant ID.
      // Or we can just build the UI first. Let's create a placeholder layout for now.
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textTertiary,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: 'Categories & Items'),
                Tab(text: 'Modifiers'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCategoriesAndItemsTab(),
                  _buildModifiersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesAndItemsTab() {
    final menuState = ref.watch(menuProvider);

    return menuState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (categories) {
        if (categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu, size: 60, color: AppColors.textTertiary),
                const SizedBox(height: 16),
                Text('No menu items yet', style: AppTypography.titleLarge),
                const SizedBox(height: 8),
                Text('Tap + to add your first category', style: AppTypography.bodySmall),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ExpansionTile(
                title: Text(category.name, style: AppTypography.titleMedium),
                subtitle: Text('${category.items.length} items', style: AppTypography.bodySmall),
                children: category.items.map((item) {
                  return ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: item.imageUrl != null 
                        ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                        : const Icon(Icons.fastfood, color: Colors.white),
                    ),
                    title: Text(item.name),
                    subtitle: Text('฿${item.price} - ${item.isAvailable ? "Available" : "Sold Out"}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        // Edit item
                      },
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

  Widget _buildModifiersTab() {
    return Center(
      child: Text('Modifier Management Coming Soon', style: AppTypography.bodyMedium),
    );
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.category, color: AppColors.primary),
                title: const Text('Add Category'),
                onTap: () {
                  Navigator.pop(context);
                  // Show Category Dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.fastfood, color: AppColors.primary),
                title: const Text('Add Menu Item'),
                onTap: () {
                  Navigator.pop(context);
                  // Show Item Dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.tune, color: AppColors.primary),
                title: const Text('Add Modifier Group'),
                onTap: () {
                  Navigator.pop(context);
                  // Show Modifier Dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
