import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/network/api_client.dart';
import 'package:merchant_app/features/orders/models/order.dart';

class OrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  OrderNotifier() : super(const AsyncValue.loading());

  Future<void> fetchPendingOrders() async {
    state = const AsyncValue.loading();
    try {
      final response = await apiClient.dio.get('/restaurant/orders/pending?status=PLACED,RESTAURANT_ACCEPTED,PREPARING');
      final orders = (response.data as List).map((json) => Order.fromJson(json)).toList();
      state = AsyncValue.data(orders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> acceptOrder(String id) async {
    try {
      await apiClient.dio.post('/restaurant/orders/$id/accept');
      // Update local state instead of re-fetching to be faster
      _updateOrderStatus(id, 'RESTAURANT_ACCEPTED');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> rejectOrder(String id) async {
    try {
      await apiClient.dio.post('/restaurant/orders/$id/reject');
      fetchPendingOrders(); // Re-fetch to remove from pending
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> markPreparing(String id) async {
    try {
      await apiClient.dio.post('/restaurant/orders/$id/preparing');
      _updateOrderStatus(id, 'PREPARING');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> markReady(String id) async {
    try {
      await apiClient.dio.post('/restaurant/orders/$id/ready');
      fetchPendingOrders(); // Re-fetch to remove from pending
      return true;
    } catch (e) {
      return false;
    }
  }

  void _updateOrderStatus(String id, String status) {
    if (state.hasValue) {
      final currentOrders = state.value!;
      final updatedOrders = currentOrders.map((o) {
        if (o.id == id) {
          return Order(id: o.id, status: status, totalAmount: o.totalAmount, placedAt: o.placedAt, items: o.items);
        }
        return o;
      }).toList();
      state = AsyncValue.data(updatedOrders);
    }
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, AsyncValue<List<Order>>>((ref) {
  return OrderNotifier();
});
