import 'package:flutter/material.dart';
import 'package:todos_app/domain/entities/task.dart';
import 'package:todos_app/presentation/enums/task_list_type.dart';
import 'package:todos_app/presentation/widgets/widgets.dart';

class TasksList extends StatelessWidget {
  const TasksList({
    super.key,
    required this.tasks,
    required this.type,
    required this.onCompletionChanged,
  });

  final List<Task> tasks;
  final TaskListType type;
  final ValueChanged<Task> onCompletionChanged;

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
        final task = visibleTasks[index];
        return TaskTile(
          task: task,
          onCompletionChanged: (_) => onCompletionChanged(task),
          onEdit: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (_) => TaskFormSheet(task: task),
            );
          },
        );
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
        tasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskListType.completed:
        final completedTasks = tasks.where((task) => task.isCompleted).toList();
        completedTasks.sort((a, b) => b.completedAt!.compareTo(a.completedAt!));
        return completedTasks;
    }
  }
}
