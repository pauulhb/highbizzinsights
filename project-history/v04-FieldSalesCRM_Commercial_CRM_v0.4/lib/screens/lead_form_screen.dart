import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/domain_models.dart';
import '../services/app_state.dart';

class LeadFormScreen extends StatefulWidget {
  const LeadFormScreen({super.key});

  @override
  State<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends State<LeadFormScreen> {
  String? productId;
  final customerId = TextEditingController();
  final value = TextEditingController();
  final nextAction = TextEditingController();
  int probability = 50;
  String stage = 'New Lead';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Create Lead')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: customerId,
            decoration: const InputDecoration(labelText: 'Customer ID / Name reference'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: productId,
            decoration: const InputDecoration(labelText: 'Product *'),
            items: state.products.map((p) =>
              DropdownMenuItem(value: p.id, child: Text(p.name))
            ).toList(),
            onChanged: (v) => setState(() => productId = v),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: value,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Expected Value'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: probability,
            decoration: const InputDecoration(labelText: 'Probability'),
            items: [25, 50, 70, 90]
              .map((p) => DropdownMenuItem(value: p, child: Text('$p%'))).toList(),
            onChanged: (v) => setState(() => probability = v!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: stage,
            decoration: const InputDecoration(labelText: 'Stage'),
            items: ['New Lead', 'Product Discussion', 'Sample', 'Quotation', 'Negotiation', 'Expected Order']
              .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => stage = v!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: nextAction,
            decoration: const InputDecoration(labelText: 'Next Action *'),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () {
              if (productId == null) return;
              final p = state.products.firstWhere((e) => e.id == productId);
              final due = DateTime.now().add(const Duration(days: 3));
              final lead = LeadRecord(
                id: const Uuid().v4(),
                customerId: customerId.text.trim(),
                productId: p.id,
                productName: p.name,
                expectedValue: double.tryParse(value.text) ?? 0,
                probability: probability,
                stage: stage,
                expectedClosure: DateTime.now().add(const Duration(days: 30)),
                nextAction: nextAction.text.trim(),
                nextActionDueAt: due,
              );
              state.addLead(lead);
              state.addFollowUp(FollowUpRecord(
                id: const Uuid().v4(),
                customerId: customerId.text.trim(),
                title: nextAction.text.trim().isEmpty ? 'Lead follow-up' : nextAction.text.trim(),
                dueAt: due,
                sourceType: 'lead',
                sourceId: lead.id,
              ));
              Navigator.pop(context);
            },
            child: const Text('SAVE LEAD'),
          ),
        ],
      ),
    );
  }
}
