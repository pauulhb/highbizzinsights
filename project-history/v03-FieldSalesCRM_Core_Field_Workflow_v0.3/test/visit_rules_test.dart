import 'package:flutter_test/flutter_test.dart';
import 'package:field_sales_crm/services/visit_rules.dart';

void main() {
  test('14:59 is not qualified', () {
    expect(
      VisitRules.isQualified(const Duration(minutes: 14, seconds: 59)),
      false,
    );
  });

  test('15:00 is qualified', () {
    expect(
      VisitRules.isQualified(const Duration(minutes: 15)),
      true,
    );
  });

  test('200m is inside default geofence', () {
    expect(VisitRules.isWithinGeofence(200), true);
  });

  test('201m is outside default geofence', () {
    expect(VisitRules.isWithinGeofence(201), false);
  });
}
