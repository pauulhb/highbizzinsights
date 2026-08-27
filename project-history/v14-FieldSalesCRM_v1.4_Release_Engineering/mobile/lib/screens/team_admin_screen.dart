import 'package:flutter/material.dart';
import '../repositories/team_admin_repository.dart';

class TeamAdminScreen extends StatefulWidget {
  const TeamAdminScreen({super.key});

  @override
  State<TeamAdminScreen> createState()=>_TeamAdminScreenState();
}

class _TeamAdminScreenState extends State<TeamAdminScreen>{
  List<dynamic> rows=[];
  bool loading=true;

  @override
  void initState(){
    super.initState();
    load();
  }

  Future<void> load() async{
    rows=await TeamAdminRepository().employees();
    if(mounted)setState(()=>loading=false);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(title:const Text('Team Administration')),
      body:loading
        ? const Center(child:CircularProgressIndicator())
        : ListView(
            children:rows.map((e)=>SwitchListTile(
              value:e['is_active']==true,
              title:Text(e['full_name']??''),
              subtitle:Text('${e['role']??''} • ${e['hq']??''} • ${e['state']??''}'),
              onChanged:(v) async{
                await TeamAdminRepository().updateEmployee(e['id'],isActive:v);
                await load();
              },
            )).toList(),
          ),
    );
  }
}
