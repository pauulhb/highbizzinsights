import 'package:flutter/material.dart';
import '../repositories/territory_repository.dart';

class TerritoryAdminScreen extends StatefulWidget{
  const TerritoryAdminScreen({super.key});
  @override
  State<TerritoryAdminScreen> createState()=>_TerritoryAdminScreenState();
}

class _TerritoryAdminScreenState extends State<TerritoryAdminScreen>{
  List<dynamic> rows=[];
  @override
  void initState(){super.initState();load();}
  Future<void> load() async{
    rows=await TerritoryRepository().list();
    if(mounted)setState((){});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(title:const Text('Territories')),
      body:ListView(
        children:rows.map((x)=>ListTile(
          title:Text('${x['hq']}'),
          subtitle:Text('${x['state']} • ${(x['cities']??[]).toString()}'),
        )).toList(),
      ),
    );
  }
}
