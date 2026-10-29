import 'package:todos_app/data/models/task_model.dart';

abstract interface class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();

  Future<TaskModel?> getTaskById(String id);

  Future<void> saveTask(TaskModel task);

  Future<void> deleteTask(String id);
}
