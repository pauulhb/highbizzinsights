import '../models/domain_models.dart';

class ReportFilter {
  final ReportPeriod period;
  final DateTime anchorDate;
  final String? state;
  final String? hq;
  final String? employeeId;

  ReportFilter({
    required this.period,
    required this.anchorDate,
    this.state,
    this.hq,
    this.employeeId,
  });
}

class ReportSnapshot {
  final int totalVisits;
  final int qualifiedVisits;
  final int shortVisits;
  final int uniqueCustomers;
  final int samples;
  final int leads;
  final double pipelineValue;
  final int orders;
  final double orderValue;
  final int followUps;

  ReportSnapshot({
    required this.totalVisits,
    required this.qualifiedVisits,
    required this.shortVisits,
    required this.uniqueCustomers,
    required this.samples,
    required this.leads,
    required this.pipelineValue,
    required this.orders,
    required this.orderValue,
    required this.followUps,
  });

  double get qualifiedRate =>
      totalVisits == 0 ? 0 : qualifiedVisits / totalVisits * 100;
}

class ReportService {
  bool _inPeriod(DateTime date, ReportFilter filter) {
    final a = filter.anchorDate;
    switch (filter.period) {
      case ReportPeriod.daily:
        return date.year == a.year && date.month == a.month && date.day == a.day;
      case ReportPeriod.weekly:
        final start = a.subtract(Duration(days: a.weekday - 1));
        final end = start.add(const Duration(days: 7));
        return !date.isBefore(start) && date.isBefore(end);
      case ReportPeriod.monthly:
        return date.year == a.year && date.month == a.month;
      case ReportPeriod.quarterly:
        final q = ((a.month - 1) ~/ 3);
        final startMonth = q * 3 + 1;
        return date.year == a.year &&
            date.month >= startMonth &&
            date.month <= startMonth + 2;
      case ReportPeriod.yearly:
        return date.year == a.year;
    }
  }

  ReportSnapshot build({
    required ReportFilter filter,
    required List<Employee> employees,
    required Set<String> visibleEmployeeIds,
    required List<Customer> customers,
    required List<Visit> visits,
    required List<SampleRecord> samples,
    required List<LeadRecord> leads,
    required List<OrderRecord> orders,
    required List<FollowUpRecord> followUps,
  }) {
    bool employeeAllowed(String id) {
      if (!visibleEmployeeIds.contains(id)) return false;
      if (filter.employeeId != null && id != filter.employeeId) return false;
      final emp = employees.where((e) => e.id == id).cast<Employee?>().firstOrNull;
      if (emp == null) return false;
      if (filter.state != null && emp.state != filter.state) return false;
      if (filter.hq != null && emp.hq != filter.hq) return false;
      return true;
    }

    final v = visits.where((x) =>
      employeeAllowed(x.employeeId) && _inPeriod(x.checkInAt, filter)
    ).toList();

    final s = samples.where((x) =>
      employeeAllowed(x.employeeId) && _inPeriod(x.givenOn, filter)
    ).toList();

    final l = leads.where((x) =>
      employeeAllowed(x.employeeId) && _inPeriod(x.createdAt, filter)
    ).toList();

    final o = orders.where((x) =>
      employeeAllowed(x.employeeId) && _inPeriod(x.orderDate, filter)
    ).toList();

    final f = followUps.where((x) =>
      employeeAllowed(x.employeeId) && _inPeriod(x.dueAt, filter)
    ).toList();

    return ReportSnapshot(
      totalVisits: v.length,
      qualifiedVisits: v.where((x) => x.qualified).length,
      shortVisits: v.where((x) => !x.qualified).length,
      uniqueCustomers: v.map((x) => x.customerId).toSet().length,
      samples: s.length,
      leads: l.length,
      pipelineValue: l.where((x) => x.status == 'open').fold(0, (sum, x) => sum + x.expectedValue),
      orders: o.length,
      orderValue: o.fold(0, (sum, x) => sum + x.orderValue),
      followUps: f.length,
    );
  }
}

extension FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
