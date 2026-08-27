import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../services/report_service.dart';
import '../services/sync_service.dart';
import '../widgets/stat_card.dart';
import 'customer_search_screen.dart';
import 'new_customer_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _reportService = ReportService();
  final _syncService = SyncService();
  DwrSummary? _summary;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final summary = await _reportService.summary(ReportPeriod.daily);
    if (mounted) setState(() => _summary = summary);
  }

  Future<void> _sync() async {
    setState(() => _syncing = true);
    final result = await _syncService.syncNow();
    if (!mounted) return;
    setState(() => _syncing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.hadPendingWork
            ? 'Synced ${result.succeeded} item(s), ${result.failed} pending.'
            : 'Nothing to sync.'),
      ),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().currentUser;
    final summary = _summary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${user?.name.split(' ').first ?? ''}'),
        actions: [
          IconButton(
            onPressed: _syncing ? null : _sync,
            icon: _syncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            tooltip: 'Sync now',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text("Today's activity", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (summary == null)
              const Center(child: CircularProgressIndicator())
            else
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  StatCard(label: 'Total visits', value: '${summary.totalVisits}'),
                  StatCard(
                      label: 'Qualified',
                      value: '${summary.qualifiedVisits}',
                      color: Colors.green),
                  StatCard(
                      label: 'Short visits',
                      value: '${summary.shortVisits}',
                      color: Colors.orange),
                  StatCard(
                      label: 'Location exceptions',
                      value: '${summary.locationExceptions}',
                      color: Colors.red),
                ],
              ),
            const SizedBox(height: 24),
            Text('Quick actions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CustomerSearchScreen()),
              ),
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Start a visit'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NewCustomerScreen()),
              ),
              icon: const Icon(Icons.person_add_alt),
              label: const Text('Add new customer'),
            ),
          ],
        ),
      ),
    );
  }
}
