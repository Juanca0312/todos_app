import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app/core/constants/app_spacing.dart';
import 'package:todos_app/core/widgets/app_snackbar.dart';

import 'package:todos_app/domain/params/create_task_params.dart';
import 'package:todos_app/presentation/providers/task_form_provider.dart';

class TaskFormSheet extends ConsumerStatefulWidget {
  const TaskFormSheet({super.key});

  @override
  ConsumerState<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends ConsumerState<TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) return;

    final params = CreateTaskParams(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    try {
      await ref.read(taskFormProvider.notifier).createTask(params);

      if (!mounted) return;
      AppSnackBar.success(context, message: 'Tarea creada exitosamente.');
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;

      AppSnackBar.error(context, message: 'Error al crear la tarea. Intenta nuevamente.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(taskFormProvider);
    final isLoading = formState.isLoading;

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
              Text('Nueva tarea', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xxl),
              _TaskFormFields(
                titleController: _titleController,
                descriptionController: _descriptionController,
                enabled: !isLoading,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: isLoading ? null : _createTask,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: AppSpacing.xl,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Guardar tarea'),
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
