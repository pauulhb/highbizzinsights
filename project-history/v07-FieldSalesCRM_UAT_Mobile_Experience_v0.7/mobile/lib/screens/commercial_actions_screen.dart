import 'package:flutter/material.dart';
import '../models/models.dart';
import '../repositories/commercial_repository.dart';

class CommercialActionsScreen extends StatefulWidget {
  final Customer customer;
  const CommercialActionsScreen({super.key, required this.customer});

  @override
  State<CommercialActionsScreen> createState() => _CommercialActionsScreenState();
}

class _CommercialActionsScreenState extends State<CommercialActionsScreen> {
  final product = TextEditingController();
  final quantity = TextEditingController(text: '1');
  final value = TextEditingController();
  int probability = 50;
  String stage = 'New Lead';

  Future<void> sample() async {
    await CommercialRepository().addSample(
      customerId: widget.customer.id,
      productName: product.text.trim(),
      quantity: int.tryParse(quantity.text) ?? 1,
    );
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sample recorded')));
  }

  Future<void> lead() async {
    await CommercialRepository().addLead(
      customerId: widget.customer.id,
      productName: product.text.trim(),
      expectedValue: double.tryParse(value.text) ?? 0,
      probability: probability,
      stage: stage,
    );
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lead created')));
  }

  Future<void> order() async {
    await CommercialRepository().addOrder(
      customerId: widget.customer.id,
      productName: product.text.trim(),
      quantity: int.tryParse(quantity.text) ?? 0,
      orderValue: double.tryParse(value.text) ?? 0,
    );
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order recorded')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.customer.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: product, decoration: const InputDecoration(labelText: 'Product')),
          const SizedBox(height: 10),
          TextField(controller: quantity, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity')),
          const SizedBox(height: 10),
          TextField(controller: value, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Expected / Order Value')),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            value: probability,
            decoration: const InputDecoration(labelText: 'Lead Probability'),
            items: [25, 50, 70, 90].map((x) => DropdownMenuItem(value: x, child: Text('$x%'))).toList(),
            onChanged: (v) => setState(() => probability = v!),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: stage,
            decoration: const InputDecoration(labelText: 'Lead Stage'),
            items: ['New Lead', 'Product Discussion', 'Sample', 'Quotation', 'Negotiation', 'Expected Order']
                .map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
            onChanged: (v) => setState(() => stage = v!),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: sample, child: const Text('RECORD SAMPLE')),
          const SizedBox(height: 8),
          FilledButton(onPressed: lead, child: const Text('CREATE LEAD')),
          const SizedBox(height: 8),
          FilledButton(onPressed: order, child: const Text('RECORD ORDER')),
        ],
      ),
    );
  }
}
