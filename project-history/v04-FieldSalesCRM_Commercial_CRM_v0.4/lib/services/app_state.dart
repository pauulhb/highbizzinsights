import 'package:flutter/foundation.dart';
import '../models/domain_models.dart';

class AppState extends ChangeNotifier {
  String employeeId = 'KAM-DEMO';
  String employeeName = 'Demo KAM';
  String role = 'KAM';
  bool dayStarted = false;
  DateTime? dayStartAt;

  final List<Customer> customers = [];
  final List<Visit> visits = [];
  final List<Product> products = [
    Product(id: 'P001', code: 'PRD001', name: 'Ureteric Stent'),
    Product(id: 'P002', code: 'PRD002', name: 'Guidewire'),
    Product(id: 'P003', code: 'PRD003', name: 'Stone Basket'),
    Product(id: 'P004', code: 'PRD004', name: 'Nephrostomy Catheter'),
    Product(id: 'P005', code: 'PRD005', name: 'PCNL Access Product'),
  ];
  final List<SampleRecord> samples = [];
  final List<LeadRecord> leads = [];
  final List<OrderRecord> orders = [];
  final List<FollowUpRecord> followUps = [];

  void startDay() {
    dayStarted = true;
    dayStartAt = DateTime.now();
    notifyListeners();
  }

  void addSample(SampleRecord value) {
    samples.add(value);
    notifyListeners();
  }

  void addLead(LeadRecord value) {
    leads.add(value);
    notifyListeners();
  }

  void addOrder(OrderRecord value) {
    orders.add(value);
    notifyListeners();
  }

  void addFollowUp(FollowUpRecord value) {
    followUps.add(value);
    notifyListeners();
  }

  int get qualifiedVisits => visits.where((v) => v.qualified).length;
  int get shortVisits => visits.where((v) => !v.qualified).length;
  double get pipelineValue =>
      leads.where((l) => l.status == 'open').fold(0, (s, l) => s + l.expectedValue);
  double get orderValue => orders.fold(0, (s, o) => s + o.orderValue);
  int get pendingFollowUps => followUps.where((f) => !f.completed).length;
}
