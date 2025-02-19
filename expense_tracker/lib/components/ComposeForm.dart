import 'package:flutter/material.dart';

class Composeform extends StatelessWidget {
  final String title;
  final Widget formContent;
  final IconData icon;

  const Composeform({
    Key? key,
    required this.title,
    required this.formContent,
    this.icon = Icons.add,
  }) : super(key: key);

  void _openFormDialog(BuildContext context) {
    showDialog(
      context: context,
       builder: (context) => AlertDialog(
        title: Text(title),
        content: formContent,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(context),
             child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add form submission logic here
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          )
        ],
       ),
       );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openFormDialog(context),
      child: Icon(icon),
      tooltip: 'New expense');
  }
}