import '../models/domain_models.dart';

class DailyWorkReport {
  final DateTime date;
  final int totalVisits;
  final int qualifiedVisits;
  final int shortVisits;
  final int newCustomers;
  final int samples;
  final int leads;
  final double pipelineValue;
  final int orders;
  final double orderValue;
  final int followUpsCreated;

  DailyWorkReport({
    required this.date,
    required this.totalVisits,
    required this.qualifiedVisits,
    required this.shortVisits,
    required this.newCustomers,
    required this.samples,
    required this.leads,
    required this.pipelineValue,
    required this.orders,
    required this.orderValue,
    required this.followUpsCreated,
  });

  double get qualifiedVisitRate =>
      totalVisits == 0 ? 0 : qualifiedVisits / totalVisits * 100;
}

class ReportService {
  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DailyWorkReport buildDwr({
    required DateTime date,
    required List<Customer> customers,
    required List<Visit> visits,
    required List<SampleRecord> samples,
    required List<LeadRecord> leads,
    required List<OrderRecord> orders,
    required List<FollowUpRecord> followUps,
  }) {
    final dayVisits = visits.where((v) => _sameDay(v.checkInAt, date)).toList();
    final dayCustomers = customers.where((c) => _sameDay(c.createdAt, date)).toList();
    final daySamples = samples.where((s) => _sameDay(s.givenOn, date)).toList();
    final dayOrders = orders.where((o) => _sameDay(o.orderDate, date)).toList();
    final dayLeads = leads.where((l) {
      // Prototype lead model does not yet contain createdAt; count all open leads in session.
      return true;
    }).toList();
    final dayFollowUps = followUps.where((f) => _sameDay(f.dueAt, date)).toList();

    return DailyWorkReport(
      date: date,
      totalVisits: dayVisits.length,
      qualifiedVisits: dayVisits.where((v) => v.qualified).length,
      shortVisits: dayVisits.where((v) => !v.qualified).length,
      newCustomers: dayCustomers.length,
      samples: daySamples.length,
      leads: dayLeads.length,
      pipelineValue: dayLeads.fold(0, (s, l) => s + l.expectedValue),
      orders: dayOrders.length,
      orderValue: dayOrders.fold(0, (s, o) => s + o.orderValue),
      followUpsCreated: dayFollowUps.length,
    );
  }
}
