import 'package:todos_app/data/models/task_model.dart';
import 'package:todos_app/domain/entities/task.dart';
import 'package:todos_app/domain/params/create_task_params.dart';
import 'package:todos_app/domain/params/update_task_params.dart';

class TaskMapper {
  const TaskMapper._();

  static Task toEntity(TaskModel model) {
    return Task(
      id: model.id,
      title: model.title,
      description: model.description,
      isCompleted: model.isCompleted,
      createdAt: model.createdAt,
      completedAt: model.completedAt,
    );
  }

  static TaskModel fromCreateParams(
    CreateTaskParams params, {
    required String id,
    required DateTime createdAt,
  }) {
    return TaskModel(
      id: id,
      title: params.title,
      description: params.description,
      isCompleted: false,
      createdAt: createdAt,
      completedAt: null,
    );
  }

  static TaskModel fromUpdateParams({
    required TaskModel current,
    required UpdateTaskParams params,
    required DateTime? completedAt,
  }) {
    return TaskModel(
      id: current.id,
      title: params.title,
      description: params.description,
      isCompleted: params.isCompleted,
      createdAt: current.createdAt,
      completedAt: completedAt,
    );
  }
}
