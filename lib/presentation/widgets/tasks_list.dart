import 'package:flutter/material.dart';
import 'package:todos_app/domain/entities/task.dart';
import 'package:todos_app/presentation/enums/task_list_type.dart';
import 'package:todos_app/presentation/widgets/task_tile.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key, required this.tasks, required this.type});

  final List<Task> tasks;
  final TaskListType type;

  @override
  Widget build(BuildContext context) {
    final visibleTasks = filteredTasks;

    if (visibleTasks.isEmpty) {
      return Center(child: Text(emptyMessage, style: Theme.of(context).textTheme.bodyLarge));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: visibleTasks.length,
      itemBuilder: (context, index) {
        return TaskTile(task: visibleTasks[index]);
      },
    );
  }

  String get emptyMessage {
    switch (type) {
      case TaskListType.pending:
        return 'No hay tareas pendientes.';
      case TaskListType.completed:
        return 'No hay tareas completadas.';
    }
  }

  List<Task> get filteredTasks {
    switch (type) {
      case TaskListType.pending:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskListType.completed:
        return tasks.where((task) => task.isCompleted).toList();
    }
  }
}
