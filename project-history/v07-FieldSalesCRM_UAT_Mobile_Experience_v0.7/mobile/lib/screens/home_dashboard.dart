import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/sync_service.dart';
import 'new_customer_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int pendingSync = 0;

  Future<void> refreshSync() async {
    pendingSync = await SyncService().pendingCount();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    refreshSync();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final s = app.session;

    return RefreshIndicator(
      onRefresh: () async {
        await SyncService().flush();
        await refreshSync();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            s == null ? 'Welcome' : s.fullName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          if (s != null) Text('${s.hq} • ${s.state} • ${s.role}'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: app.dayStarted ? null : app.startDay,
            icon: const Icon(Icons.play_arrow),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(app.dayStarted ? 'DAY STARTED' : 'START DAY'),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewCustomerScreen()),
            ),
            icon: const Icon(Icons.person_add_alt_1),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('NEW CUSTOMER'),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Offline Sync'),
              subtitle: Text('$pendingSync pending record(s)'),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await SyncService().flush();
                  await refreshSync();
                },
              ),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.timer_outlined),
              title: Text('15-minute Qualified Visit'),
              subtitle: Text(
                'The server validates check-in/check-out time; visits below 15 minutes require a reason.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
