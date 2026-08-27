class EmployeeSession {
  final String id;
  final String fullName;
  final String role;
  final String state;
  final String hq;

  EmployeeSession({
    required this.id,
    required this.fullName,
    required this.role,
    required this.state,
    required this.hq,
  });

  factory EmployeeSession.fromJson(Map<String,dynamic> j) => EmployeeSession(
    id: j['id'],
    fullName: j['fullName'] ?? j['full_name'],
    role: j['role'],
    state: j['state'],
    hq: j['hq'],
  );
}

class Customer {
  final String id;
  final String customerType;
  final String name;
  final String accountName;
  final String city;
  final String state;
  final String area;
  final String potential;
  final double latitude;
  final double longitude;

  Customer({
    required this.id,
    required this.customerType,
    required this.name,
    required this.accountName,
    required this.city,
    required this.state,
    required this.area,
    required this.potential,
    required this.latitude,
    required this.longitude,
  });

  factory Customer.fromJson(Map<String,dynamic> j) => Customer(
    id: j['id'],
    customerType: j['customer_type'] ?? j['customerType'],
    name: j['name'],
    accountName: j['account_name'] ?? j['accountName'],
    city: j['city'],
    state: j['state'],
    area: j['area'] ?? '',
    potential: j['potential'],
    latitude: double.parse(j['latitude'].toString()),
    longitude: double.parse(j['longitude'].toString()),
  );
}

class PerformanceSnapshot {
  final int totalVisits;
  final int qualifiedVisits;
  final int shortVisits;
  final double qualifiedVisitRate;
  final int samples;
  final int leads;
  final double pipelineValue;
  final int orders;
  final double orderValue;
  final int followUps;

  PerformanceSnapshot({
    required this.totalVisits,
    required this.qualifiedVisits,
    required this.shortVisits,
    required this.qualifiedVisitRate,
    required this.samples,
    required this.leads,
    required this.pipelineValue,
    required this.orders,
    required this.orderValue,
    required this.followUps,
  });

  factory PerformanceSnapshot.fromJson(Map<String,dynamic> j) => PerformanceSnapshot(
    totalVisits: j['totalVisits'] ?? 0,
    qualifiedVisits: j['qualifiedVisits'] ?? 0,
    shortVisits: j['shortVisits'] ?? 0,
    qualifiedVisitRate: (j['qualifiedVisitRate'] ?? 0).toDouble(),
    samples: j['samples'] ?? 0,
    leads: j['leads'] ?? 0,
    pipelineValue: (j['pipelineValue'] ?? 0).toDouble(),
    orders: j['orders'] ?? 0,
    orderValue: (j['orderValue'] ?? 0).toDouble(),
    followUps: j['followUps'] ?? 0,
  );
}
