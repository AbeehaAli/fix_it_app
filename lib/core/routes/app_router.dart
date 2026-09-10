import 'package:final_project/features/auth/presentation/customer_login_screen.dart';
import 'package:final_project/features/auth/presentation/customer_signup_screen.dart';
import 'package:final_project/features/customer/presentation/pages/customer_home_screen.dart';
import 'package:final_project/features/onboarding/pages/onboarding_screen.dart';
import 'package:final_project/features/role_selection/pages/role_selection_screen.dart';
import 'package:final_project/features/splash/presentation/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';



class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',

    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: '/roleselection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),

      GoRoute(
        path: '/customer-signUp',
        builder: (context, state) => const CustomerSignupScreen(),
      ),

      GoRoute(
        path: '/customer-Login',
        builder: (context, state) => const CustomerLoginScreen(),
      ),

      GoRoute(
        path: '/customer-homepage',
        builder: (context, state) => const CustomerHome(customerName: 'Ahmed'),
      ),
    ],
  );
}