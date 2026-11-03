import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app/presentation/enums/task_list_type.dart';
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
              TasksList(tasks: tasks, type: TaskListType.pending),
              TasksList(tasks: tasks, type: TaskListType.completed),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //TODO: Implementar la lógica para agregar una nueva tarea.
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
