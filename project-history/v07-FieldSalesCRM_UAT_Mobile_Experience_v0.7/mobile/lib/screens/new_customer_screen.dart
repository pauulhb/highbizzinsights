import 'package:flutter/material.dart';
import '../repositories/customer_repository.dart';
import '../services/location_service.dart';

class NewCustomerScreen extends StatefulWidget {
  const NewCustomerScreen({super.key});

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final name = TextEditingController();
  final account = TextEditingController();
  final area = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final phone = TextEditingController();
  String type = 'doctor';
  String potential = 'B';
  double? lat;
  double? lng;
  bool busy = false;

  Future<void> pin() async {
    try {
      setState(() => busy = true);
      final p = await LocationService().current();
      setState(() {
        lat = p.latitude;
        lng = p.longitude;
      });
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> save() async {
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pin the current customer location first.')),
      );
      return;
    }

    try {
      setState(() => busy = true);
      await CustomerRepository().create(
        customerType: type,
        name: name.text.trim(),
        accountName: account.text.trim(),
        area: area.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        potential: potential,
        phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
        latitude: lat!,
        longitude: lng!,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Visit - New Customer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: type,
            decoration: const InputDecoration(labelText: 'Customer Type'),
            items: const [
              DropdownMenuItem(value: 'doctor', child: Text('Doctor')),
              DropdownMenuItem(value: 'hospital', child: Text('Hospital')),
              DropdownMenuItem(value: 'distributor', child: Text('Distributor')),
            ],
            onChanged: (v) => setState(() => type = v!),
          ),
          const SizedBox(height: 10),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Customer / Doctor Name *')),
          const SizedBox(height: 10),
          TextField(controller: account, decoration: const InputDecoration(labelText: 'Hospital / Account Name *')),
          const SizedBox(height: 10),
          TextField(controller: area, decoration: const InputDecoration(labelText: 'Area')),
          const SizedBox(height: 10),
          TextField(controller: city, decoration: const InputDecoration(labelText: 'City *')),
          const SizedBox(height: 10),
          TextField(controller: state, decoration: const InputDecoration(labelText: 'State *')),
          const SizedBox(height: 10),
          TextField(controller: phone, decoration: const InputDecoration(labelText: 'Contact Number')),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: potential,
            decoration: const InputDecoration(labelText: 'Potential'),
            items: ['A+', 'A', 'B', 'C']
                .map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (v) => setState(() => potential = v!),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: busy ? null : pin,
            icon: const Icon(Icons.my_location),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(lat == null ? 'PIN CURRENT GPS LOCATION' : 'GPS PINNED'),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: busy ? null : save,
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
