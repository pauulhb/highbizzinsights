import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'customer_search_screen.dart';
import 'new_customer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Sales CRM'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_none),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Today',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: state.dayStarted ? null : state.startDay,
            icon: const Icon(Icons.play_arrow),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(state.dayStarted ? 'DAY STARTED' : 'START DAY'),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewCustomerScreen()),
            ),
            icon: const Icon(Icons.person_add_alt_1),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('NEW CUSTOMER'),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomerSearchScreen()),
            ),
            icon: const Icon(Icons.search),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('VISIT EXISTING CUSTOMER'),
            ),
          ),
          const SizedBox(height: 18),
          const Card(
            child: ListTile(
              leading: Icon(Icons.timer_outlined),
              title: Text('15-minute productive visit rule'),
              subtitle: Text(
                'Short visits are saved separately and require a reason.',
              ),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('GPS-verified customer visits'),
              subtitle: Text(
                'Check-in and check-out use the device location and registered customer pin.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
