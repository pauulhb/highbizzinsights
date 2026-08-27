import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/domain_models.dart';
import '../repositories/visit_repository.dart';
import '../services/app_state.dart';
import 'visit_session_screen.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key, required this.customer});
  final Customer customer;

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final _visitRepository = VisitRepository();
  List<Visit> _history = [];
  bool _startingVisit = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _visitRepository.historyFor(widget.customer.id);
    if (mounted) setState(() => _history = history);
  }

  Future<void> _startVisit() async {
    final user = context.read<AppState>().currentUser;
    if (user == null) return;
    setState(() => _startingVisit = true);
    try {
      final result = await _visitRepository.checkIn(
        customer: widget.customer,
        kamId: user.id,
      );
      if (result.isLocationException && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Outside the registered geofence — recorded as a Location Exception.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VisitSessionScreen(
            customer: widget.customer,
            visit: result.visit,
          ),
        ),
      );
      _loadHistory();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not start visit: $e')));
      }
    } finally {
      if (mounted) setState(() => _startingVisit = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.customer;
    return Scaffold(
      appBar: AppBar(title: Text(c.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customerTypeLabel(c.type),
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text(c.accountName, style: Theme.of(context).textTheme.titleMedium),
                  Text('${c.area}, ${c.city}, ${c.state}'),
                  Text('Phone: ${c.phone.isEmpty ? '—' : c.phone}'),
                  Text('Potential: ${c.potential}'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        c.hasVerifiedLocation ? Icons.verified : Icons.location_off,
                        size: 16,
                        color: c.hasVerifiedLocation ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(c.hasVerifiedLocation
                          ? 'Location verified'
                          : 'Location not verified'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _startingVisit ? null : _startVisit,
            icon: const Icon(Icons.login),
            label: Text(_startingVisit ? 'Checking in…' : 'Check in / start visit'),
          ),
          const SizedBox(height: 24),
          Text('Visit history', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (_history.isEmpty)
            const Text('No visits recorded yet.')
          else
            ..._history.map((v) => Card(
                  child: ListTile(
                    leading: Icon(
                      v.isComplete
                          ? (v.isQualified ? Icons.check_circle : Icons.timelapse)
                          : Icons.play_circle_outline,
                      color: v.isComplete
                          ? (v.isQualified ? Colors.green : Colors.orange)
                          : Colors.blue,
                    ),
                    title: Text('${v.checkInAt}'),
                    subtitle: Text(v.isComplete
                        ? '${v.duration.inMinutes} min • ${v.isQualified ? 'Qualified' : 'Short visit'}${v.isLocationException ? ' • Location exception' : ''}'
                        : 'In progress'),
                  ),
                )),
        ],
      ),
    );
  }
}
