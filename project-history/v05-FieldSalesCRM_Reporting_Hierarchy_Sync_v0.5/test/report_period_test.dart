import 'package:flutter_test/flutter_test.dart';
import 'package:field_sales_crm/models/domain_models.dart';
import 'package:field_sales_crm/services/report_service.dart';

void main() {
  test('empty report returns zero KPIs', () {
    final employee = Employee(
      id: 'K1',
      employeeCode: 'K1',
      fullName: 'KAM',
      role: UserRole.kam,
      state: 'Karnataka',
      hq: 'Bengaluru',
      cities: const ['Bengaluru'],
    );

    final r = ReportService().build(
      filter: ReportFilter(
        period: ReportPeriod.monthly,
        anchorDate: DateTime(2026, 8, 20),
      ),
      employees: [employee],
      visibleEmployeeIds: {'K1'},
      customers: const [],
      visits: const [],
      samples: const [],
      leads: const [],
      orders: const [],
      followUps: const [],
    );

    expect(r.totalVisits, 0);
    expect(r.qualifiedRate, 0);
  });
}
