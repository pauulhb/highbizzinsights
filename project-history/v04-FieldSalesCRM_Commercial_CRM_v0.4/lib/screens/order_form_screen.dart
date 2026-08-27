import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/domain_models.dart';
import '../services/app_state.dart';

class OrderFormScreen extends StatefulWidget {
  const OrderFormScreen({super.key});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  String? productId;
  final customerId = TextEditingController();
  final quantity = TextEditingController();
  final orderValue = TextEditingController();
  final poNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Record Order')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: customerId,
            decoration: const InputDecoration(labelText: 'Customer ID / Name reference'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: productId,
            decoration: const InputDecoration(labelText: 'Product *'),
            items: state.products.map((p) =>
              DropdownMenuItem(value: p.id, child: Text(p.name))
            ).toList(),
            onChanged: (v) => setState(() => productId = v),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: quantity,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: orderValue,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Order Value'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: poNumber,
            decoration: const InputDecoration(labelText: 'PO Number'),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () {
              if (productId == null) return;
              final p = state.products.firstWhere((e) => e.id == productId);
              state.addOrder(OrderRecord(
                id: const Uuid().v4(),
                customerId: customerId.text.trim(),
                productId: p.id,
                productName: p.name,
                quantity: int.tryParse(quantity.text) ?? 0,
                orderValue: double.tryParse(orderValue.text) ?? 0,
                poNumber: poNumber.text.trim().isEmpty ? null : poNumber.text.trim(),
                orderDate: DateTime.now(),
              ));
              Navigator.pop(context);
            },
            child: const Text('SAVE ORDER'),
          ),
        ],
      ),
    );
  }
}
