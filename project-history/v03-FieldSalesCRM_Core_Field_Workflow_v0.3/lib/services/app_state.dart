import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  String employeeId = 'KAM-DEMO';
  String employeeName = 'Demo KAM';
  String role = 'KAM';

  bool dayStarted = false;
  DateTime? dayStartAt;

  void startDay() {
    dayStarted = true;
    dayStartAt = DateTime.now();
    notifyListeners();
  }
}
