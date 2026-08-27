enum UserRole { kam, areaManager, stateManager, regionalHead, management }
enum CustomerType { doctor, hospital, distributor }
enum ReportPeriod { daily, weekly, monthly, quarterly, yearly }

class Employee {
  final String id;
  final String employeeCode;
  final String fullName;
  final UserRole role;
  final String? managerId;
  final String state;
  final String hq;
  final List<String> cities;
  final bool active;

  Employee({
    required this.id,
    required this.employeeCode,
    required this.fullName,
    required this.role,
    this.managerId,
    required this.state,
    required this.hq,
    required this.cities,
    this.active = true,
  });
}

class Territory {
  final String id;
  final String state;
  final String hq;
  final List<String> cities;
  final String? assignedEmployeeId;

  Territory({
    required this.id,
    required this.state,
    required this.hq,
    required this.cities,
    this.assignedEmployeeId,
  });
}

class CustomerLocation {
  final String id;
  final String customerId;
  final String label;
  final String address;
  final double latitude;
  final double longitude;
  final bool primary;

  CustomerLocation({
    required this.id,
    required this.customerId,
    required this.label,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.primary = false,
  });
}

class Customer {
  final String id;
  final CustomerType type;
  final String name;
  final String accountName;
  final String area;
  final String city;
  final String state;
  final String potential;
  final String assignedEmployeeId;
  final DateTime createdAt;

  Customer({
    required this.id,
    required this.type,
    required this.name,
    required this.accountName,
    required this.area,
    required this.city,
    required this.state,
    required this.potential,
    required this.assignedEmployeeId,
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
  final String outcome;
  final String discussion;
  final String nextAction;
  final String? shortVisitReason;

  Visit({
    required this.id,
    required this.customerId,
    required this.employeeId,
    required this.checkInAt,
    required this.checkOutAt,
    required this.durationSeconds,
    required this.qualified,
    required this.outcome,
    required this.discussion,
    required this.nextAction,
    this.shortVisitReason,
  });
}

class SampleRecord {
  final String id;
  final String customerId;
  final String employeeId;
  final String productName;
  final int quantity;
  final DateTime givenOn;
  final String feedbackStatus;

  SampleRecord({
    required this.id,
    required this.customerId,
    required this.employeeId,
    required this.productName,
    required this.quantity,
    required this.givenOn,
    required this.feedbackStatus,
  });
}

class LeadRecord {
  final String id;
  final String customerId;
  final String employeeId;
  final String productName;
  final double expectedValue;
  final int probability;
  final String stage;
  final DateTime createdAt;
  final String status;

  LeadRecord({
    required this.id,
    required this.customerId,
    required this.employeeId,
    required this.productName,
    required this.expectedValue,
    required this.probability,
    required this.stage,
    required this.createdAt,
    this.status = 'open',
  });
}

class OrderRecord {
  final String id;
  final String customerId;
  final String employeeId;
  final String productName;
  final int quantity;
  final double orderValue;
  final DateTime orderDate;

  OrderRecord({
    required this.id,
    required this.customerId,
    required this.employeeId,
    required this.productName,
    required this.quantity,
    required this.orderValue,
    required this.orderDate,
  });
}

class FollowUpRecord {
  final String id;
  final String customerId;
  final String employeeId;
  final String title;
  final DateTime dueAt;
  bool completed;

  FollowUpRecord({
    required this.id,
    required this.customerId,
    required this.employeeId,
    required this.title,
    required this.dueAt,
    this.completed = false,
  });
}

class AuditEvent {
  final String id;
  final String employeeId;
  final String entityType;
  final String entityId;
  final String action;
  final DateTime occurredAt;
  final String summary;

  AuditEvent({
    required this.id,
    required this.employeeId,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.occurredAt,
    required this.summary,
  });
}
