import 'package:flutter/material.dart';
import 'package:todos_app/domain/entities/task.dart';
import 'package:todos_app/presentation/enums/task_list_type.dart';
import 'package:todos_app/presentation/widgets/tasks_list.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      Task(
        id: '1',
        title: 'Aprender Riverpod',
        description: 'Entender AsyncNotifier y sus estados',
        isCompleted: false,
        createdAt: DateTime.now(),
        completedAt: null,
      ),
      Task(
        id: '2',
        title: 'Implementar Hive',
        description: 'Persistencia local de tareas',
        isCompleted: true,
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
      ),
      Task(
        id: '3',
        title: 'Crear pantalla de listado',
        description: 'Diseñar la interfaz principal',
        isCompleted: false,
        createdAt: DateTime.now(),
        completedAt: null,
      ),
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis tareas'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pendientes'),
              Tab(text: 'Completadas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TasksList(tasks: tasks, type: TaskListType.pending),
            TasksList(tasks: tasks, type: TaskListType.completed),
          ],
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
