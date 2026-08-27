import 'package:flutter_test/flutter_test.dart';
import 'package:field_sales_crm/services/report_service.dart';

void main() {
  test('qualified rate is zero when there are no visits', () {
    final r = DailyWorkReport(
      date: DateTime(2026, 8, 20),
      totalVisits: 0,
      qualifiedVisits: 0,
      shortVisits: 0,
      newCustomers: 0,
      samples: 0,
      leads: 0,
      pipelineValue: 0,
      orders: 0,
      orderValue: 0,
      followUpsCreated: 0,
    );
    expect(r.qualifiedVisitRate, 0);
  });

  test('qualified rate calculates correctly', () {
    final r = DailyWorkReport(
      date: DateTime(2026, 8, 20),
      totalVisits: 8,
      qualifiedVisits: 6,
      shortVisits: 2,
      newCustomers: 0,
      samples: 0,
      leads: 0,
      pipelineValue: 0,
      orders: 0,
      orderValue: 0,
      followUpsCreated: 0,
    );
    expect(r.qualifiedVisitRate, 75);
  });
}
