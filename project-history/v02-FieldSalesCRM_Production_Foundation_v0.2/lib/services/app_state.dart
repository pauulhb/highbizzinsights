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
  final List<Lead> leads = [];
  final List<SampleRecord> samples = [];
  final List<OrderRecord> orders = [];

  void startDay() {
    dayStarted = true;
    dayStartAt = DateTime.now();
    notifyListeners();
  }

  int get qualifiedVisits => visits.where((v) => v.qualified).length;
  int get shortVisits => visits.where((v) => !v.qualified).length;
}
