import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:interviews_flutter_assignment/core/utils/auth_preferences.dart';
import 'package:interviews_flutter_assignment/presentation/application/pages/applications_screen.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/bloc.dart';
import 'dart:async';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/state.dart';
import 'package:interviews_flutter_assignment/presentation/auth/pages/auth_screen.dart';
import 'package:interviews_flutter_assignment/presentation/jobs/pages/job_detail_screen.dart';
import 'package:interviews_flutter_assignment/presentation/jobs/pages/jobs_list_scree.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<GoRouter> createAppRouter(AuthBloc authBloc) async {
  final savedEmail = await AuthPreferences.getUserEmail();
  if (savedEmail != null) {
    // ignore: invalid_use_of_visible_for_testing_member
    authBloc.emit(Authenticated(savedEmail));
  }

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/jobs',
        builder: (context, state) => const JobsListScreen(),
      ),
      GoRoute(
        path: '/jobs/:id',
        builder: (context, state) {
          final jobId = state.pathParameters['id']!;
          return JobDetailScreen(jobId: jobId);
        },
      ),

      GoRoute(
        path: '/applications',
        builder: (context, state) => const ApplicationsScreen(),
      ),
    ],
    redirect: (context, state) {
      final authState = authBloc.state;
      final loggingIn = state.matchedLocation == '/';

      if (authState is Authenticated && loggingIn) return '/jobs';
      if (authState is! Authenticated &&
          state.matchedLocation.startsWith('/jobs')) {
        return '/';
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
