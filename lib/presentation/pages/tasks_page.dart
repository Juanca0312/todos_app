import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todos_app/core/widgets/app_snackbar.dart';
import 'package:todos_app/domain/entities/task.dart';
import 'package:todos_app/presentation/enums/task_list_type.dart';
import 'package:todos_app/presentation/providers/task_form_provider.dart';
import 'package:todos_app/presentation/providers/tasks_provider.dart';
import 'package:todos_app/presentation/widgets/widgets.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('Mis tareas'), bottom: TasksTabBar()),
        body: tasksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              TasksErrorView(onRetry: () => ref.invalidate(tasksProvider)),
          data: (tasks) => TabBarView(
            children: [
              TasksList(
                tasks: tasks,
                type: TaskListType.pending,
                onCompletionChanged: (task) {
                  ref.read(tasksProvider.notifier).toggleTaskCompletion(task);
                },
                onDelete: (task) => _deleteTask(context, ref, task),
              ),
              TasksList(
                tasks: tasks,
                type: TaskListType.completed,
                onCompletionChanged: (task) {
                  ref.read(tasksProvider.notifier).toggleTaskCompletion(task);
                },
                onDelete: (task) => _deleteTask(context, ref, task),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (_) => const TaskFormSheet(),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _deleteTask(BuildContext context, WidgetRef ref, Task task) async {
    try {
      await ref.read(taskFormProvider.notifier).deleteTask(task.id);

      if (!context.mounted) return;

      AppSnackBar.success(context, message: 'Tarea eliminada exitosamente.');
    } catch (_) {
      if (!context.mounted) return;

      AppSnackBar.error(context, message: 'Error al eliminar la tarea. Intenta nuevamente.');
    }
  }
}
