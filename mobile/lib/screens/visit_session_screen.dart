import 'dart:async';

import 'package:flutter/material.dart';

import '../models/domain_models.dart';
import '../repositories/commercial_repository.dart';
import '../repositories/visit_repository.dart';
import '../services/visit_rules.dart';
import 'lead_form_screen.dart';
import 'order_form_screen.dart';
import 'sample_form_screen.dart';

class VisitSessionScreen extends StatefulWidget {
  const VisitSessionScreen({super.key, required this.customer, required this.visit});
  final Customer customer;
  final Visit visit;

  @override
  State<VisitSessionScreen> createState() => _VisitSessionScreenState();
}

class _VisitSessionScreenState extends State<VisitSessionScreen> {
  final _visitRepository = VisitRepository();
  final _commercialRepository = CommercialRepository();
  final _notesController = TextEditingController();
  final _nextActionController = TextEditingController();

  Timer? _ticker;
  Duration _elapsed = Duration.zero;
  bool _checkingOut = false;
  int _actionsRecorded = 0;

  @override
  void initState() {
    super.initState();
    _elapsed = DateTime.now().difference(widget.visit.checkInAt);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed = DateTime.now().difference(widget.visit.checkInAt));
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _notesController.dispose();
    _nextActionController.dispose();
    super.dispose();
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${d.inHours.toString().padLeft(2, '0')}:$m:$s';
  }

  Future<void> _recordCommercialAction(CommercialActionType type) async {
    Map<String, String>? fields;
    switch (type) {
      case CommercialActionType.lead:
        fields = await Navigator.of(context)
            .push<Map<String, String>>(MaterialPageRoute(builder: (_) => const LeadFormScreen()));
        break;
      case CommercialActionType.order:
        fields = await Navigator.of(context)
            .push<Map<String, String>>(MaterialPageRoute(builder: (_) => const OrderFormScreen()));
        break;
      case CommercialActionType.sample:
      case CommercialActionType.feedback:
      case CommercialActionType.followUp:
        fields = await Navigator.of(context).push<Map<String, String>>(
            MaterialPageRoute(builder: (_) => SampleFormScreen(actionType: type)));
        break;
    }
    if (fields == null) return;
    await _commercialRepository.record(
      visitId: widget.visit.id,
      type: type,
      fields: fields,
    );
    setState(() => _actionsRecorded++);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Recorded.')));
    }
  }

  Future<void> _checkOut() async {
    setState(() => _checkingOut = true);
    try {
      final visit = await _visitRepository.checkOut(
        visit: widget.visit,
        customer: widget.customer,
        discussionNotes: _notesController.text,
        nextAction: _nextActionController.text,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(visit.isQualified ? 'Qualified visit' : 'Short visit recorded'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Duration: ${_format(visit.duration)}'),
              if (!visit.isQualified)
                const Text('Below the 15 minute threshold — kept in the DWR and audit history.'),
              if (visit.isLocationException)
                const Text('Outside geofence — flagged as a Location Exception.',
                    style: TextStyle(color: Colors.orange)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not check out: $e')));
      }
    } finally {
      if (mounted) setState(() => _checkingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final qualified = VisitRules.isQualified(_elapsed);
    return Scaffold(
      appBar: AppBar(title: Text('Visit — ${widget.customer.name}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: qualified ? Colors.green.shade50 : null,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(_format(_elapsed),
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(qualified
                      ? 'Qualified / Productive visit'
                      : 'Needs 15:00 minutes to qualify'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Commercial actions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.card_giftcard, size: 18),
                label: const Text('Sample'),
                onPressed: () => _recordCommercialAction(CommercialActionType.sample),
              ),
              ActionChip(
                avatar: const Icon(Icons.feedback_outlined, size: 18),
                label: const Text('Feedback'),
                onPressed: () => _recordCommercialAction(CommercialActionType.feedback),
              ),
              ActionChip(
                avatar: const Icon(Icons.trending_up, size: 18),
                label: const Text('Lead'),
                onPressed: () => _recordCommercialAction(CommercialActionType.lead),
              ),
              ActionChip(
                avatar: const Icon(Icons.shopping_cart_outlined, size: 18),
                label: const Text('Order'),
                onPressed: () => _recordCommercialAction(CommercialActionType.order),
              ),
            ],
          ),
          if (_actionsRecorded > 0) ...[
            const SizedBox(height: 8),
            Text('$_actionsRecorded action(s) recorded this visit.',
                style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 20),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Discussion notes',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nextActionController,
            decoration: const InputDecoration(
              labelText: 'Next action',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _checkingOut ? null : _checkOut,
            icon: const Icon(Icons.logout),
            label: Text(_checkingOut ? 'Checking out…' : 'Check out / end visit'),
          ),
        ],
      ),
    );
  }
}
