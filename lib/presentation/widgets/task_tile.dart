import 'package:flutter/material.dart';
import 'package:todos_app/core/extensions/date_time_extension.dart';
import 'package:todos_app/domain/entities/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onCompletionChanged});

  final Task task;
  final ValueChanged<bool> onCompletionChanged;

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: isCompleted,
          onChanged: (value) {
            if (value != null) {
              onCompletionChanged(value);
            }
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(decoration: isCompleted ? TextDecoration.lineThrough : null),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            if (isCompleted && task.completedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Completada: ${task.completedAt!.toFormattedDateTime()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
        trailing: isCompleted
            ? null
            : PopupMenuButton<String>(
                onSelected: (value) {
                  // TODO: Implementar la lógica para editar o eliminar la tarea.
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                ],
              ),
      ),
    );
  }
}
