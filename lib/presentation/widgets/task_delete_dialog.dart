import 'package:flutter/material.dart';

class TaskDeleteDialog extends StatelessWidget {
  const TaskDeleteDialog({super.key, required this.taskTitle});

  final String taskTitle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eliminar tarea'),
      content: Text(
        '¿Estás seguro de que deseas eliminar "$taskTitle"? '
        'Esta acción no se puede deshacer.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
