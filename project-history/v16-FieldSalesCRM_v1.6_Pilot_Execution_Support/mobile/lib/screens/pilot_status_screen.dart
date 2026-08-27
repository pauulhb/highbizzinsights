import 'package:flutter/material.dart';

class PilotStatusScreen extends StatelessWidget {
  const PilotStatusScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(title:const Text('Pilot Status')),
      body:ListView(
        padding:const EdgeInsets.all(16),
        children:const [
          Card(child:ListTile(
            title:Text('Qualified Visit Rule'),
            subtitle:Text('15 minutes / 900 seconds — server controlled'),
            trailing:Icon(Icons.verified),
          )),
          Card(child:ListTile(
            title:Text('Offline Sync'),
            subtitle:Text('Monitor pending and failed sync records during pilot'),
          )),
          Card(child:ListTile(
            title:Text('Pilot Feedback'),
            subtitle:Text('Capture usability, workflow and reporting issues daily'),
          )),
        ],
      ),
    );
  }
}
