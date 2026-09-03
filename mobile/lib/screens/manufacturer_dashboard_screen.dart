import 'package:flutter/material.dart';

import '../models/domain_models.dart';
import '../repositories/manager_repository.dart';
import '../services/local_database.dart';
import '../services/report_service.dart';
import '../services/sync_service.dart';
import '../widgets/stat_card.dart';

/// A back-office style console for the manufacturer/brand team: aggregate
/// commercial pipeline numbers and field network coverage, rather than the
/// day-to-day visit workflow a KAM uses. On a single device this reads the
/// same local database the KAM demo account writes to, so recording a
/// sample/lead/order as the KAM account and reopening this screen as the
/// manufacturer account shows it reflected here — a stand-in for what a
/// real deployment would serve from the shared backend instead.
class ManufacturerDashboardScreen extends StatefulWidget {
  const ManufacturerDashboardScreen({super.key});

  @override
  State<ManufacturerDashboardScreen> createState() => _ManufacturerDashboardScreenState();
}

class _ManufacturerDashboardScreenState extends State<ManufacturerDashboardScreen> {
  final _db = LocalDatabase.instance;
  final _reportService = ReportService();
  final _syncService = SyncService();

  DwrSummary? _summary;
  List<CommercialAction> _actions = [];
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final summary = await _reportService.summary(ReportPeriod.monthly);
    final actions = await _db.allCommercialActions();
    if (mounted) {
      setState(() {
        _summary = summary;
        _actions = actions;
      });
    }
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
    _load();
  }

  Map<CommercialActionType, int> get _pipelineCounts {
    final counts = <CommercialActionType, int>{
      for (final t in CommercialActionType.values) t: 0,
    };
    for (final a in _actions) {
      counts[a.type] = (counts[a.type] ?? 0) + 1;
    }
    return counts;
  }

  String _pipelineLabel(CommercialActionType t) {
    switch (t) {
      case CommercialActionType.sample:
        return 'Samples';
      case CommercialActionType.feedback:
        return 'Feedback';
      case CommercialActionType.lead:
        return 'Leads';
      case CommercialActionType.order:
        return 'Orders';
      case CommercialActionType.followUp:
        return 'Follow-ups';
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;
    final pipeline = _pipelineCounts;
    final maxPipeline = pipeline.values.fold(0, (a, b) => a > b ? a : b);
    final tree = ManagerRepository().organizationTree();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manufacturer console'),
        actions: [
          IconButton(
            onPressed: _syncing ? null : _sync,
            icon: _syncing
                ? const SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
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
            Text('This month at a glance', style: Theme.of(context).textTheme.titleMedium),
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
                  StatCard(label: 'Field visits', value: '${summary.totalVisits}'),
                  StatCard(
                      label: 'Qualified rate',
                      value: '${(summary.qualifiedRate * 100).toStringAsFixed(0)}%',
                      color: Colors.green),
                  StatCard(
                      label: 'Orders logged',
                      value: '${pipeline[CommercialActionType.order] ?? 0}',
                      color: Colors.indigo),
                  StatCard(
                      label: 'Samples dropped',
                      value: '${pipeline[CommercialActionType.sample] ?? 0}',
                      color: Colors.teal),
                ],
              ),
            const SizedBox(height: 24),
            Text('Commercial pipeline', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: CommercialActionType.values.map((t) {
                    final count = pipeline[t] ?? 0;
                    final fraction = maxPipeline == 0 ? 0.0 : count / maxPipeline;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          SizedBox(width: 90, child: Text(_pipelineLabel(t))),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: fraction,
                                minHeight: 10,
                                backgroundColor:
                                    Theme.of(context).colorScheme.surfaceContainerHighest,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                              width: 24,
                              child: Text('$count', textAlign: TextAlign.right)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Field network coverage', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: tree.children
                    .map((region) => ListTile(
                          leading: const Icon(Icons.public),
                          title: Text(region.name),
                          subtitle: Text(
                              '${region.children.length} state(s) • ${_countLeaves(region)} KAM(s)'),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),
            Text('Recent activity', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (_actions.isEmpty)
              const Text('No commercial actions recorded on this device yet.')
            else
              ..._actions.take(10).map((a) => Card(
                    child: ListTile(
                      leading: Icon(_iconFor(a.type)),
                      title: Text(_pipelineLabel(a.type)),
                      subtitle: Text(a.fields['product'] ??
                          a.fields['item'] ??
                          a.fields['notes'] ??
                          '—'),
                      trailing: Text(
                        '${a.createdAt.hour.toString().padLeft(2, '0')}:${a.createdAt.minute.toString().padLeft(2, '0')}',
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  int _countLeaves(HierarchyNode node) {
    if (node.isLeaf) return 1;
    return node.children.fold(0, (sum, child) => sum + _countLeaves(child));
  }

  IconData _iconFor(CommercialActionType t) {
    switch (t) {
      case CommercialActionType.sample:
        return Icons.card_giftcard;
      case CommercialActionType.feedback:
        return Icons.feedback_outlined;
      case CommercialActionType.lead:
        return Icons.trending_up;
      case CommercialActionType.order:
        return Icons.shopping_cart_outlined;
      case CommercialActionType.followUp:
        return Icons.follow_the_signs_outlined;
    }
  }
}
