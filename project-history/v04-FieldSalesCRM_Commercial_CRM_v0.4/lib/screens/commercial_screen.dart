import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class CommercialScreen extends StatelessWidget {
  const CommercialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Pipeline ₹${state.pipelineValue.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        const Text('Open Leads', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        if (state.leads.isEmpty)
          const Card(child: ListTile(title: Text('No leads created yet.')))
        else
          ...state.leads.map((l) => Card(
            child: ListTile(
              title: Text(l.productName),
              subtitle: Text('${l.stage} • ${l.probability}% probability\n${l.nextAction}'),
              isThreeLine: true,
              trailing: Text('₹${l.expectedValue.toStringAsFixed(0)}'),
            ),
          )),
        const SizedBox(height: 16),
        const Text('Pending Follow-ups', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        if (state.followUps.where((f) => !f.completed).isEmpty)
          const Card(child: ListTile(title: Text('No pending follow-ups.')))
        else
          ...state.followUps.where((f) => !f.completed).map((f) => Card(
            child: CheckboxListTile(
              value: f.completed,
              title: Text(f.title),
              subtitle: Text('Due: ${f.dueAt}'),
              onChanged: (v) {
                f.completed = v ?? false;
                state.notifyListeners();
              },
            ),
          )),
      ],
    );
  }
}
