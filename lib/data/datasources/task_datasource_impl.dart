import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:todos_app/data/datasources/task_datasource.dart';
import 'package:todos_app/data/models/task_model.dart';

class HiveTaskLocalDataSource implements TaskLocalDataSource {
  HiveTaskLocalDataSource(this._box);

  final Box<Map> _box;

  @override
  Future<List<TaskModel>> getTasks() async {
    return _box.values.map((json) => TaskModel.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    final json = _box.get(id);

    if (json == null) {
      return null;
    }

    return TaskModel.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    await _box.put(task.id, task.toJson());
  }

  @override
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }
}
