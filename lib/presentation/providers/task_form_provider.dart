import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app/data/datasources/task_datasource_impl.dart';
import 'package:todos_app/domain/params/create_task_params.dart';
import 'package:todos_app/domain/params/update_task_params.dart';
import 'package:todos_app/data/repositories/task_repository_impl.dart';
import 'package:todos_app/domain/repositories/task_repository.dart';
import 'package:todos_app/presentation/providers/tasks_provider.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

final _taskRepository = TaskRepositoryImpl(HiveTaskLocalDataSource(Hive.box<Map>('tasks')));

final taskFormProvider = AsyncNotifierProvider<TaskFormNotifier, void>(TaskFormNotifier.new);

class TaskFormNotifier extends AsyncNotifier<void> {
  final TaskRepository _repository = _taskRepository;

  @override
  Future<void> build() async {}

  Future<void> createTask(CreateTaskParams params) async {
    await _execute(() => _repository.createTask(params));
  }

  Future<void> updateTask(UpdateTaskParams params) async {
    await _execute(() => _repository.updateTask(params));
  }

  Future<void> deleteTask(String id) async {
    await _execute(() => _repository.deleteTask(id));
  }

  Future<void> _execute(Future<void> Function() action) async {
    state = const AsyncLoading();

    try {
      await action();

      state = const AsyncData(null);

      ref.invalidate(tasksProvider);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
