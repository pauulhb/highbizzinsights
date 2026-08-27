import 'package:flutter/material.dart';

class AttachmentUploadCard extends StatelessWidget {
  final String category;
  final VoidCallback onSelectFile;

  const AttachmentUploadCard({
    super.key,
    required this.category,
    required this.onSelectFile,
  });

  @override
  Widget build(BuildContext context){
    return Card(
      child:ListTile(
        leading:const Icon(Icons.attach_file),
        title:Text(category),
        subtitle:const Text('Select a permitted business document'),
        trailing:FilledButton(
          onPressed:onSelectFile,
          child:const Text('SELECT'),
        ),
      ),
    );
  }
}
