import 'package:csv/csv.dart';
import '../models/domain_models.dart';
import 'report_service.dart';

class ExportService {
  String reportCsv({
    required ReportSnapshot snapshot,
    required ReportFilter filter,
  }) {
    final rows = <List<dynamic>>[
      ['Report Period', filter.period.name],
      ['Anchor Date', filter.anchorDate.toIso8601String()],
      [],
      ['Metric', 'Value'],
      ['Total Visits', snapshot.totalVisits],
      ['Qualified Visits', snapshot.qualifiedVisits],
      ['Short Visits', snapshot.shortVisits],
      ['Qualified Visit Rate', snapshot.qualifiedRate.toStringAsFixed(1)],
      ['Unique Customers', snapshot.uniqueCustomers],
      ['Samples', snapshot.samples],
      ['Leads', snapshot.leads],
      ['Pipeline Value', snapshot.pipelineValue.toStringAsFixed(2)],
      ['Orders', snapshot.orders],
      ['Order Value', snapshot.orderValue.toStringAsFixed(2)],
      ['Follow-ups', snapshot.followUps],
    ];

    return const ListToCsvConverter().convert(rows);
  }
}
