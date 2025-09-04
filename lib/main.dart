import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/bloc.dart';
import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authBloc = AuthBloc();
  final router = await createAppRouter(authBloc);

  runApp(
    BlocProvider(
      create: (_) => authBloc,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: appRouter,
    );
  }
}
