import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/domain_models.dart';
import '../repositories/customer_repository.dart';
import '../services/app_state.dart';
import '../services/location_service.dart';
import '../widgets/location_status_card.dart';

class NewCustomerScreen extends StatefulWidget {
  const NewCustomerScreen({super.key});

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = CustomerRepository();
  final _locationService = LocationService();

  CustomerType _type = CustomerType.doctor;
  String _potential = 'Medium';
  final _name = TextEditingController();
  final _account = TextEditingController();
  final _area = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _phone = TextEditingController();

  double? _lat;
  double? _lng;
  bool _capturing = false;
  bool _saving = false;

  Future<void> _capture() async {
    setState(() => _capturing = true);
    try {
      final position = await _locationService.captureCurrentLocation();
      setState(() {
        _lat = position.latitude;
        _lng = position.longitude;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not capture location: $e')));
      }
    } finally {
      if (mounted) setState(() => _capturing = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPS pinning is mandatory. Capture location first.')),
      );
      return;
    }
    setState(() => _saving = true);
    final user = context.read<AppState>().currentUser;
    await _repository.create(
      name: _name.text,
      type: _type,
      accountName: _account.text,
      area: _area.text,
      city: _city.text,
      state: _state.text,
      phone: _phone.text,
      potential: _potential,
      lat: _lat!,
      lng: _lng!,
      createdBy: user?.id ?? 'unknown',
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New customer')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<CustomerType>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Customer type'),
              items: CustomerType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(customerTypeLabel(t))))
                  .toList(),
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _account,
              decoration: const InputDecoration(labelText: 'Hospital / account'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _area,
                    decoration: const InputDecoration(labelText: 'Area'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _city,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _state,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _potential,
              decoration: const InputDecoration(labelText: 'Potential'),
              items: ['High', 'Medium', 'Low']
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _potential = v ?? _potential),
            ),
            const SizedBox(height: 20),
            LocationStatusCard(
              lat: _lat,
              lng: _lng,
              isCapturing: _capturing,
              onCapture: _capture,
              title: 'Customer location (GPS pin — mandatory)',
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save customer'),
            ),
          ],
        ),
      ),
    );
  }
}
