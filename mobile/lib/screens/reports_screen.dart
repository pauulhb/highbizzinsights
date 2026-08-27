import 'package:flutter/material.dart';

import '../services/report_service.dart';
import '../services/sync_service.dart';
import '../widgets/stat_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _reportService = ReportService();
  final _syncService = SyncService();
  ReportPeriod _period = ReportPeriod.daily;
  DwrSummary? _summary;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final summary = await _reportService.summary(_period);
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
              : 'Nothing to sync.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports (DWR)'),
        actions: [
          IconButton(
            onPressed: _syncing ? null : _sync,
            icon: _syncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.sync),
            tooltip: 'Sync now',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ReportPeriod.values.map((p) {
                final selected = p == _period;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(reportPeriodLabel(p)),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _period = p);
                      _load();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          if (summary == null)
            const Center(child: CircularProgressIndicator())
          else ...[
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
                    label: 'Qualified rate',
                    value: '${(summary.qualifiedRate * 100).toStringAsFixed(0)}%',
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
            const SizedBox(height: 16),
            Text('Visit log', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (summary.visits.isEmpty)
              const Text('No visits in this period.')
            else
              ...summary.visits.map((v) => Card(
                    child: ListTile(
                      title: Text('${v.checkInAt}'),
                      subtitle: Text(v.isComplete
                          ? '${v.duration.inMinutes} min • ${v.isQualified ? 'Qualified' : 'Short'}'
                          : 'In progress'),
                      trailing: v.isLocationException
                          ? const Icon(Icons.warning_amber, color: Colors.orange)
                          : null,
                    ),
                  )),
          ],
        ],
      ),
    );
  }
}
