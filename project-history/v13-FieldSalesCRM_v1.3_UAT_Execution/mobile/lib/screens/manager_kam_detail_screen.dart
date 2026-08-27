import 'package:flutter/material.dart';
import '../repositories/manager_detail_repository.dart';

class ManagerKamDetailScreen extends StatefulWidget {
  final String employeeId;
  const ManagerKamDetailScreen({super.key,required this.employeeId});

  @override
  State<ManagerKamDetailScreen> createState()=>_ManagerKamDetailScreenState();
}

class _ManagerKamDetailScreenState extends State<ManagerKamDetailScreen>{
  Map<String,dynamic>? summary;
  List<dynamic> customers=[];
  bool loading=true;

  @override
  void initState(){
    super.initState();
    load();
  }

  Future<void> load() async{
    final repo=ManagerDetailRepository();
    summary=await repo.kamSummary(widget.employeeId);
    customers=await repo.kamCustomers(widget.employeeId);
    if(mounted)setState(()=>loading=false);
  }

  @override
  Widget build(BuildContext context){
    if(loading) return const Scaffold(body:Center(child:CircularProgressIndicator()));
    final s=summary!;
    return Scaffold(
      appBar:AppBar(title:Text(s['full_name']??'KAM')),
      body:ListView(
        padding:const EdgeInsets.all(16),
        children:[
          Wrap(
            spacing:8,runSpacing:8,
            children:[
              _kpi('Visits','${s['total_visits']??0}'),
              _kpi('Qualified','${s['qualified_visits']??0}'),
              _kpi('Short','${s['short_visits']??0}'),
              _kpi('Orders','₹${s['order_value']??0}'),
            ],
          ),
          const SizedBox(height:16),
          const Text('Assigned Customers',
            style:TextStyle(fontSize:18,fontWeight:FontWeight.w800)),
          ...customers.map((c)=>Card(
            child:ListTile(
              title:Text(c['name']??''),
              subtitle:Text('${c['account_name']??''}\n${c['city']??''} • ${c['potential']??''}'),
              isThreeLine:true,
            ),
          ))
        ],
      ),
    );
  }

  Widget _kpi(String label,String value)=>SizedBox(
    width:145,
    child:Card(
      child:Padding(
        padding:const EdgeInsets.all(14),
        child:Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:[
            Text(value,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800)),
            Text(label)
          ],
        ),
      ),
    ),
  );
}
