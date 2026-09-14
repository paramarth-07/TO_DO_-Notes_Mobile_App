import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum TaskFilter { all, pending, notes, highPriority }

/// Horizontal filter chips rail conforming to screen.png:
/// "✓ All Tasks", "Pending X", "Notes", "High Priority"
class FilterChipsBar extends StatelessWidget {
  final TaskFilter activeFilter;
  final int pendingCount;
  final int notesCount;
  final ValueChanged<TaskFilter> onFilterChanged;

  const FilterChipsBar({
    super.key,
    required this.activeFilter,
    required this.pendingCount,
    required this.notesCount,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // 1. All Tasks Pill
          _buildPill(
            isSelected: activeFilter == TaskFilter.all,
            label: 'All Tasks',
            icon: Icons.check,
            onTap: () => onFilterChanged(TaskFilter.all),
          ),
          const SizedBox(width: 8),

          // 2. Pending Pill with count badge
          _buildPill(
            isSelected: activeFilter == TaskFilter.pending,
            label: 'Pending',
            badge: '$pendingCount',
            onTap: () => onFilterChanged(TaskFilter.pending),
          ),
          const SizedBox(width: 8),

          // 3. Notes Pill
          _buildPill(
            isSelected: activeFilter == TaskFilter.notes,
            label: 'Notes',
            icon: Icons.description_outlined,
            badge: '$notesCount',
            onTap: () => onFilterChanged(TaskFilter.notes),
          ),
          const SizedBox(width: 8),

          // 4. High Priority Pill
          _buildPriorityPill(
            isSelected: activeFilter == TaskFilter.highPriority,
            onTap: () => onFilterChanged(TaskFilter.highPriority),
          ),
        ],
      ),
    );
  }

  Widget _buildPill({
    required bool isSelected,
    required String label,
    IconData? icon,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkPill : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.darkPill : AppColors.outlineSubtle,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.onSurface,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.2) : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityPill({
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.primarySubtle,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'High Priority',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
