import 'package:flutter/material.dart';
import 'package:todos_app/core/constants/app_spacing.dart';

class TasksErrorView extends StatelessWidget {
  const TasksErrorView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Ocurrió un error al cargar las tareas.'),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
