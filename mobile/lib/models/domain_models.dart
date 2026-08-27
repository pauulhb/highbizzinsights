enum CustomerType { doctor, hospital, distributor }

enum UserRole { kam, areaManager, stateManager, regionalHead, management, admin }

enum CommercialActionType { sample, feedback, lead, order, followUp }

String customerTypeLabel(CustomerType t) {
  switch (t) {
    case CustomerType.doctor:
      return 'Doctor';
    case CustomerType.hospital:
      return 'Hospital';
    case CustomerType.distributor:
      return 'Distributor';
  }
}

CustomerType customerTypeFromString(String v) {
  return CustomerType.values.firstWhere(
    (e) => e.name == v,
    orElse: () => CustomerType.doctor,
  );
}

String userRoleLabel(UserRole r) {
  switch (r) {
    case UserRole.kam:
      return 'KAM / Sales Executive';
    case UserRole.areaManager:
      return 'Area Manager';
    case UserRole.stateManager:
      return 'State Manager';
    case UserRole.regionalHead:
      return 'Regional / South Head';
    case UserRole.management:
      return 'Management';
    case UserRole.admin:
      return 'Admin';
  }
}

UserRole userRoleFromString(String v) {
  return UserRole.values.firstWhere(
    (e) => e.name == v,
    orElse: () => UserRole.kam,
  );
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String region;
  final String state;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.region = 'South',
    this.state = 'Karnataka',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role.name,
        'region': region,
        'state': state,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        role: userRoleFromString(json['role'] as String? ?? 'kam'),
        region: json['region'] as String? ?? 'South',
        state: json['state'] as String? ?? 'Karnataka',
      );
}

class Customer {
  final String id;
  final String name;
  final CustomerType type;
  final String accountName;
  final String area;
  final String city;
  final String state;
  final String phone;
  final String potential;
  final double? lat;
  final double? lng;
  final DateTime? locationVerifiedAt;
  final String createdBy;
  final DateTime createdAt;
  final bool synced;

  Customer({
    required this.id,
    required this.name,
    required this.type,
    required this.accountName,
    required this.area,
    required this.city,
    required this.state,
    required this.phone,
    required this.potential,
    this.lat,
    this.lng,
    this.locationVerifiedAt,
    required this.createdBy,
    required this.createdAt,
    this.synced = false,
  });

  bool get hasVerifiedLocation => lat != null && lng != null;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': type.name,
        'account_name': accountName,
        'area': area,
        'city': city,
        'state': state,
        'phone': phone,
        'potential': potential,
        'lat': lat,
        'lng': lng,
        'location_verified_at': locationVerifiedAt?.toIso8601String(),
        'created_by': createdBy,
        'created_at': createdAt.toIso8601String(),
        'synced': synced ? 1 : 0,
      };

  factory Customer.fromMap(Map<String, dynamic> m) => Customer(
        id: m['id'] as String,
        name: m['name'] as String,
        type: customerTypeFromString(m['type'] as String? ?? 'doctor'),
        accountName: m['account_name'] as String? ?? '',
        area: m['area'] as String? ?? '',
        city: m['city'] as String? ?? '',
        state: m['state'] as String? ?? '',
        phone: m['phone'] as String? ?? '',
        potential: m['potential'] as String? ?? 'Medium',
        lat: (m['lat'] as num?)?.toDouble(),
        lng: (m['lng'] as num?)?.toDouble(),
        locationVerifiedAt: m['location_verified_at'] != null
            ? DateTime.tryParse(m['location_verified_at'] as String)
            : null,
        createdBy: m['created_by'] as String? ?? '',
        createdAt:
            DateTime.tryParse(m['created_at'] as String? ?? '') ?? DateTime.now(),
        synced: (m['synced'] as int? ?? 0) == 1,
      );

  Customer copyWith({double? lat, double? lng, DateTime? locationVerifiedAt}) {
    return Customer(
      id: id,
      name: name,
      type: type,
      accountName: accountName,
      area: area,
      city: city,
      state: state,
      phone: phone,
      potential: potential,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      locationVerifiedAt: locationVerifiedAt ?? this.locationVerifiedAt,
      createdBy: createdBy,
      createdAt: createdAt,
      synced: synced,
    );
  }
}

class Visit {
  final String id;
  final String customerId;
  final String kamId;
  final DateTime checkInAt;
  DateTime? checkOutAt;
  final double checkInLat;
  final double checkInLng;
  double? checkOutLat;
  double? checkOutLng;
  String discussionNotes;
  String nextAction;
  bool isLocationException;
  bool synced;

