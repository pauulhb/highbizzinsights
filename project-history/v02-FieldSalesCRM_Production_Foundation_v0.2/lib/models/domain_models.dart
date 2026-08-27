enum CustomerType { doctor, hospital, distributor }

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
  final double checkInLat;
  final double checkInLng;
  final double checkOutLat;
  final double checkOutLng;
  final String discussion;
  final String outcome;
  final String nextAction;
  final bool qualified;
  final String? shortVisitReason;

  Visit({
    required this.id,
    required this.customerId,
    required this.employeeId,
    required this.checkInAt,
    required this.checkOutAt,
    required this.checkInLat,
    required this.checkInLng,
    required this.checkOutLat,
    required this.checkOutLng,
    required this.discussion,
    required this.outcome,
    required this.nextAction,
    required this.qualified,
    this.shortVisitReason,
  });

  int get durationMinutes => checkOutAt.difference(checkInAt).inMinutes;
}

class Lead {
  final String id;
  final String customerId;
  final String product;
  final double expectedValue;
  final int probability;
  final String stage;
  final DateTime expectedClosure;

  Lead({
    required this.id,
    required this.customerId,
    required this.product,
    required this.expectedValue,
    required this.probability,
    required this.stage,
    required this.expectedClosure,
  });
}

class SampleRecord {
  final String id;
  final String customerId;
  final String product;
  final String? sku;
  final int quantity;
  final DateTime givenOn;
  final DateTime expectedFeedbackOn;
  final String feedbackStatus;

  SampleRecord({
    required this.id,
    required this.customerId,
    required this.product,
    this.sku,
    required this.quantity,
    required this.givenOn,
    required this.expectedFeedbackOn,
    required this.feedbackStatus,
  });
}

class OrderRecord {
  final String id;
  final String customerId;
  final String product;
  final int quantity;
  final double orderValue;
  final String? poNumber;
  final DateTime orderDate;

  OrderRecord({
    required this.id,
    required this.customerId,
    required this.product,
    required this.quantity,
    required this.orderValue,
    this.poNumber,
    required this.orderDate,
  });
}
