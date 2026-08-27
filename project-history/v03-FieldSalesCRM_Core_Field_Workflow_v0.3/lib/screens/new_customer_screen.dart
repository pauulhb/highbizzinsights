import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/domain_models.dart';
import '../repositories/customer_repository.dart';
import '../services/location_service.dart';

class NewCustomerScreen extends StatefulWidget {
  const NewCustomerScreen({super.key});

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final repo = CustomerRepository();
  final location = LocationService();

  final name = TextEditingController();
  final account = TextEditingController();
  final area = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();

  CustomerType type = CustomerType.doctor;
  String potential = 'B';
  double? lat;
  double? lng;
  bool busy = false;

  Future<void> pinLocation() async {
    try {
      setState(() => busy = true);
      final p = await location.currentPosition();
      setState(() {
        lat = p.latitude;
        lng = p.longitude;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> save() async {
    if (name.text.trim().isEmpty ||
        account.text.trim().isEmpty ||
        city.text.trim().isEmpty ||
        state.text.trim().isEmpty ||
        lat == null ||
        lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete mandatory fields and pin the GPS location.')),
      );
      return;
    }

    final duplicates = await repo.possibleDuplicates(
      name: name.text,
      city: city.text,
      phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
    );

    if (duplicates.isNotEmpty && mounted) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Possible duplicate found'),
          content: Text(
            '${duplicates.first.name} already exists in ${duplicates.first.city}. '
            'Search the existing customer first unless this is genuinely a different account.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('CREATE ANYWAY'),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    final customer = Customer(
      id: const Uuid().v4(),
      type: type,
      name: name.text.trim(),
      accountName: account.text.trim(),
      area: area.text.trim(),
      city: city.text.trim(),
      state: state.text.trim(),
      phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
      email: email.text.trim().isEmpty ? null : email.text.trim(),
      potential: potential,
      latitude: lat!,
      longitude: lng!,
      createdBy: 'KAM-DEMO',
      createdAt: DateTime.now(),
    );

    await repo.save(customer);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Visit - New Customer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<CustomerType>(
            value: type,
            decoration: const InputDecoration(labelText: 'Customer Type'),
            items: CustomerType.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                .toList(),
            onChanged: (v) => setState(() => type = v!),
          ),
          const SizedBox(height: 12),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Customer / Doctor Name *')),
          const SizedBox(height: 12),
          TextField(controller: account, decoration: const InputDecoration(labelText: 'Hospital / Account Name *')),
          const SizedBox(height: 12),
          TextField(controller: area, decoration: const InputDecoration(labelText: 'Area')),
          const SizedBox(height: 12),
          TextField(controller: city, decoration: const InputDecoration(labelText: 'City *')),
          const SizedBox(height: 12),
          TextField(controller: state, decoration: const InputDecoration(labelText: 'State *')),
          const SizedBox(height: 12),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Contact Number')),
          const SizedBox(height: 12),
          TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: potential,
            decoration: const InputDecoration(labelText: 'Potential'),
            items: ['A+', 'A', 'B', 'C']
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (v) => setState(() => potential = v!),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: busy ? null : pinLocation,
            icon: const Icon(Icons.my_location),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                lat == null ? 'PIN CURRENT GPS LOCATION *' : 'GPS PINNED'
              ),
            ),
          ),
          if (lat != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Lat ${lat!.toStringAsFixed(5)}, Lng ${lng!.toStringAsFixed(5)}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: save,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('SAVE CUSTOMER'),
            ),
          ),
        ],
      ),
    );
  }
}
