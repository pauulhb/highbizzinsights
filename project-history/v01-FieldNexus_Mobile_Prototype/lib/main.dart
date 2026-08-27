
import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const FieldNexusApp());
}

class FieldNexusApp extends StatelessWidget {
  const FieldNexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FieldNexus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF183B66)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F8FB),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class AppState {
  static bool dayStarted = false;
  static final List<Customer> customers = [
    Customer(
      id: 'C001',
      type: CustomerType.doctor,
      name: 'Dr. Rajesh Kumar',
      account: 'City Care Hospital',
      city: 'Bengaluru',
      area: 'Indiranagar',
      phone: '9876543210',
      potential: 'A',
      latitude: 12.9784,
      longitude: 77.6408,
    ),
    Customer(
      id: 'C002',
      type: CustomerType.hospital,
      name: 'Metro Urology Centre',
      account: 'Metro Urology Centre',
      city: 'Bengaluru',
      area: 'Jayanagar',
      phone: '08040000000',
      potential: 'A+',
      latitude: 12.9250,
      longitude: 77.5938,
    ),
  ];

  static final List<VisitRecord> visits = [];
  static final List<LeadRecord> leads = [];
  static final List<OrderRecord> orders = [];
}

enum CustomerType { doctor, hospital, distributor }

extension CustomerTypeX on CustomerType {
  String get label {
    switch (this) {
      case CustomerType.doctor:
        return 'Doctor';
      case CustomerType.hospital:
        return 'Hospital';
      case CustomerType.distributor:
        return 'Distributor';
    }
  }
}

class Customer {
  final String id;
  final CustomerType type;
  final String name;
  final String account;
  final String city;
  final String area;
  final String phone;
  final String potential;
  final double latitude;
  final double longitude;

  Customer({
    required this.id,
    required this.type,
    required this.name,
    required this.account,
    required this.city,
    required this.area,
    required this.phone,
    required this.potential,
    required this.latitude,
    required this.longitude,
  });
}

class VisitRecord {
  final Customer customer;
  final DateTime checkIn;
  final DateTime checkOut;
  final String discussion;
  final String outcome;
  final String nextAction;
  final bool sampleGiven;
  final String sampleFeedback;
  final bool qualified;
  final String? shortVisitReason;

  VisitRecord({
    required this.customer,
    required this.checkIn,
    required this.checkOut,
    required this.discussion,
    required this.outcome,
    required this.nextAction,
    required this.sampleGiven,
    required this.sampleFeedback,
    required this.qualified,
    this.shortVisitReason,
  });

  Duration get duration => checkOut.difference(checkIn);
}

class LeadRecord {
  final String customerName;
  final String product;
  final double value;
  final int probability;
  final String stage;

  LeadRecord({
    required this.customerName,
    required this.product,
    required this.value,
    required this.probability,
    required this.stage,
  });
}

class OrderRecord {
  final String customerName;
  final String product;
  final int quantity;
  final double value;

