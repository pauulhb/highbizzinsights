import 'package:flutter_test/flutter_test.dart';
import 'package:field_sales_crm/models/domain_models.dart';
import 'package:field_sales_crm/services/hierarchy_service.dart';

void main() {
  test('manager sees recursive team', () {
    final manager = Employee(
      id: 'M1',
      employeeCode: 'M1',
      fullName: 'Manager',
      role: UserRole.areaManager,
      state: 'Karnataka',
      hq: 'Bengaluru',
      cities: const ['Bengaluru'],
    );

    final kam = Employee(
      id: 'K1',
      employeeCode: 'K1',
      fullName: 'KAM',
      role: UserRole.kam,
      managerId: 'M1',
      state: 'Karnataka',
      hq: 'Bengaluru',
      cities: const ['Bengaluru'],
    );

    final visible = HierarchyService().visibleEmployeeIds(
      currentUser: manager,
      employees: [manager, kam],
    );

    expect(visible.contains('M1'), true);
    expect(visible.contains('K1'), true);
  });
}
