import 'package:todos_app/data/datasources/task_datasource.dart';
import 'package:todos_app/data/mappers/task_mapper.dart';
import 'package:todos_app/domain/entities/task.dart';
import 'package:todos_app/domain/params/create_task_params.dart';
import 'package:todos_app/domain/params/update_task_params.dart';
import 'package:todos_app/domain/repositories/task_repository.dart';
import 'package:uuid/uuid.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._localDataSource);

  final TaskLocalDataSource _localDataSource;

  @override
  Future<List<Task>> getTasks() async {
    final models = await _localDataSource.getTasks();

    return models.map(TaskMapper.toEntity).toList();
  }

  @override
  Future<void> createTask(CreateTaskParams params) async {
    final model = TaskMapper.fromCreateParams(
      params,
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
    );

    await _localDataSource.saveTask(model);
  }

  @override
  Future<void> updateTask(UpdateTaskParams params) async {
    final current = await _localDataSource.getTaskById(params.id);

    if (current == null) {
      throw StateError('Task not found: ${params.id}');
    }

    final completedAt = !params.isCompleted ? null : current.completedAt ?? DateTime.now();

    final updated = TaskMapper.fromUpdateParams(
      current: current,
      params: params,
      completedAt: completedAt,
    );

    await _localDataSource.saveTask(updated);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _localDataSource.deleteTask(id);
  }
}
