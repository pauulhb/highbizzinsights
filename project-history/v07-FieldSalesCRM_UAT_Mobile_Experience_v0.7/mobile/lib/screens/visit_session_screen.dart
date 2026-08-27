import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../repositories/visit_repository.dart';
import '../services/location_service.dart';

class VisitSessionScreen extends StatefulWidget {
  final Customer customer;
  const VisitSessionScreen({super.key, required this.customer});

  @override
  State<VisitSessionScreen> createState() => _VisitSessionScreenState();
}

class _VisitSessionScreenState extends State<VisitSessionScreen> {
  String? visitId;
  DateTime? localCheckIn;
  Timer? timer;
  Duration elapsed = Duration.zero;
  bool geofenceException = false;
  bool busy = false;

  final discussion = TextEditingController();
  final nextAction = TextEditingController();
  String outcome = 'Product Discussion';
  String? shortReason;

  Future<void> checkIn() async {
    try {
      setState(() => busy = true);
      final p = await LocationService().current();
      final r = await VisitRepository().checkIn(
        customerId: widget.customer.id,
        latitude: p.latitude,
        longitude: p.longitude,
      );

      visitId = r['id'];
      localCheckIn = DateTime.parse(r['check_in_at']);
      geofenceException = r['geofenceException'] == true;

      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted && localCheckIn != null) {
          setState(() => elapsed = DateTime.now().difference(localCheckIn!));
        }
      });

      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> checkOut() async {
    try {
      setState(() => busy = true);
      final p = await LocationService().current();

      await VisitRepository().checkOut(
        visitId: visitId!,
        latitude: p.latitude,
        longitude: p.longitude,
        discussion: discussion.text.trim(),
        outcome: outcome,
        nextAction: nextAction.text.trim(),
        shortVisitReason: shortReason,
      );

      timer?.cancel();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  String f(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  void dispose() {
    timer?.cancel();
    discussion.dispose();
    nextAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qualifiedLocally = elapsed.inSeconds >= 900;
    final remaining = Duration(seconds: (900 - elapsed.inSeconds).clamp(0, 900));

    return Scaffold(
      appBar: AppBar(title: Text(widget.customer.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (visitId == null)
            FilledButton.icon(
              onPressed: busy ? null : checkIn,
              icon: const Icon(Icons.location_on),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('GPS CHECK-IN'),
              ),
            )
          else ...[
            if (geofenceException)
              const Card(
                child: ListTile(
                  leading: Icon(Icons.warning_amber_outlined),
                  title: Text('Location Exception'),
                  subtitle: Text('This visit started outside the default customer geofence.'),
                ),
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Text(f(elapsed), style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800)),
                    Text(
                      qualifiedLocally
                          ? 'Qualified duration reached'
                          : '${f(remaining)} remaining for qualified visit',
                    ),
                    const SizedBox(height: 8),
                    Chip(label: Text(qualifiedLocally ? 'QUALIFIED ≥ 15 MIN' : 'VISIT IN PROGRESS')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: outcome,
              decoration: const InputDecoration(labelText: 'Visit Outcome'),
              items: [
                'Product Discussion',
                'Product Demonstration',
                'Sample Follow-up',
                'Quotation Discussion',
                'Order Follow-up',
                'Distributor Meeting',
                'Relationship Visit',
              ].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
              onChanged: (v) => setState(() => outcome = v!),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: discussion,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Discussion / Meeting Notes *'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nextAction,
              decoration: const InputDecoration(labelText: 'Next Action / Follow-up *'),
            ),
            if (!qualifiedLocally) ...[
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: shortReason,
                decoration: const InputDecoration(labelText: 'Short Visit Reason *'),
                items: [
                  'Doctor unavailable',
                  'Emergency / clinical priority',
                  'Purchase team unavailable',
                  'Sample / document drop only',
                  'Customer requested short meeting',
                  'Other',
                ].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
                onChanged: (v) => setState(() => shortReason = v),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: busy ? null : checkOut,
              icon: const Icon(Icons.logout),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('GPS CHECK-OUT & SAVE'),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
