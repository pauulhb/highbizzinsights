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

  Map<String, Object?> toMap() => {
    'id': id,
    'type': type.name,
    'name': name,
    'account_name': accountName,
    'area': area,
    'city': city,
    'state': state,
    'phone': phone,
    'email': email,
    'potential': potential,
    'latitude': latitude,
    'longitude': longitude,
    'created_by': createdBy,
    'created_at': createdAt.toIso8601String(),
    'sync_status': 'pending',
  };

  static Customer fromMap(Map<String, Object?> m) => Customer(
    id: m['id'] as String,
    type: CustomerType.values.firstWhere((e) => e.name == m['type']),
    name: m['name'] as String,
    accountName: m['account_name'] as String,
    area: m['area'] as String,
    city: m['city'] as String,
    state: m['state'] as String,
    phone: m['phone'] as String?,
    email: m['email'] as String?,
    potential: m['potential'] as String,
    latitude: (m['latitude'] as num).toDouble(),
    longitude: (m['longitude'] as num).toDouble(),
    createdBy: m['created_by'] as String,
    createdAt: DateTime.parse(m['created_at'] as String),
  );
}

class VisitDraft {
  final String id;
  final String customerId;
  final String employeeId;
  final DateTime checkInAt;
  final double checkInLat;
  final double checkInLng;
  final double checkInDistanceM;

  VisitDraft({
    required this.id,
    required this.customerId,
    required this.employeeId,
    required this.checkInAt,
    required this.checkInLat,
    required this.checkInLng,
    required this.checkInDistanceM,
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
  final double checkInDistanceM;
  final double checkOutDistanceM;
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
    required this.checkInDistanceM,
    required this.checkOutDistanceM,
    required this.discussion,
    required this.outcome,
    required this.nextAction,
    required this.qualified,
    this.shortVisitReason,
  });

  int get durationSeconds => checkOutAt.difference(checkInAt).inSeconds;
  int get durationMinutes => durationSeconds ~/ 60;

  Map<String, Object?> toMap() => {
    'id': id,
    'customer_id': customerId,
    'employee_id': employeeId,
    'check_in_at': checkInAt.toIso8601String(),
    'check_out_at': checkOutAt.toIso8601String(),
    'check_in_lat': checkInLat,
    'check_in_lng': checkInLng,
    'check_out_lat': checkOutLat,
    'check_out_lng': checkOutLng,
    'check_in_distance_m': checkInDistanceM,
    'check_out_distance_m': checkOutDistanceM,
    'discussion': discussion,
    'outcome': outcome,
    'next_action': nextAction,
    'qualified': qualified ? 1 : 0,
    'short_visit_reason': shortVisitReason,
    'sync_status': 'pending',
  };
}
