import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import 'package:dio/dio.dart';

// State
class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({this.isLoading = false, this.error, this.isAuthenticated = false});

  AuthState copyWith({bool? isLoading, String? error, bool? isAuthenticated}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    // Check if token exists
    try {
      final token = await ApiClient().dio.options.headers['Authorization'];
      if (token != null) {
        state = state.copyWith(isLoading: false, isAuthenticated: true);
      } else {
        state = state.copyWith(isLoading: false, isAuthenticated: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, isAuthenticated: false);
    }
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiClient.dio.post('/auth/login', data: {
        'username': username,
        'password': password,
        'role': 'restaurant',
      });

      if (response.statusCode == 200 && response.data['token'] != null) {
        final token = response.data['token'];
        await ApiClient.saveToken(token);
        apiClient.dio.options.headers['Authorization'] = 'Bearer $token'; // Update current instance
        state = state.copyWith(isLoading: false, isAuthenticated: true);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Login failed');
        return false;
      }
    } on DioException catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: e.response?.data['message'] ?? 'Connection error');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await ApiClient.clearToken();
    apiClient.dio.options.headers.remove('Authorization');
    state = state.copyWith(isAuthenticated: false);
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
