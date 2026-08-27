import 'package:flutter/material.dart';

class ManagerHierarchyScreen extends StatelessWidget {
  const ManagerHierarchyScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(title:const Text('Management Hierarchy')),
      body:ListView(
        padding:const EdgeInsets.all(16),
        children:const [
          Card(child:ListTile(
            title:Text('Region'),
            subtitle:Text('Open state-level performance'),
            trailing:Icon(Icons.chevron_right),
          )),
          Card(child:ListTile(
            title:Text('State'),
            subtitle:Text('Open HQ-level performance'),
            trailing:Icon(Icons.chevron_right),
          )),
          Card(child:ListTile(
            title:Text('HQ'),
            subtitle:Text('Open KAM-level performance'),
            trailing:Icon(Icons.chevron_right),
          )),
          Card(child:ListTile(
            title:Text('KAM'),
            subtitle:Text('Open customer and visit details'),
            trailing:Icon(Icons.chevron_right),
          )),
        ],
      ),
    );
  }
}
