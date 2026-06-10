import 'package:go_router/go_router.dart';
import 'package:onboarding_frontend/presentation/screens/companies/companies_list_screen.dart';
import '../presentation/screens/login/login_screen_new.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/layouts/main_layout.dart';
import '../presentation/screens/courses/courses_list_screen.dart';
import '../presentation/screens/users/users_list_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/branding_settings/branding_settings_screen.dart';
import '../presentation/screens/profile/user_profile_screen.dart';
import '../presentation/screens/onboarding/onboarding_tasks_screen.dart';
import '../presentation/screens/mentor_rating/mentor_rating_screen.dart';
import '../presentation/screens/mentor_rating/mentor_assignment_screen.dart';
import '../presentation/screens/badge_award/badge_award_screen.dart';
import '../data/services/auth_service.dart';
import '../data/services/auth_state.dart';

class AppRouter {
  static final router = GoRouter(
    refreshListenable: AuthState.instance,
    redirect: (context, state) async {
      final loggedIn = await AuthService.isLoggedIn();
      final role = await AuthService.getRole();

      final goingToLogin = state.uri.toString() == '/';

      if (!loggedIn && !goingToLogin) {
        return '/';
      }

      if (loggedIn && goingToLogin) {
        return '/dashboard';
      }

      final path = state.uri.path;

      // Define admin/HR only routes
      final adminOnlyRoutes = ['/users', '/companies', '/badge-award', '/mentor-assign'];

      if (adminOnlyRoutes.contains(path)) {
        final hasAdminPermission = role == 'admin' || role == 'super-admin' || role == 'hr';
        if (!hasAdminPermission) {
          return '/dashboard';
        }
      }

      // Define employee only routes
      if (path == '/mentor-rating') {
        final isEmployee = role == 'employee' || role == 'user';
        if (!isEmployee) {
          return '/dashboard';
        }
      }

      return null;
    },
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreenNew(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const UserProfileScreen(),
          ),
          GoRoute(
            path: '/courses',
            builder: (context, state) =>
                const CoursesListScreen(role: 'employee'),
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) => const UsersListScreen(),
          ),
          GoRoute(
            path: '/branding_settings',
            builder: (context, state) => const BrandingSettingsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const OnboardingSettingsScreen(),
          ),
          GoRoute(
            path: '/companies',
            builder: (context, state) => const CompanyManagementScreen(),
          ),
          GoRoute(
            path: '/mentor-rating',
            builder: (context, state) {
              final taskTitle = state.uri.queryParameters['taskTitle'];
              final mentorName = state.uri.queryParameters['mentorName'] ?? 'Piotr Wiśniewski';
              return MentorRatingScreen(
                taskTitle: taskTitle,
                mentorName: mentorName,
                onBack: () => context.go('/dashboard'),
              );
            },
          ),
          GoRoute(
            path: '/mentor-assign',
            builder: (context, state) {
              final taskTitle = state.uri.queryParameters['taskTitle'];
              return MentorAssignmentScreen(
                taskTitle: taskTitle,
                onBack: () => context.go('/dashboard'),
              );
            },
          ),
          GoRoute(
            path: '/badge-award',
            builder: (context, state) => const BadgeAwardScreen(),
          ),
          GoRoute(
            path: '/onboarding',
            builder: (context, state) => const OnboardingTasksScreen(),
          ),
        ],
      ),
    ],
  );
}
