import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../theme/app_theme.dart';

/// Individual Todo Task Card conforming to screen.png:
/// Tactile circular checkbox, strikethrough animation, priority badge, and 3-dot menu.
class TodoCard extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool> onToggleCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoCard({
    super.key,
    required this.todo,
    required this.onToggleCompleted,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getPriorityBg(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH':
        return AppColors.priorityHighBg;
      case 'LOW':
        return AppColors.priorityLowBg;
      case 'MEDIUM':
      default:
        return AppColors.priorityMedBg;
    }
  }

  Color _getPriorityText(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH':
        return AppColors.priorityHighText;
      case 'LOW':
        return AppColors.priorityLowText;
      case 'MEDIUM':
      default:
        return AppColors.priorityMedText;
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'Today';
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final isDone = todo.completed;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDone ? AppColors.surfaceContainerLow : AppColors.surfaceContainerHigh,
          width: 1,
        ),
        boxShadow: isDone ? [] : AppColors.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Tactile Checkbox
          InkWell(
            onTap: () => onToggleCompleted(!isDone),
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? AppColors.darkPill : Colors.transparent,
                border: Border.all(
                  color: isDone ? AppColors.darkPill : const Color(0xFFD0D0CA),
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 14),

          // Title & Metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDone ? AppColors.onSurfaceVariant : AppColors.onSurface,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Priority Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getPriorityBg(todo.priority),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        todo.priority,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _getPriorityText(todo.priority),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Timestamp
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(todo.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Three-Dot Popup Menu
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.onSurfaceVariant,
              size: 20,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              } else if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18, color: AppColors.onSurface),
                    SizedBox(width: 8),
                    Text('Edit Task', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: AppColors.priorityHighText),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(fontSize: 14, color: AppColors.priorityHighText)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
