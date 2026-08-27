import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_shell.dart';
import 'screens/login_screen.dart';
import 'services/app_state.dart';

void main() {
  runApp(const FieldSalesCrmApp());
}

class FieldSalesCrmApp extends StatelessWidget {
  const FieldSalesCrmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..init(),
      child: MaterialApp(
        title: 'FieldSalesCRM',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
        ),
        home: const _RootRouter(),
      ),
    );
  }
}

class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    if (appState.isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return appState.isLoggedIn ? const HomeShell() : const LoginScreen();
  }
}
