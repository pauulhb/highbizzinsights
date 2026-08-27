import 'package:flutter/material.dart';
import '../models/domain_models.dart';
import '../repositories/customer_repository.dart';
import 'visit_session_screen.dart';

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  final repo = CustomerRepository();
  List<Customer> results = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
    results = await repo.all();
    if (mounted) setState(() => loading = false);
  }

  Future<void> search(String q) async {
    results = q.trim().isEmpty ? await repo.all() : await repo.search(q);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Customer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Name, Hospital, Distributor, Area, City or Phone',
            ),
            onChanged: search,
          ),
          const SizedBox(height: 12),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (results.isEmpty)
            const Card(
              child: ListTile(
                title: Text('No customer found'),
                subtitle: Text('Create the customer during the first physical visit.'),
              ),
            )
          else
            ...results.map((c) => Card(
              child: ListTile(
                leading: CircleAvatar(child: Text(c.type.label.substring(0, 1))),
                title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text('${c.accountName}\n${c.area}, ${c.city} • ${c.potential}'),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => VisitSessionScreen(customer: c)),
                ),
              ),
            )),
        ],
      ),
    );
  }
}
