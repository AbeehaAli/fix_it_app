import 'package:final_project/features/auth/presentation/customer_login_screen.dart';
import 'package:final_project/features/auth/presentation/customer_signup_screen.dart';
import 'package:final_project/features/customer/presentation/pages/customer_home_screen.dart';
import 'package:final_project/features/onboarding/pages/onboarding_screen.dart';
import 'package:final_project/features/role_selection/pages/role_selection_screen.dart';
import 'package:final_project/features/splash/presentation/pages/splash_screen.dart';
import 'package:final_project/features/technician/presentation/pages/technician_earnings_screen.dart';
import 'package:final_project/features/technician/presentation/pages/technician_home_screen.dart';
import 'package:final_project/features/technician/presentation/pages/technician_job_in_progess_screen.dart';
import 'package:final_project/features/technician/presentation/pages/technician_job_request_detail_screen.dart';
import 'package:final_project/features/technician/presentation/pages/technician_jobs_screen.dart';
import 'package:final_project/features/technician/presentation/pages/technician_login_screen.dart';
import 'package:final_project/features/technician/presentation/pages/technician_profile_screen.dart';
import 'package:final_project/features/technician/presentation/pages/technician_signUp_screen.dart';
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
      

      GoRoute(
        path: '/technician_signUp',
        builder: (context, state) => const TechnicianSignUpScreen(),
      ),
     
     GoRoute(
        path: '/technician_Login',
        builder: (context, state) => const TechnicianLoginScreen(),
      ),

       GoRoute(
        path: '/technician_homepage',
        builder: (context, state) => const TechnicianHomeScreen(),
      ),

       

       GoRoute(
        path: '/technician_job_Screen',
        builder: (context, state) => const TechnicianJobsScreen()
        ),
      
       GoRoute(
        path: '/technician_job_request_detail_screen',
        builder: (context, state) => const TechnicianJobRequestDetailsScreen(),
        ),
      
       GoRoute(
        path: '/technician_job__in_progress_screen',
        builder: (context, state) => const TechnicianJobInProgressScreen(),
        ),

        GoRoute(
        path: '/technician_profile_screen',
        builder: (context, state) => const TechnicianProfileScreen(),
        ),

         GoRoute(
        path: '/technician_earnings_screen',
        builder: (context, state) => const TechnicianEarningsScreen(),
        ),
      

    ],
  );
}