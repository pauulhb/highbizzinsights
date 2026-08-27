import 'package:flutter/material.dart';
import '../repositories/manager_repository.dart';

class ManagerDrilldownScreen extends StatefulWidget {
  const ManagerDrilldownScreen({super.key});
  @override
  State<ManagerDrilldownScreen> createState()=>_ManagerDrilldownScreenState();
}

class _ManagerDrilldownScreenState extends State<ManagerDrilldownScreen>{
  List<dynamic> states=[],hqs=[],kams=[];
  bool loading=true;

  @override
  void initState(){
    super.initState();
    load();
  }

  Future<void> load() async{
    final repo=ManagerRepository();
    states=await repo.states();
    hqs=await repo.hqs();
    kams=await repo.kams();
    if(mounted)setState(()=>loading=false);
  }

  @override
  Widget build(BuildContext context){
    if(loading)return const Center(child:CircularProgressIndicator());
    return ListView(
      padding:const EdgeInsets.all(16),
      children:[
        const Text('Management Drill-down',
          style:TextStyle(fontSize:22,fontWeight:FontWeight.w800)),
        const SizedBox(height:12),
        Text('States: ${states.length}'),
        Text('HQs: ${hqs.length}'),
        Text('KAMs: ${kams.length}'),
        const SizedBox(height:16),
        const Card(child:ListTile(
          title:Text('Drill-down path'),
          subtitle:Text('Region → State → HQ → KAM → Customer → Visit'),
        )),
      ],
    );
  }
}
