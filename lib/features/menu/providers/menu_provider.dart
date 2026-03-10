import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/network/api_client.dart';
import 'package:merchant_app/features/menu/models/menu.dart';
import 'package:merchant_app/features/home/providers/restaurant_provider.dart';

class MenuNotifier extends StateNotifier<AsyncValue<List<MenuCategory>>> {
  MenuNotifier() : super(const AsyncValue.loading());

  Future<void> fetchMenu(String restaurantId) async {
    state = const AsyncValue.loading();
    try {
      final response = await apiClient.dio.get('/customer/restaurants/$restaurantId/menu');
      final categories = (response.data['categories'] as List).map((json) => MenuCategory.fromJson(json)).toList();
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addCategory(String name) async {
    try {
      final response = await apiClient.dio.post('/restaurant/menu/categories', data: {
        'name': name,
        'sort_order': state.value?.length ?? 0 + 1,
      });
      if (response.statusCode == 201) {
        final newCategory = MenuCategory.fromJson(response.data);
        final currentCategories = state.value ?? [];
        state = AsyncValue.data([...currentCategories, newCategory]);
      }
    } catch (e) {
      throw Exception('ไม่สามารถเพิ่มหมวดหมู่ได้');
    }
  }

  Future<void> addItem({required String categoryId, required String name, required String description, required double price}) async {
    try {
      final response = await apiClient.dio.post('/restaurant/menu/items', data: {
        'category_id': categoryId,
        'name': name,
        'description': description,
        'price': price,
      });
      if (response.statusCode == 201) {
        final newItem = MenuItem.fromJson(response.data);
        final currentCategories = state.value ?? [];
        final updatedCategories = currentCategories.map((cat) {
          if (cat.id == categoryId) {
            return MenuCategory(
              id: cat.id,
              name: cat.name,
              sortOrder: cat.sortOrder,
              isActive: cat.isActive,
              items: [...cat.items, newItem],
            );
          }
          return cat;
        }).toList();
        state = AsyncValue.data(updatedCategories);
      }
    } catch (e) {
      throw Exception('ไม่สามารถเพิ่มเมนูได้');
    }
  }

  Future<bool> createCategory(String name, int sortOrder) async {

  Future<bool> updateCategory(String id, String name, int sortOrder, bool isActive) async {
    try {
      await apiClient.dio.put('/restaurant/menu/categories/$id', data: {
        'name': name,
        'sort_order': sortOrder,
        'is_active': isActive,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      await apiClient.dio.delete('/restaurant/menu/categories/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createMenuItem(String categoryId, String name, String desc, double price, String? imageUrl) async {
    try {
      await apiClient.dio.post('/restaurant/menu/items', data: {
        'category_id': categoryId,
        'name': name,
        'description': desc,
        'price': price,
        if (imageUrl != null) 'image_url': imageUrl,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateMenuItem(String id, String categoryId, String name, String desc, double price, bool isAvailable, String? imageUrl) async {
    try {
      await apiClient.dio.put('/restaurant/menu/items/$id', data: {
        'category_id': categoryId,
        'name': name,
        'description': desc,
        'price': price,
        'is_available': isAvailable,
        if (imageUrl != null) 'image_url': imageUrl,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMenuItem(String id) async {
    try {
      await apiClient.dio.delete('/restaurant/menu/items/$id');
      return true;
    } catch (e) {
      return false;
    }
  }
}

// Global Provider
final menuProvider = StateNotifierProvider<MenuNotifier, AsyncValue<List<MenuCategory>>>((ref) {
  return MenuNotifier();
});