  OrderRecord({
    required this.customerName,
    required this.product,
    required this.quantity,
    required this.value,
  });
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String role = 'KAM / Sales Executive';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.hub_outlined, size: 58),
                      const SizedBox(height: 14),
                      const Text(
                        'FieldNexus',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Field Sales & Customer Intelligence',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Employee ID / Mobile',
                        ),
                      ),
                      const SizedBox(height: 12),
                      const TextField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password / OTP'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: role,
                        decoration: const InputDecoration(labelText: 'Prototype role'),
                        items: const [
                          DropdownMenuItem(
                            value: 'KAM / Sales Executive',
                            child: Text('KAM / Sales Executive'),
                          ),
                          DropdownMenuItem(
                            value: 'Manager / Management',
                            child: Text('Manager / Management'),
                          ),
                        ],
                        onChanged: (value) => setState(() => role = value!),
                      ),
                      const SizedBox(height: 18),
                      FilledButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => role == 'Manager / Management'
                                  ? const ManagerDashboard()
                                  : const KamHomeScreen(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('LOGIN'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KamHomeScreen extends StatefulWidget {
  const KamHomeScreen({super.key});

  @override
  State<KamHomeScreen> createState() => _KamHomeScreenState();
}

class _KamHomeScreenState extends State<KamHomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeTab(onRefresh: () => setState(() {})),
      const CustomersScreen(),
      const VisitsScreen(),
      const LeadsScreen(),
      const MoreScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('FieldNexus'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          )
        ],
      ),
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people_outline), label: 'Customers'),
          NavigationDestination(icon: Icon(Icons.pin_drop_outlined), label: 'Visits'),
          NavigationDestination(icon: Icon(Icons.trending_up), label: 'Leads'),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final VoidCallback onRefresh;
  const HomeTab({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todaysVisits = AppState.visits.where((v) =>
      v.checkIn.year == today.year &&
      v.checkIn.month == today.month &&
      v.checkIn.day == today.day).toList();
    final qualified = todaysVisits.where((v) => v.qualified).length;
    final short = todaysVisits.length - qualified;
    final todayOrders = AppState.orders.fold<double>(0, (sum, o) => sum + o.value);
    final leadsValue = AppState.leads.fold<double>(0, (sum, l) => sum + l.value);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Good day, KAM',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        const Text('Bengaluru HQ | South Region'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            KpiCard(label: 'Visits', value: '${todaysVisits.length}'),
            KpiCard(label: 'Qualified', value: '$qualified'),
            KpiCard(label: 'Short', value: '$short'),
            KpiCard(label: 'Orders', value: '₹${todayOrders.toStringAsFixed(0)}'),
            KpiCard(label: 'Pipeline', value: '₹${leadsValue.toStringAsFixed(0)}'),
          ],
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          icon: Icon(AppState.dayStarted ? Icons.check_circle : Icons.play_arrow),
          onPressed: () {
            AppState.dayStarted = true;
            onRefresh();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Day started. GPS start point recorded in production build.')),
            );
          },
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(AppState.dayStarted ? 'DAY STARTED' : 'START DAY'),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          icon: const Icon(Icons.person_add_alt_1),
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddCustomerScreen()));
            onRefresh();
          },
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Text('NEW CUSTOMER'),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          icon: const Icon(Icons.search),
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomersScreen(selectForVisit: true)));
            onRefresh();
          },
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Text('VISIT CUSTOMER'),
          ),
        ),
        const SizedBox(height: 18),
        const ListTile(
          tileColor: Colors.white,
          leading: Icon(Icons.schedule),
          title: Text('Follow-ups due today'),
          subtitle: Text('Prototype: follow-up scheduler will be connected to visit outcomes.'),
          trailing: Text('5'),
        ),
      ],
    );
  }
}

class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  const KpiCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomersScreen extends StatefulWidget {
  final bool selectForVisit;
  const CustomersScreen({super.key, this.selectForVisit = false});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final matches = AppState.customers.where((c) {
      final q = query.toLowerCase();
      return c.name.toLowerCase().contains(q) ||
          c.account.toLowerCase().contains(q) ||
          c.city.toLowerCase().contains(q) ||
          c.area.toLowerCase().contains(q) ||
          c.phone.contains(query);
    }).toList();

