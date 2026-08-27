import 'package:flutter/material.dart';
import '../models/models.dart';
import '../repositories/report_repository.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String period = 'daily';
  PerformanceSnapshot? snapshot;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    try {
      snapshot = await ReportRepository().performance(period);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = snapshot;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          value: period,
          decoration: const InputDecoration(labelText: 'Report Period'),
          items: ['daily', 'weekly', 'monthly', 'quarterly', 'yearly']
              .map((x) => DropdownMenuItem(value: x, child: Text(x.toUpperCase()))).toList(),
          onChanged: (v) {
            period = v!;
            load();
          },
        ),
        const SizedBox(height: 12),
        if (loading)
          const Center(child: CircularProgressIndicator())
        else if (s != null) ...[
          _metric('Total Visits', s.totalVisits.toString()),
          _metric('Qualified Visits', s.qualifiedVisits.toString()),
          _metric('Short Visits', s.shortVisits.toString()),
          _metric('Qualified Rate', '${s.qualifiedVisitRate.toStringAsFixed(1)}%'),
          _metric('Samples', s.samples.toString()),
          _metric('Leads', s.leads.toString()),
          _metric('Pipeline', '₹${s.pipelineValue.toStringAsFixed(0)}'),
          _metric('Orders', s.orders.toString()),
          _metric('Order Value', '₹${s.orderValue.toStringAsFixed(0)}'),
          _metric('Follow-ups', s.followUps.toString()),
        ],
      ],
    );
  }

  Widget _metric(String label, String value) => Card(
    child: ListTile(
      title: Text(label),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
    ),
  );
}
