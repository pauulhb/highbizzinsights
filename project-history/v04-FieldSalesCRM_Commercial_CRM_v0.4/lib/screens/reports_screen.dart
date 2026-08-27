import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/report_service.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final report = ReportService().buildDwr(
      date: DateTime.now(),
      customers: state.customers,
      visits: state.visits,
      samples: state.samples,
      leads: state.leads,
      orders: state.orders,
      followUps: state.followUps,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Daily Work Report', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        _row('Total Visits', report.totalVisits.toString()),
        _row('Qualified Visits', report.qualifiedVisits.toString()),
        _row('Short Visits', report.shortVisits.toString()),
        _row('Qualified Visit Rate', '${report.qualifiedVisitRate.toStringAsFixed(1)}%'),
        _row('New Customers', report.newCustomers.toString()),
        _row('Samples', report.samples.toString()),
        _row('Leads', report.leads.toString()),
        _row('Pipeline Value', '₹${report.pipelineValue.toStringAsFixed(0)}'),
        _row('Orders', report.orders.toString()),
        _row('Order Value', '₹${report.orderValue.toStringAsFixed(0)}'),
        _row('Follow-ups', report.followUpsCreated.toString()),
        const SizedBox(height: 18),
        const Card(
          child: ListTile(
            leading: Icon(Icons.calendar_month_outlined),
            title: Text('Period reporting structure ready'),
            subtitle: Text('Weekly • Monthly • Quarterly • Yearly'),
          ),
        )
      ],
    );
  }

  Widget _row(String label, String value) => Card(
    child: ListTile(
      title: Text(label),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
    ),
  );
}