    return Scaffold(
      appBar: widget.selectForVisit ? AppBar(title: const Text('Select Customer')) : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddCustomerScreen()));
          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search doctor, hospital, distributor, city or phone',
            ),
            onChanged: (v) => setState(() => query = v),
          ),
          const SizedBox(height: 14),
          ...matches.map((c) => Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(c.type.label.substring(0,1))),
              title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text('${c.account}\n${c.area}, ${c.city} • Potential ${c.potential}'),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CustomerDetailScreen(customer: c)),
                );
              },
            ),
          )),
        ],
      ),
    );
  }
}

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final name = TextEditingController();
  final account = TextEditingController();
  final city = TextEditingController(text: 'Bengaluru');
  final area = TextEditingController();
  final phone = TextEditingController();
  CustomerType type = CustomerType.doctor;
  String potential = 'B';
  bool locationPinned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Customer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<CustomerType>(
            value: type,
            decoration: const InputDecoration(labelText: 'Customer type'),
            items: CustomerType.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                .toList(),
            onChanged: (v) => setState(() => type = v!),
          ),
          const SizedBox(height: 12),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Customer / Doctor name *')),
          const SizedBox(height: 12),
          TextField(controller: account, decoration: const InputDecoration(labelText: 'Hospital / Account name *')),
          const SizedBox(height: 12),
          TextField(controller: area, decoration: const InputDecoration(labelText: 'Area *')),
          const SizedBox(height: 12),
          TextField(controller: city, decoration: const InputDecoration(labelText: 'City *')),
          const SizedBox(height: 12),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Contact number')),
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
            icon: Icon(locationPinned ? Icons.location_on : Icons.my_location),
            onPressed: () => setState(() => locationPinned = true),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(locationPinned ? 'LOCATION PINNED' : 'PIN CURRENT LOCATION *'),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Production build: this action will capture device GPS coordinates and validate location permission.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              if (name.text.trim().isEmpty || account.text.trim().isEmpty || area.text.trim().isEmpty || !locationPinned) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Complete mandatory fields and pin the customer location.')),
                );
                return;
              }

              final duplicate = AppState.customers.any((c) =>
                c.name.toLowerCase().trim() == name.text.toLowerCase().trim() &&
                c.city.toLowerCase().trim() == city.text.toLowerCase().trim()
              );
              if (duplicate) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Possible duplicate customer found. Please search existing records first.')),
                );
                return;
              }

              AppState.customers.add(Customer(
                id: 'C${(AppState.customers.length + 1).toString().padLeft(3,'0')}',
                type: type,
                name: name.text.trim(),
                account: account.text.trim(),
                city: city.text.trim(),
                area: area.text.trim(),
                phone: phone.text.trim(),
                potential: potential,
                latitude: 12.9716,
                longitude: 77.5946,
              ));
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('SAVE CUSTOMER'),
            ),
          )
        ],
      ),
    );
  }
}

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;
  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final history = AppState.visits.where((v) => v.customer.id == customer.id).toList().reversed.toList();
    return Scaffold(
      appBar: AppBar(title: Text(customer.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(customer.account, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text('${customer.type.label} • ${customer.area}, ${customer.city}\nPotential ${customer.potential}'),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VisitSessionScreen(customer: customer)),
              );
            },
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('CHECK-IN & START VISIT'),
            ),
          ),
          const SizedBox(height: 18),
          const Text('Visit history', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
          const SizedBox(height: 8),
          if (history.isEmpty)
            const Card(child: ListTile(title: Text('No previous visit recorded.')))
          else
            ...history.map((v) => Card(
              child: ListTile(
                title: Text(v.qualified ? 'Qualified Visit' : 'Short Visit'),
                subtitle: Text(
                  '${v.duration.inMinutes} min • ${v.outcome}\n${v.discussion}',
                ),
                isThreeLine: true,
              ),
            ))
        ],
      ),
    );
  }
}

class VisitSessionScreen extends StatefulWidget {
  final Customer customer;
  const VisitSessionScreen({super.key, required this.customer});

  @override
  State<VisitSessionScreen> createState() => _VisitSessionScreenState();
}

class _VisitSessionScreenState extends State<VisitSessionScreen> {
  late DateTime checkIn;
  Timer? timer;
  Duration elapsed = Duration.zero;
  static const minimumQualifiedDuration = Duration(minutes: 15);

  final discussion = TextEditingController();
  final nextAction = TextEditingController();
  String outcome = 'Product Discussion';
  bool sampleGiven = false;
  String sampleFeedback = 'Awaiting Feedback';
  String shortReason = '';

