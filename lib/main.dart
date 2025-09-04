import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interviews_flutter_assignment/injection_container.dart' as di;
import 'package:interviews_flutter_assignment/presentation/application/bloc/bloc.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/bloc.dart';
import 'package:interviews_flutter_assignment/presentation/jobs/bloc/bloc.dart';
import 'app_router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  final authBloc = di.sl<AuthBloc>();
  final router = await createAppRouter(authBloc);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => authBloc),
        BlocProvider<JobsBloc>(create: (_) => di.sl<JobsBloc>()),
        BlocProvider<ApplicationBloc>(create: (_) => di.sl<ApplicationBloc>()),
      ],
      child: MyApp(appRouter: router),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Job Application App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
