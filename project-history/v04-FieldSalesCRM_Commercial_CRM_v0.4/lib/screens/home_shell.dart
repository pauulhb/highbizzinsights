import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'commercial_screen.dart';
import 'reports_screen.dart';
import 'manager_dashboard_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = const [
      DashboardScreen(),
      CommercialScreen(),
      ReportsScreen(),
      ManagerDashboardScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Field Sales CRM')),
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.business_center_outlined), label: 'CRM'),
          NavigationDestination(icon: Icon(Icons.assessment_outlined), label: 'Reports'),
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Manager'),
        ],
      ),
    );
  }
}