  @override
  void initState() {
    super.initState();
    checkIn = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => elapsed = DateTime.now().difference(checkIn));
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    discussion.dispose();
    nextAction.dispose();
    super.dispose();
  }

  String mmss(Duration d) {
    final m = d.inMinutes.toString().padLeft(2,'0');
    final s = (d.inSeconds % 60).toString().padLeft(2,'0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final qualified = elapsed >= minimumQualifiedDuration;
    final remaining = minimumQualifiedDuration - elapsed;
    return Scaffold(
      appBar: AppBar(title: const Text('Active Visit')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Text(widget.customer.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  Text('${widget.customer.account} • ${widget.customer.city}'),
                  const SizedBox(height: 14),
                  Text(mmss(elapsed), style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                    qualified
                      ? 'Qualified visit duration reached'
                      : '${mmss(remaining.isNegative ? Duration.zero : remaining)} remaining for a qualified visit',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Chip(
                    avatar: Icon(qualified ? Icons.verified : Icons.timelapse, size: 18),
                    label: Text(qualified ? 'QUALIFIED ≥ 15 MIN' : 'IN PROGRESS'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: outcome,
            decoration: const InputDecoration(labelText: 'Visit purpose / outcome'),
            items: [
              'Product Discussion',
              'Product Demonstration',
              'Sample Follow-up',
              'Quotation Discussion',
              'Order Follow-up',
              'Distributor Meeting',
              'Relationship Visit',
            ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(() => outcome = v!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: discussion,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Discussion / meeting notes *'),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: sampleGiven,
            onChanged: (v) => setState(() => sampleGiven = v),
            title: const Text('Sample given'),
            tileColor: Colors.white,
          ),
          if (sampleGiven) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: sampleFeedback,
              decoration: const InputDecoration(labelText: 'Sample status / feedback'),
              items: ['Awaiting Feedback', 'Positive', 'Neutral', 'Negative', 'Not Used Yet']
                  .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => sampleFeedback = v!),
            )
          ],
          const SizedBox(height: 12),
          TextField(
            controller: nextAction,
            decoration: const InputDecoration(labelText: 'Next action / follow-up *'),
          ),
          if (!qualified) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: shortReason.isEmpty ? null : shortReason,
              decoration: const InputDecoration(labelText: 'Reason if checking out before 15 min *'),
              items: [
                'Doctor unavailable',
                'Emergency / clinical priority',
                'Purchase team unavailable',
                'Sample / document drop only',
                'Customer requested short meeting',
                'Other',
              ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => shortReason = v!),
            )
          ],
          const SizedBox(height: 18),
          FilledButton.icon(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final end = DateTime.now();
              final isQualified = end.difference(checkIn) >= minimumQualifiedDuration;
              if (discussion.text.trim().isEmpty || nextAction.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Discussion and next action are mandatory.')),
                );
                return;
              }
              if (!isQualified && shortReason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Select a reason for a short visit.')),
                );
                return;
              }

              AppState.visits.add(VisitRecord(
                customer: widget.customer,
                checkIn: checkIn,
                checkOut: end,
                discussion: discussion.text.trim(),
                outcome: outcome,
                nextAction: nextAction.text.trim(),
                sampleGiven: sampleGiven,
                sampleFeedback: sampleGiven ? sampleFeedback : 'Not Applicable',
                qualified: isQualified,
                shortVisitReason: isQualified ? null : shortReason,
              ));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isQualified
                  ? 'Qualified visit saved.'
                  : 'Short visit saved and excluded from productive-call KPI.')),
              );
            },
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('CHECK-OUT & SAVE VISIT'),
            ),
          ),
        ],
      ),
    );
  }
}

class VisitsScreen extends StatelessWidget {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Visit Reports', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        if (AppState.visits.isEmpty)
          const Card(child: ListTile(title: Text('No visits recorded in this prototype session.')))
        else
          ...AppState.visits.reversed.map((v) => Card(
            child: ListTile(
              leading: Icon(v.qualified ? Icons.verified_outlined : Icons.warning_amber),
              title: Text(v.customer.name),
              subtitle: Text('${v.duration.inMinutes} min • ${v.outcome}\n${v.qualified ? 'Qualified' : 'Short Visit: ${v.shortVisitReason}'}'),
              isThreeLine: true,
            ),
          )),
      ],
    );
  }
}

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  @override
  Widget build(BuildContext context) {
    final total = AppState.leads.fold<double>(0, (s, l) => s + l.value);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Pipeline ₹${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        FilledButton.icon(
          icon: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddLeadScreen()));
            setState(() {});
          },
          label: const Text('CREATE LEAD'),
        ),
        const SizedBox(height: 12),
        ...AppState.leads.map((l) => Card(
          child: ListTile(
            title: Text(l.customerName),
            subtitle: Text('${l.product} • ${l.stage} • ${l.probability}% probability'),
            trailing: Text('₹${l.value.toStringAsFixed(0)}'),
          ),
        ))
      ],
    );
  }
}

