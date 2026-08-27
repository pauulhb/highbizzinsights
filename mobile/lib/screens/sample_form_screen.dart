import 'package:flutter/material.dart';

import '../models/domain_models.dart';

/// Shared form for sample / feedback / follow-up commercial actions — the
/// three types that only need a short free-text note.
class SampleFormScreen extends StatefulWidget {
  const SampleFormScreen({super.key, required this.actionType});
  final CommercialActionType actionType;

  @override
  State<SampleFormScreen> createState() => _SampleFormScreenState();
}

class _SampleFormScreenState extends State<SampleFormScreen> {
  final _item = TextEditingController();
  final _notes = TextEditingController();

  String get _title {
    switch (widget.actionType) {
      case CommercialActionType.sample:
        return 'Sample dropped';
      case CommercialActionType.feedback:
        return 'Feedback';
      case CommercialActionType.followUp:
        return 'Follow-up';
      case CommercialActionType.lead:
      case CommercialActionType.order:
        return 'Details';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _item,
            decoration: InputDecoration(
                labelText: widget.actionType == CommercialActionType.sample
                    ? 'Sample / item'
                    : 'Subject'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.of(context).pop({
              'item': _item.text,
              'notes': _notes.text,
            }),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
