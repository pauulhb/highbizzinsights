import 'package:flutter/material.dart';

class LeadFormScreen extends StatefulWidget {
  const LeadFormScreen({super.key});

  @override
  State<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends State<LeadFormScreen> {
  final _product = TextEditingController();
  final _notes = TextEditingController();
  String _stage = 'New';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New lead')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _product,
            decoration: const InputDecoration(labelText: 'Product / interest'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _stage,
            decoration: const InputDecoration(labelText: 'Pipeline stage'),
            items: ['New', 'Qualifying', 'Proposal', 'Negotiation', 'Won', 'Lost']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _stage = v ?? _stage),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.of(context).pop({
              'product': _product.text,
              'stage': _stage,
              'notes': _notes.text,
            }),
            child: const Text('Save lead'),
          ),
        ],
      ),
    );
  }
}
