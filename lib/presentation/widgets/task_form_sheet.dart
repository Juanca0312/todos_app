import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todos_app/core/constants/app_spacing.dart';
import 'package:todos_app/core/widgets/app_snackbar.dart';
import 'package:todos_app/domain/entities/task.dart';
import 'package:todos_app/domain/params/create_task_params.dart';
import 'package:todos_app/domain/params/update_task_params.dart';
import 'package:todos_app/presentation/providers/task_form_provider.dart';

class TaskFormSheet extends ConsumerStatefulWidget {
  const TaskFormSheet({super.key, this.task});

  final Task? task;

  bool get isEditing => task != null;

  @override
  ConsumerState<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends ConsumerState<TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final task = widget.task;

    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final notifier = ref.read(taskFormProvider.notifier);

      await _submit(notifier);

      if (!mounted) return;

      AppSnackBar.success(
        context,
        message: widget.isEditing
            ? 'Tarea actualizada exitosamente.'
            : 'Tarea creada exitosamente.',
      );

      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;

      AppSnackBar.error(
        context,
        message: widget.isEditing
            ? 'Error al actualizar la tarea. Intenta nuevamente.'
            : 'Error al crear la tarea. Intenta nuevamente.',
      );
    }
  }

  Future<void> _submit(TaskFormNotifier notifier) async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final task = widget.task;

    if (task != null) {
      await notifier.updateTask(
        UpdateTaskParams(
          id: task.id,
          title: title,
          description: description,
          isCompleted: task.isCompleted,
        ),
      );
      return;
    }

    await notifier.createTask(CreateTaskParams(title: title, description: description));
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(taskFormProvider.select((state) => state.isLoading));

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.isEditing ? 'Editar tarea' : 'Nueva tarea',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xxl),
              _TaskFormFields(
                titleController: _titleController,
                descriptionController: _descriptionController,
                enabled: !isLoading,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: isLoading ? null : _saveTask,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: AppSpacing.xl,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.isEditing ? 'Guardar cambios' : 'Guardar tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskFormFields extends StatelessWidget {
  const _TaskFormFields({
    required this.titleController,
    required this.descriptionController,
    required this.enabled,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: titleController,
          enabled: enabled,
          decoration: const InputDecoration(
            labelText: 'Título',
            hintText: '¿Qué necesitas hacer?',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
          maxLength: 100,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El título es obligatorio.';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        TextFormField(
          controller: descriptionController,
          enabled: enabled,
          decoration: const InputDecoration(
            labelText: 'Descripción',
            hintText: 'Agrega una descripción (opcional)',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          textCapitalization: TextCapitalization.sentences,
          maxLines: 3,
          maxLength: 500,
        ),
      ],
    );
  }
}
