import '../models/domain_models.dart';

class NotificationItem {
  final String title;
  final String body;
  final DateTime dueAt;

  NotificationItem({
    required this.title,
    required this.body,
    required this.dueAt,
  });
}

class NotificationService {
  List<NotificationItem> dueFollowUpNotifications(
    List<FollowUpRecord> followUps,
    DateTime now,
  ) {
    return followUps
        .where((f) => !f.completed && !f.dueAt.isAfter(now.add(const Duration(days: 1))))
        .map((f) => NotificationItem(
              title: 'Follow-up due',
              body: f.title,
              dueAt: f.dueAt,
            ))
        .toList();
  }
}
