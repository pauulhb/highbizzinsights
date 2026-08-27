import '../services/api_client.dart';

class TeamAdminRepository {
  final ApiClient api;
  TeamAdminRepository({ApiClient? api}):api=api??ApiClient();

  Future<List<dynamic>> employees() async =>
      List<dynamic>.from(await api.get('/admin/employees'));

  Future<Map<String,dynamic>> updateEmployee(
    String id,{
    String? managerId,
    String? state,
    String? hq,
    bool? isActive,
  }) async {
    final r=await api.patch('/admin/employees/$id',{
      if(managerId!=null) 'managerId':managerId,
      if(state!=null) 'state':state,
      if(hq!=null) 'hq':hq,
      if(isActive!=null) 'isActive':isActive,
    });
    return Map<String,dynamic>.from(r);
  }
}
