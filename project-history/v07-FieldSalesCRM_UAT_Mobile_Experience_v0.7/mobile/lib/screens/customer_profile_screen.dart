import 'package:flutter/material.dart';
import '../models/models.dart';
import '../repositories/customer_repository.dart';
import 'visit_session_screen.dart';
import 'commercial_actions_screen.dart';

class CustomerProfileScreen extends StatefulWidget {
  final Customer customer;
  const CustomerProfileScreen({super.key, required this.customer});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  List<TimelineItem> timeline = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      timeline = await CustomerRepository().timeline(widget.customer.id);
    } catch (_) {
      timeline = [];
    }
    if (mounted) setState(() => loading = false);
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
            child: ListTile(
              title: Text(c.accountName),
              subtitle: Text('${c.area}, ${c.city}\nPotential ${c.potential}'),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VisitSessionScreen(customer: c)),
            ),
            icon: const Icon(Icons.location_on),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('START CUSTOMER VISIT'),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CommercialActionsScreen(customer: c)),
            ),
            icon: const Icon(Icons.business_center_outlined),
            label: const Text('SAMPLE / LEAD / ORDER'),
          ),
          const SizedBox(height: 18),
          const Text('Customer Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (timeline.isEmpty)
            const Card(child: ListTile(title: Text('No CRM history yet.')))
          else
            ...timeline.map((t) => Card(
              child: ListTile(
                title: Text(t.title),
                subtitle: Text('${t.type.toUpperCase()} • ${t.detail}\n${t.at}'),
                isThreeLine: true,
              ),
            )),
        ],
      ),
    );
  }
}
