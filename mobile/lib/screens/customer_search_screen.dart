import 'package:flutter/material.dart';

import '../models/domain_models.dart';
import '../repositories/customer_repository.dart';
import 'customer_profile_screen.dart';
import 'new_customer_screen.dart';

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  final _repository = CustomerRepository();
  final _controller = TextEditingController();
  List<Customer> _results = [];

  @override
  void initState() {
    super.initState();
    _search('');
  }

  Future<void> _search(String query) async {
    final results = await _repository.search(query);
    if (mounted) setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewCustomerScreen()),
          );
          _search(_controller.text);
        },
        icon: const Icon(Icons.add),
        label: const Text('New customer'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              onChanged: _search,
              decoration: const InputDecoration(
                hintText: 'Search by name, account, city, area or phone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? const Center(child: Text('No customers yet. Add the first one.'))
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, i) {
                      final c = _results[i];
                      return ListTile(
                        leading: CircleAvatar(child: Text(c.name[0])),
                        title: Text(c.name),
                        subtitle: Text(
                            '${customerTypeLabel(c.type)} • ${c.accountName} • ${c.city}'),
                        trailing: c.hasVerifiedLocation
                            ? const Icon(Icons.check_circle, color: Colors.green, size: 18)
                            : const Icon(Icons.location_off, color: Colors.grey, size: 18),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => CustomerProfileScreen(customer: c)),
                          );
                          _search(_controller.text);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
