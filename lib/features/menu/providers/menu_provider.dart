import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../models/menu.dart';
import '../../home/providers/restaurant_provider.dart';

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

  Future<bool> createCategory(String name, int sortOrder) async {
    try {
      await apiClient.dio.post('/restaurant/menu/categories', data: {
        'name': name,
        'sort_order': sortOrder,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

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
