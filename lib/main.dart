import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_list.dart';
import 'task_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskList(), axisAlignment: MainAxisAlignment.start,
    );
  }
}
