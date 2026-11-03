import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:todos_app/data/datasources/task_datasource_impl.dart';
import 'package:todos_app/data/repositories/task_repository_impl.dart';
import 'package:todos_app/domain/entities/task.dart';
import 'package:todos_app/domain/params/update_task_params.dart';
import 'package:todos_app/domain/repositories/task_repository.dart';

final tasksProvider = AsyncNotifierProvider<TasksNotifier, List<Task>>(
  () => TasksNotifier(TaskRepositoryImpl(HiveTaskLocalDataSource(Hive.box<Map>('tasks')))),
);

class TasksNotifier extends AsyncNotifier<List<Task>> {
  TasksNotifier(this._repository);

  final TaskRepository _repository;

  @override
  Future<List<Task>> build() {
    return _repository.getTasks();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final params = UpdateTaskParams(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: !task.isCompleted,
    );

    await _repository.updateTask(params);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _repository.getTasks());
  }
}
