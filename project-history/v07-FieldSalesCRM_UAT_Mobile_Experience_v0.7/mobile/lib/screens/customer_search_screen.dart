import 'package:flutter/material.dart';
import '../models/models.dart';
import '../repositories/customer_repository.dart';
import 'customer_profile_screen.dart';

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  List<Customer> results = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    search('');
  }

  Future<void> search(String q) async {
    try {
      final r = await CustomerRepository().search(q);
      if (!mounted) return;
      setState(() {
        results = r;
        loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: 'Search doctor, hospital, distributor, area, city or phone',
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
              subtitle: Text('Create the customer during the first field visit.'),
            ),
          )
        else
          ...results.map((c) => Card(
            child: ListTile(
              title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text('${c.accountName}\n${c.area}, ${c.city} • ${c.potential}'),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CustomerProfileScreen(customer: c)),
              ),
            ),
          )),
      ],
    );
  }
}
