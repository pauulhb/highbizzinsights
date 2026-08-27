enum CustomerType { doctor, hospital, distributor }

extension CustomerTypeLabel on CustomerType {
  String get label {
    switch (this) {
      case CustomerType.doctor:
        return 'Doctor';
      case CustomerType.hospital:
        return 'Hospital';
      case CustomerType.distributor:
        return 'Distributor';
    }
  }
}

class Customer {
  final String id;
  final CustomerType type;
  final String name;
  final String accountName;
  final String area;
  final String city;
  final String state;
  final String? phone;
  final String? email;
  final String potential;
  final double latitude;
  final double longitude;
  final String createdBy;
  final DateTime createdAt;

  Customer({
    required this.id,
    required this.type,
    required this.name,
    required this.accountName,
    required this.area,
    required this.city,
    required this.state,
    this.phone,
    this.email,
    required this.potential,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.createdAt,
  });
}

class Visit {
  final String id;
  final String customerId;
  final String employeeId;
  final DateTime checkInAt;
  final DateTime checkOutAt;
  final int durationSeconds;
  final bool qualified;
  final String discussion;
  final String outcome;
  final String nextAction;
  final DateTime? nextActionDueAt;
  final String? shortVisitReason;

  Visit({
    required this.id,
    required this.customerId,
    required this.employeeId,
    required this.checkInAt,
    required this.checkOutAt,
    required this.durationSeconds,
    required this.qualified,
    required this.discussion,
    required this.outcome,
    required this.nextAction,
    this.nextActionDueAt,
    this.shortVisitReason,
  });
}

class Product {
  final String id;
  final String code;
  final String name;
  final bool active;

  Product({
    required this.id,
    required this.code,
    required this.name,
    this.active = true,
  });
}

class SampleRecord {
  final String id;
  final String customerId;
  final String productId;
  final String productName;
  final int quantity;
  final DateTime givenOn;
  final DateTime? expectedFeedbackOn;
  final String feedbackStatus;
  final String? feedbackNotes;

  SampleRecord({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.givenOn,
    this.expectedFeedbackOn,
    required this.feedbackStatus,
    this.feedbackNotes,
  });
}

class LeadRecord {
  final String id;
  final String customerId;
  final String productId;
  final String productName;
  final double expectedValue;
  final int probability;
  final String stage;
  final DateTime? expectedClosure;
  final String nextAction;
  final DateTime? nextActionDueAt;
  final String status;

  LeadRecord({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.productName,
    required this.expectedValue,
    required this.probability,
    required this.stage,
    this.expectedClosure,
    required this.nextAction,
    this.nextActionDueAt,
    this.status = 'open',
  });
}

class OrderRecord {
  final String id;
  final String customerId;
  final String productId;
  final String productName;
  final int quantity;
  final double orderValue;
  final String? poNumber;
  final DateTime orderDate;

  OrderRecord({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.orderValue,
    this.poNumber,
    required this.orderDate,
  });
}

class FollowUpRecord {
  final String id;
  final String customerId;
  final String title;
  final DateTime dueAt;
  final String sourceType;
  final String sourceId;
  bool completed;

  FollowUpRecord({
    required this.id,
    required this.customerId,
    required this.title,
    required this.dueAt,
    required this.sourceType,
    required this.sourceId,
    this.completed = false,
  });
}
