import 'package:flutter/foundation.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  EmployeeSession? session;
  bool dayStarted = false;

  void setSession(EmployeeSession value) {
    session = value;
    notifyListeners();
  }

  void startDay() {
    dayStarted = true;
    notifyListeners();
  }
}