  Visit({
    required this.id,
    required this.customerId,
    required this.kamId,
    required this.checkInAt,
    this.checkOutAt,
    required this.checkInLat,
    required this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
    this.discussionNotes = '',
    this.nextAction = '',
    this.isLocationException = false,
    this.synced = false,
  });

  Duration get duration {
    final end = checkOutAt ?? DateTime.now();
    return end.difference(checkInAt);
  }

  bool get isQualified => checkOutAt != null && duration.inSeconds >= 900;
  bool get isComplete => checkOutAt != null;

  Map<String, dynamic> toMap() => {
        'id': id,
        'customer_id': customerId,
        'kam_id': kamId,
        'check_in_at': checkInAt.toIso8601String(),
        'check_out_at': checkOutAt?.toIso8601String(),
        'check_in_lat': checkInLat,
        'check_in_lng': checkInLng,
        'check_out_lat': checkOutLat,
        'check_out_lng': checkOutLng,
        'discussion_notes': discussionNotes,
        'next_action': nextAction,
        'is_location_exception': isLocationException ? 1 : 0,
        'synced': synced ? 1 : 0,
      };

  factory Visit.fromMap(Map<String, dynamic> m) => Visit(
        id: m['id'] as String,
        customerId: m['customer_id'] as String,
        kamId: m['kam_id'] as String,
        checkInAt: DateTime.parse(m['check_in_at'] as String),
        checkOutAt: m['check_out_at'] != null
            ? DateTime.tryParse(m['check_out_at'] as String)
            : null,
        checkInLat: (m['check_in_lat'] as num).toDouble(),
        checkInLng: (m['check_in_lng'] as num).toDouble(),
        checkOutLat: (m['check_out_lat'] as num?)?.toDouble(),
        checkOutLng: (m['check_out_lng'] as num?)?.toDouble(),
        discussionNotes: m['discussion_notes'] as String? ?? '',
        nextAction: m['next_action'] as String? ?? '',
        isLocationException: (m['is_location_exception'] as int? ?? 0) == 1,
        synced: (m['synced'] as int? ?? 0) == 1,
      );
}

class CommercialAction {
  final String id;
  final String visitId;
  final CommercialActionType type;
  final Map<String, String> fields;
  final DateTime createdAt;
  final bool synced;

  CommercialAction({
    required this.id,
    required this.visitId,
    required this.type,
    required this.fields,
    required this.createdAt,
    this.synced = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'visit_id': visitId,
        'type': type.name,
        'fields_json': fields.entries.map((e) => '${e.key}=${e.value}').join('|'),
        'created_at': createdAt.toIso8601String(),
        'synced': synced ? 1 : 0,
      };

  factory CommercialAction.fromMap(Map<String, dynamic> m) {
    final raw = m['fields_json'] as String? ?? '';
    final fields = <String, String>{};
    if (raw.isNotEmpty) {
      for (final pair in raw.split('|')) {
        final idx = pair.indexOf('=');
        if (idx > 0) {
          fields[pair.substring(0, idx)] = pair.substring(idx + 1);
        }
      }
    }
    return CommercialAction(
      id: m['id'] as String,
      visitId: m['visit_id'] as String,
      type: CommercialActionType.values.firstWhere(
        (e) => e.name == (m['type'] as String? ?? 'feedback'),
        orElse: () => CommercialActionType.feedback,
      ),
      fields: fields,
      createdAt: DateTime.tryParse(m['created_at'] as String? ?? '') ?? DateTime.now(),
      synced: (m['synced'] as int? ?? 0) == 1,
    );
  }
}

class SyncQueueItem {
  final int? id;
  final String entityType;
  final String entityId;
  final DateTime createdAt;
  final int attempts;

  SyncQueueItem({
    this.id,
    required this.entityType,
    required this.entityId,
    required this.createdAt,
    this.attempts = 0,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'entity_type': entityType,
        'entity_id': entityId,
        'created_at': createdAt.toIso8601String(),
        'attempts': attempts,
      };

  factory SyncQueueItem.fromMap(Map<String, dynamic> m) => SyncQueueItem(
        id: m['id'] as int?,
        entityType: m['entity_type'] as String,
        entityId: m['entity_id'] as String,
        createdAt: DateTime.tryParse(m['created_at'] as String? ?? '') ?? DateTime.now(),
        attempts: m['attempts'] as int? ?? 0,
      );
}
