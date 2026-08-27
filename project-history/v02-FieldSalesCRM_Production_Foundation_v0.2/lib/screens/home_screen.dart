import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Field Sales CRM')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Today', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _Kpi('Total Visits', '${state.visits.length}'),
              _Kpi('Qualified', '${state.qualifiedVisits}'),
              _Kpi('Short', '${state.shortVisits}'),
              _Kpi('Customers', '${state.customers.length}'),
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
          const Card(
            child: ListTile(
              leading: Icon(Icons.timer_outlined),
              title: Text('15-minute qualified visit rule'),
              subtitle: Text(
                'Visits below 15 minutes stay recorded as Short Visits and require a reason.',
              ),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('GPS verification foundation'),
              subtitle: Text('Device location and customer geofence service included.'),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.cloud_off_outlined),
              title: Text('Offline-first foundation'),
              subtitle: Text('SQLite local storage and pending-sync structure included.'),
            ),
          ),
        ],
      ),
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
