import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class ManagerScreen extends StatelessWidget {
  const ManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppState>().session;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Manager View',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            title: Text(session?.role ?? 'Unknown Role'),
            subtitle: Text('${session?.hq ?? ''} • ${session?.state ?? ''}'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.account_tree_outlined),
            title: Text('Role-aware drill-down'),
            subtitle: Text('Region → State → HQ → KAM → Customer → Visit'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.timer_outlined),
            title: Text('Short Visit Review'),
            subtitle: Text('Visits below 15 minutes remain visible separately for management review.'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.insights_outlined),
            title: Text('Commercial Performance'),
            subtitle: Text('Qualified visits, samples, leads, pipeline and orders remain connected.'),
          ),
        ),
      ],
    );
  }
}
