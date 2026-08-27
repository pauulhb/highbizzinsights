import '../models/domain_models.dart';
import 'local_database.dart';
import 'visit_rules.dart';

enum ReportPeriod { daily, weekly, monthly, quarterly, yearly }

String reportPeriodLabel(ReportPeriod p) {
  switch (p) {
    case ReportPeriod.daily:
      return 'Daily';
    case ReportPeriod.weekly:
      return 'Weekly';
    case ReportPeriod.monthly:
      return 'Monthly';
    case ReportPeriod.quarterly:
      return 'Quarterly';
    case ReportPeriod.yearly:
      return 'Yearly';
  }
}

class DwrSummary {
  DwrSummary({
    required this.totalVisits,
    required this.qualifiedVisits,
    required this.shortVisits,
    required this.locationExceptions,
    required this.newCustomers,
    required this.visits,
  });

  final int totalVisits;
  final int qualifiedVisits;
  final int shortVisits;
  final int locationExceptions;
  final int newCustomers;
  final List<Visit> visits;

  double get qualifiedRate =>
      totalVisits == 0 ? 0 : qualifiedVisits / totalVisits;
}

class ReportService {
  ReportService({LocalDatabase? db}) : _db = db ?? LocalDatabase.instance;

  final LocalDatabase _db;

  DateTime _periodStart(ReportPeriod period, DateTime from) {
    switch (period) {
      case ReportPeriod.daily:
        return DateTime(from.year, from.month, from.day);
      case ReportPeriod.weekly:
        return from.subtract(Duration(days: from.weekday - 1));
      case ReportPeriod.monthly:
        return DateTime(from.year, from.month, 1);
      case ReportPeriod.quarterly:
        final quarterStartMonth = ((from.month - 1) ~/ 3) * 3 + 1;
        return DateTime(from.year, quarterStartMonth, 1);
      case ReportPeriod.yearly:
        return DateTime(from.year, 1, 1);
    }
  }

  Future<DwrSummary> summary(ReportPeriod period, {DateTime? asOf}) async {
    final now = asOf ?? DateTime.now();
    final start = _periodStart(period, now);
    final visits = await _db.visitsBetween(start, now);
    final completed = visits.where((v) => v.isComplete).toList();
    final qualifiedCount =
        completed.where((v) => VisitRules.isQualified(v.duration)).length;
    final exceptions = visits.where((v) => v.isLocationException).length;

    return DwrSummary(
      totalVisits: visits.length,
      qualifiedVisits: qualifiedCount,
      shortVisits: completed.length - qualifiedCount,
      locationExceptions: exceptions,
      newCustomers: 0,
      visits: visits,
    );
  }
}
