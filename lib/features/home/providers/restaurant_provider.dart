import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/network/api_client.dart';
import 'package:dio/dio.dart';

class RestaurantProfile {
  final String name;
  final bool isOpen;
  
  RestaurantProfile({required this.name, required this.isOpen});

  factory RestaurantProfile.fromJson(Map<String, dynamic> json) {
    return RestaurantProfile(
      name: json['restaurant_name'] ?? 'Unknown',
      isOpen: json['is_open'] ?? false,
    );
  }
}

class RestaurantProfileNotifier extends StateNotifier<AsyncValue<RestaurantProfile>> {
  RestaurantProfileNotifier() : super(const AsyncValue.loading()) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await apiClient.dio.get('/restaurant/profile');
      state = AsyncValue.data(RestaurantProfile.fromJson(response.data));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleOpenStatus(bool isOpen) async {
    try {
      await apiClient.dio.post('/restaurant/open', data: {'is_open': isOpen});
      if (state.hasValue) {
        state = AsyncValue.data(RestaurantProfile(name: state.value!.name, isOpen: isOpen));
      }
    } catch (e) {
      print('Error toggling open status: $e');
    }
  }

  Future<void> toggleBusyMode(bool isBusy, {int? durationMin}) async {
    try {
      await apiClient.dio.post('/restaurant/busy', data: {
        'is_busy': isBusy,
        if (durationMin != null) 'duration_min': durationMin
      });
      // Busy mode might not reflect directly in `isOpen`, wait for new API response or trust local state
    } catch (e) {
      print('Error toggling busy mode: $e');
    }
  }
}

final restaurantProfileProvider = StateNotifierProvider<RestaurantProfileNotifier, AsyncValue<RestaurantProfile>>((ref) {
  return RestaurantProfileNotifier();
});
