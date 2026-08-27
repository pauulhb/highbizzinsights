import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/domain_models.dart';
import '../repositories/visit_repository.dart';
import '../services/location_service.dart';
import '../services/visit_rules.dart';

class VisitSessionScreen extends StatefulWidget {
  final Customer customer;
  const VisitSessionScreen({super.key, required this.customer});

  @override
  State<VisitSessionScreen> createState() => _VisitSessionScreenState();
}

class _VisitSessionScreenState extends State<VisitSessionScreen> {
  final location = LocationService();
  final visitRepo = VisitRepository();
  final discussion = TextEditingController();
  final nextAction = TextEditingController();

  VisitDraft? draft;
  Timer? timer;
  Duration elapsed = Duration.zero;
  String outcome = 'Product Discussion';
  String? shortReason;
  bool busy = false;

  Future<void> checkIn() async {
    try {
      setState(() => busy = true);
      final p = await location.currentPosition();
      final distance = location.distanceMeters(
        fromLat: p.latitude,
        fromLng: p.longitude,
        toLat: widget.customer.latitude,
        toLng: widget.customer.longitude,
      );

      if (!VisitRules.isWithinGeofence(distance) && mounted) {
        final proceed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Location exception'),
            content: Text(
              'You are ${distance.toStringAsFixed(0)} metres from the registered customer pin. '
              'Continue only if the meeting is genuinely at an alternate location.'
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('CONTINUE')),
            ],
          ),
        );
        if (proceed != true) return;
      }

      draft = VisitDraft(
        id: const Uuid().v4(),
        customerId: widget.customer.id,
        employeeId: 'KAM-DEMO',
        checkInAt: DateTime.now(),
        checkInLat: p.latitude,
        checkInLng: p.longitude,
        checkInDistanceM: distance,
      );

      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted && draft != null) {
          setState(() => elapsed = DateTime.now().difference(draft!.checkInAt));
        }
      });

      if (mounted) setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> checkOut() async {
    if (draft == null) return;

    final isQualified = VisitRules.isQualified(elapsed);
    if (!isQualified && shortReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a reason for a visit below 15 minutes.')),
      );
      return;
    }

    if (discussion.text.trim().isEmpty || nextAction.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Discussion and next action are mandatory.')),
      );
      return;
    }

    try {
      setState(() => busy = true);
      final p = await location.currentPosition();
      final outDistance = location.distanceMeters(
        fromLat: p.latitude,
        fromLng: p.longitude,
        toLat: widget.customer.latitude,
        toLng: widget.customer.longitude,
      );
      final end = DateTime.now();

      final visit = Visit(
        id: draft!.id,
        customerId: draft!.customerId,
        employeeId: draft!.employeeId,
        checkInAt: draft!.checkInAt,
        checkOutAt: end,
        checkInLat: draft!.checkInLat,
        checkInLng: draft!.checkInLng,
        checkOutLat: p.latitude,
        checkOutLng: p.longitude,
        checkInDistanceM: draft!.checkInDistanceM,
        checkOutDistanceM: outDistance,
        discussion: discussion.text.trim(),
        outcome: outcome,
        nextAction: nextAction.text.trim(),
        qualified: VisitRules.isQualified(end.difference(draft!.checkInAt)),
        shortVisitReason: isQualified ? null : shortReason,
      );

      await visitRepo.save(visit);
      timer?.cancel();

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            visit.qualified
                ? 'Qualified visit saved.'
                : 'Short visit saved and excluded from productive-call KPI.'
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  String format(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    timer?.cancel();
    discussion.dispose();
    nextAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qualified = VisitRules.isQualified(elapsed);
    final remainingSeconds =
        VisitRules.minimumQualifiedSeconds - elapsed.inSeconds;
    final remaining = Duration(seconds: remainingSeconds > 0 ? remainingSeconds : 0);

    return Scaffold(
      appBar: AppBar(title: Text(widget.customer.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(widget.customer.accountName),
              subtitle: Text('${widget.customer.area}, ${widget.customer.city}'),
            ),
          ),
          if (draft == null) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: busy ? null : checkIn,
              icon: const Icon(Icons.location_on),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('GPS CHECK-IN'),
              ),
            ),
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Text(
                      format(elapsed),
                      style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      qualified
                          ? 'Qualified visit duration reached'
                          : '${format(remaining)} remaining for qualified visit',
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(
                        qualified ? 'QUALIFIED ≥ 15 MIN' : 'VISIT IN PROGRESS'
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: outcome,
              decoration: const InputDecoration(labelText: 'Visit Purpose / Outcome'),
              items: [
                'Product Discussion',
                'Product Demonstration',
                'Sample Follow-up',
                'Quotation Discussion',
                'Order Follow-up',
                'Distributor Meeting',
                'Relationship Visit',
              ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => outcome = v!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: discussion,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Discussion / Meeting Notes *'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nextAction,
              decoration: const InputDecoration(labelText: 'Next Action / Follow-up *'),
            ),
            if (!qualified) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: shortReason,
                decoration: const InputDecoration(labelText: 'Short Visit Reason *'),
                items: VisitRules.shortVisitReasons
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => setState(() => shortReason = v),
              ),
            ],
            const SizedBox(height: 18),
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
