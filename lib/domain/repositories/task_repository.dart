import 'package:todos_app/domain/entities/task.dart';
import 'package:todos_app/domain/params/create_task_params.dart';
import 'package:todos_app/domain/params/update_task_params.dart';

abstract interface class TaskRepository {
  Future<List<Task>> getTasks();

  Future<void> createTask(CreateTaskParams params);

  Future<void> updateTask(UpdateTaskParams params);

  Future<void> deleteTask(String id);
}