class AddLeadScreen extends StatefulWidget {
  const AddLeadScreen({super.key});

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  final customer = TextEditingController();
  final product = TextEditingController();
  final value = TextEditingController();
  int probability = 50;
  String stage = 'New Lead';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Lead')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: customer, decoration: const InputDecoration(labelText: 'Customer')),
          const SizedBox(height: 12),
          TextField(controller: product, decoration: const InputDecoration(labelText: 'Product')),
          const SizedBox(height: 12),
          TextField(controller: value, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Expected value')),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: probability,
            decoration: const InputDecoration(labelText: 'Probability'),
            items: [25, 50, 70, 90].map((p) => DropdownMenuItem(value: p, child: Text('$p%'))).toList(),
            onChanged: (v) => setState(() => probability = v!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: stage,
            decoration: const InputDecoration(labelText: 'Stage'),
            items: ['New Lead', 'Product Discussion', 'Sample', 'Quotation', 'Negotiation', 'Expected Order']
                .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => stage = v!),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () {
              AppState.leads.add(LeadRecord(
                customerName: customer.text.trim(),
                product: product.text.trim(),
                value: double.tryParse(value.text) ?? 0,
                probability: probability,
                stage: stage,
              ));
              Navigator.pop(context);
            },
            child: const Text('SAVE LEAD'),
          )
        ],
      ),
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 8),
        const ListTile(
          leading: Icon(Icons.assessment_outlined),
          title: Text('Daily / Weekly / Monthly Reports'),
          subtitle: Text('Generated automatically from visits, leads, samples and orders'),
        ),
        ListTile(
          leading: const Icon(Icons.admin_panel_settings_outlined),
          title: const Text('Manager Dashboard'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ManagerDashboard()));
          },
        ),
        const ListTile(
          leading: Icon(Icons.cloud_off_outlined),
          title: Text('Offline Sync'),
          subtitle: Text('Production build will queue records until network returns'),
        ),
        const ListTile(
          leading: Icon(Icons.security_outlined),
          title: Text('Audit & Security'),
          subtitle: Text('Role access, edit history and device security planned'),
        ),
      ],
    );
  }
}

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final qualified = AppState.visits.where((v) => v.qualified).length;
    final short = AppState.visits.length - qualified;
    final avgMinutes = AppState.visits.isEmpty
        ? 0.0
        : AppState.visits.map((v) => v.duration.inSeconds).reduce((a,b) => a+b) / 60 / AppState.visits.length;
    final leadValue = AppState.leads.fold<double>(0, (sum, l) => sum + l.value);
    final orderValue = AppState.orders.fold<double>(0, (sum, o) => sum + o.value);

    return Scaffold(
      appBar: AppBar(title: const Text('Management Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('South Region Snapshot', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              KpiCard(label: 'Total Visits', value: '${AppState.visits.length}'),
              KpiCard(label: 'Qualified', value: '$qualified'),
              KpiCard(label: 'Short Visits', value: '$short'),
              KpiCard(label: 'Avg Min', value: avgMinutes.toStringAsFixed(1)),
              KpiCard(label: 'Pipeline', value: '₹${leadValue.toStringAsFixed(0)}'),
              KpiCard(label: 'Orders', value: '₹${orderValue.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.rule),
              title: const Text('15-minute productivity rule'),
              subtitle: Text(
                '$qualified visits qualify for productive-call KPI. $short visits are retained separately for review.',
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: Icon(Icons.account_tree_outlined),
              title: Text('Planned drill-down'),
              subtitle: Text('South India → State → HQ → KAM → Customer → Visit'),
            ),
          ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text('Customer & coverage map'),
              subtitle: Text('GPS customer pins, recent coverage, high-potential accounts and exceptions'),
            ),
          ),
        ],
      ),
    );
  }
}
