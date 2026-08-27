import '../models/domain_models.dart';

class HierarchyService {
  Set<String> visibleEmployeeIds({
    required Employee currentUser,
    required List<Employee> employees,
  }) {
    if (currentUser.role == UserRole.management) {
      return employees.where((e) => e.active).map((e) => e.id).toSet();
    }

    final visible = <String>{currentUser.id};
    bool added = true;

    while (added) {
      added = false;
      for (final e in employees) {
        if (e.managerId != null &&
            visible.contains(e.managerId) &&
            !visible.contains(e.id)) {
          visible.add(e.id);
          added = true;
        }
      }
    }

    return visible;
  }

  List<Employee> directReports({
    required Employee manager,
    required List<Employee> employees,
  }) =>
      employees.where((e) => e.managerId == manager.id && e.active).toList();
}
