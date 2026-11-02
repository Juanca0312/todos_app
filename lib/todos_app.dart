import 'package:flutter/material.dart';
import 'package:todos_app/presentation/pages/tasks_page.dart';

class TodosApp extends StatelessWidget {
  const TodosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const TasksPage());
  }
}
