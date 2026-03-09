import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:merchant_app/core/theme/app_theme.dart';
import 'package:merchant_app/features/auth/presentation/screens/login_screen.dart';
import 'package:merchant_app/features/auth/providers/auth_provider.dart';
import 'package:merchant_app/features/home/presentation/screens/main_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (authState.isLoading) return null; // Wait for init

      final isAuth = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuth && !isLoggingIn) return '/login';
      if (isAuth && isLoggingIn) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
    ],
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final authState = ref.watch(authProvider);

    if (authState.isLoading && !authState.isAuthenticated) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp.router(
      title: 'Mass Merchant',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
