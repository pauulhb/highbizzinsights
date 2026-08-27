import 'package:flutter/material.dart';

class OrderFormScreen extends StatefulWidget {
  const OrderFormScreen({super.key});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _product = TextEditingController();
  final _quantity = TextEditingController();
  final _notes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New order')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _product,
            decoration: const InputDecoration(labelText: 'Product'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _quantity,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.of(context).pop({
              'product': _product.text,
              'quantity': _quantity.text,
              'notes': _notes.text,
            }),
            child: const Text('Save order'),
          ),
        ],
      ),
    );
  }
}
