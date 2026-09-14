import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../theme/app_theme.dart';

/// Tactile Bottom Sheet modal for creating or editing a task.
class CreateTodoSheet extends StatefulWidget {
  final Todo? initialTodo;
  final ValueChanged<Todo> onSave;

  const CreateTodoSheet({
    super.key,
    this.initialTodo,
    required this.onSave,
  });

  static Future<void> show(BuildContext context, {Todo? initialTodo, required ValueChanged<Todo> onSave}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CreateTodoSheet(initialTodo: initialTodo, onSave: onSave),
    );
  }

  @override
  State<CreateTodoSheet> createState() => _CreateTodoSheetState();
}

class _CreateTodoSheetState extends State<CreateTodoSheet> {
  late final TextEditingController _titleController;
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTodo?.title ?? '');
    _selectedPriority = widget.initialTodo?.priority ?? 'MEDIUM';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final todo = Todo(
      id: widget.initialTodo?.id,
      title: title,
      priority: _selectedPriority,
      completed: widget.initialTodo?.completed ?? false,
      createdAt: widget.initialTodo?.createdAt ?? DateTime.now(),
    );

    widget.onSave(todo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialTodo != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Title Heading
          Text(
            isEditing ? 'Edit Task' : 'New Task',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),

          // Task Title Input
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'What needs to be done?...',
              hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 18),

          // Priority Selection Row
          const Text(
            'PRIORITY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildPriorityChoice('HIGH', 'High', AppColors.priorityHighText, AppColors.priorityHighBg),
              const SizedBox(width: 8),
              _buildPriorityChoice('MEDIUM', 'Medium', AppColors.priorityMedText, AppColors.priorityMedBg),
              const SizedBox(width: 8),
              _buildPriorityChoice('LOW', 'Low', AppColors.priorityLowText, AppColors.priorityLowBg),
            ],
          ),
          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _submit,
              child: Text(
                isEditing ? 'Save Changes' : 'Add Task',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChoice(String value, String label, Color textColor, Color bgColor) {
    final isSelected = _selectedPriority == value;

    return InkWell(
      onTap: () => setState(() => _selectedPriority = value),
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? bgColor : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? textColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? textColor : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
