import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'sample_form_screen.dart';
import 'lead_form_screen.dart';
import 'order_form_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Today', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _Kpi('Qualified', '${state.qualifiedVisits}'),
            _Kpi('Short', '${state.shortVisits}'),
            _Kpi('Samples', '${state.samples.length}'),
            _Kpi('Leads', '${state.leads.length}'),
            _Kpi('Orders', '${state.orders.length}'),
            _Kpi('Follow-ups', '${state.pendingFollowUps}'),
          ],
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: state.dayStarted ? null : state.startDay,
          icon: const Icon(Icons.play_arrow),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(state.dayStarted ? 'DAY STARTED' : 'START DAY'),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SampleFormScreen())
          ),
          icon: const Icon(Icons.science_outlined),
          label: const Text('RECORD SAMPLE'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LeadFormScreen())
          ),
          icon: const Icon(Icons.trending_up),
          label: const Text('CREATE LEAD'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const OrderFormScreen())
          ),
          icon: const Icon(Icons.shopping_cart_outlined),
          label: const Text('RECORD ORDER'),
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
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
