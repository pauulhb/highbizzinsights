import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final totalVisits = state.qualifiedVisits + state.shortVisits;
    final rate = totalVisits == 0 ? 0 : state.qualifiedVisits / totalVisits * 100;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Management Snapshot',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _Kpi('Qualified Visits', '${state.qualifiedVisits}'),
            _Kpi('Short Visits', '${state.shortVisits}'),
            _Kpi('Qualified Rate', '${rate.toStringAsFixed(1)}%'),
            _Kpi('Samples', '${state.samples.length}'),
            _Kpi('Pipeline', '₹${state.pipelineValue.toStringAsFixed(0)}'),
            _Kpi('Orders', '₹${state.orderValue.toStringAsFixed(0)}'),
          ],
        ),
        const SizedBox(height: 16),
        const Card(
          child: ListTile(
            leading: Icon(Icons.account_tree_outlined),
            title: Text('Drill-down model'),
            subtitle: Text('Region → State → HQ → KAM → Customer → Visit'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.warning_amber_outlined),
            title: Text('Short-visit monitoring'),
            subtitle: Text(
              'Visits below 15 minutes stay visible for management review but are excluded from productive-call KPI.',
            ),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.insights_outlined),
            title: Text('Commercial intelligence'),
            subtitle: Text(
              'Pipeline, samples, feedback, orders and follow-ups now sit beside field productivity.',
            ),
          ),
        ),
      ],
    );
  }
}

class _Kpi extends StatelessWidget {
  final String label;
  final String value;
  const _Kpi(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
