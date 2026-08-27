import '../models/domain_models.dart';

class TimelineItem {
  final DateTime at;
  final String type;
  final String title;
  final String detail;

  TimelineItem({
    required this.at,
    required this.type,
    required this.title,
    required this.detail,
  });
}

class TimelineService {
  List<TimelineItem> customerTimeline({
    required String customerId,
    required List<Visit> visits,
    required List<SampleRecord> samples,
    required List<LeadRecord> leads,
    required List<OrderRecord> orders,
    required List<FollowUpRecord> followUps,
  }) {
    final items = <TimelineItem>[];

    for (final v in visits.where((x) => x.customerId == customerId)) {
      items.add(TimelineItem(
        at: v.checkOutAt,
        type: 'visit',
        title: v.qualified ? 'Qualified Visit' : 'Short Visit',
        detail: '${v.outcome}: ${v.discussion}',
      ));
    }

    for (final s in samples.where((x) => x.customerId == customerId)) {
      items.add(TimelineItem(
        at: s.givenOn,
        type: 'sample',
        title: 'Sample: ${s.productName}',
        detail: '${s.quantity} unit(s) • ${s.feedbackStatus}',
      ));
    }

    for (final l in leads.where((x) => x.customerId == customerId)) {
      items.add(TimelineItem(
        at: l.createdAt,
        type: 'lead',
        title: 'Lead: ${l.productName}',
        detail: '${l.stage} • ₹${l.expectedValue.toStringAsFixed(0)} • ${l.probability}%',
      ));
    }

    for (final o in orders.where((x) => x.customerId == customerId)) {
      items.add(TimelineItem(
        at: o.orderDate,
        type: 'order',
        title: 'Order: ${o.productName}',
        detail: '${o.quantity} unit(s) • ₹${o.orderValue.toStringAsFixed(0)}',
      ));
    }

    for (final f in followUps.where((x) => x.customerId == customerId)) {
      items.add(TimelineItem(
        at: f.dueAt,
        type: 'followup',
        title: f.completed ? 'Completed Follow-up' : 'Pending Follow-up',
        detail: f.title,
      ));
    }

    items.sort((a, b) => b.at.compareTo(a.at));
    return items;
  }
}
