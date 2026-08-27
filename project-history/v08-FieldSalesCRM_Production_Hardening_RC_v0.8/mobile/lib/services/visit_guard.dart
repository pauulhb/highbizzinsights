import 'api_client.dart';
class VisitGuard{
 final ApiClient api; VisitGuard({ApiClient? api}):api=api??ApiClient();
 Future<void> ensureNoParallelVisit() async{
  final r=await api.get('/visits/active');
  if(r!=null) throw Exception('Complete the active customer visit before starting another visit.');
 }
}
