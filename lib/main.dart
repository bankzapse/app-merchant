import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:merchant_app/core/theme/app_theme.dart';
import 'package:merchant_app/features/auth/presentation/screens/login_screen.dart';
import 'package:merchant_app/features/auth/providers/auth_provider.dart';
import 'package:merchant_app/features/home/presentation/screens/main_screen.dart';
import 'package:merchant_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:merchant_app/features/auth/presentation/screens/auth_phone_screen.dart';
import 'package:merchant_app/features/auth/presentation/screens/auth_email_password_screen.dart';
import 'package:merchant_app/features/auth/presentation/screens/auth_otp_screen.dart';
import 'package:merchant_app/features/auth/presentation/screens/auth_business_info_screen.dart';
import 'package:merchant_app/features/auth/presentation/screens/auth_business_type_screen.dart';
import 'package:merchant_app/features/auth/presentation/screens/auth_personal_info_screen.dart';
import 'package:merchant_app/features/auth/presentation/screens/auth_bank_info_screen.dart';
import 'package:merchant_app/features/auth/presentation/screens/auth_confirmation_screen.dart';void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (authState.isLoading) return null; // Wait for init

      final isAuth = authState.isAuthenticated;
      final authRoutes = [
        '/welcome',
        '/login',
        '/register/phone',
        '/register/otp',
        '/register/email_password',
        '/register/business_info',
        '/register/business_type',
        '/register/personal_info',
        '/register/bank_info',
        '/register/confirmation'
      ];
      final isAuthRoute = authRoutes.contains(state.matchedLocation);

      if (!isAuth && !isAuthRoute) return '/welcome';
      if (isAuth && isAuthRoute) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register/phone',
        builder: (context, state) => const AuthPhoneScreen(),
      ),
      GoRoute(
        path: '/register/email_password',
        builder: (context, state) => const AuthEmailPasswordScreen(),
      ),
      GoRoute(
        path: '/register/otp',
        builder: (context, state) => const AuthOtpScreen(),
      ),
      GoRoute(
        path: '/register/business_info',
        builder: (context, state) => const AuthBusinessInfoScreen(),
      ),
      GoRoute(
        path: '/register/business_type',
        builder: (context, state) => const AuthBusinessTypeScreen(),
      ),
      GoRoute(
        path: '/register/personal_info',
        builder: (context, state) => const AuthPersonalInfoScreen(),
      ),
      GoRoute(
        path: '/register/bank_info',
        builder: (context, state) => const AuthBankInfoScreen(),
      ),
      GoRoute(
        path: '/register/confirmation',
        builder: (context, state) => const AuthConfirmationScreen(),
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
