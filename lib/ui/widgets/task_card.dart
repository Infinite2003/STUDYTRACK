import 'package:flutter/material.dart';
import '../../models/task.dart';

class TaskCard extends StatelessWidget{

  final Task task;

  
  const TaskCard({
    Key?key,
    required this.task
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16.0)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}