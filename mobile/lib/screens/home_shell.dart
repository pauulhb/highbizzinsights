import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import 'customer_search_screen.dart';
import 'dashboard_screen.dart';
import 'manager_dashboard_screen.dart';
import 'profile_screen.dart';
import 'reports_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final canViewHierarchy = context.watch<AppState>().canViewHierarchy;

    final tabs = <_Tab>[
      const _Tab(
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        screen: DashboardScreen(),
      ),
      const _Tab(
        label: 'Customers',
        icon: Icons.people_outline,
        screen: CustomerSearchScreen(),
      ),
      const _Tab(
        label: 'Reports',
        icon: Icons.bar_chart_outlined,
        screen: ReportsScreen(),
      ),
      if (canViewHierarchy)
        const _Tab(
          label: 'Manager',
          icon: Icons.account_tree_outlined,
          screen: ManagerDashboardScreen(),
        ),
      const _Tab(
        label: 'Profile',
        icon: Icons.person_outline,
        screen: ProfileScreen(),
      ),
    ];

    final currentIndex = _index >= tabs.length ? 0 : _index;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: tabs.map((t) => t.screen).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: tabs
            .map((t) => NavigationDestination(icon: Icon(t.icon), label: t.label))
            .toList(),
      ),
    );
  }
}

class _Tab {
  const _Tab({required this.label, required this.icon, required this.screen});
  final String label;
  final IconData icon;
  final Widget screen;
}
