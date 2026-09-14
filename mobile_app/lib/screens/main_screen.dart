import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../models/note.dart';
import '../services/local_storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/workspace_header.dart';
import '../widgets/filter_chips_bar.dart';
import '../widgets/metrics_bento_cards.dart';
import '../widgets/todo_card.dart';
import '../widgets/note_card.dart';
import '../widgets/create_todo_sheet.dart';
import '../widgets/create_note_sheet.dart';

/// MainScreen replicating screen.png with Warm Minimal Tactile aesthetic,
/// standalone on-device persistence with SharedPreferences, and responsive tabs.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Todo> _todos = [];
  List<Note> _notes = [];
  bool _isLoading = true;

  TaskFilter _activeFilter = TaskFilter.all;
  int _currentNavIndex = 0; // 0: Tasks, 1: Notes, 2: Search
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    await LocalStorageService.instance.init();
    await _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final todos = await LocalStorageService.instance.getTodos();
      final notes = await LocalStorageService.instance.getNotes();

      setState(() {
        _todos = todos;
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error loading local data: $e');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.darkPill,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  // ==========================================
  // TODO ACTIONS (Local SharedPreferences)
  // ==========================================
  Future<void> _handleToggleTodo(Todo todo, bool completed) async {
    final updated = todo.copyWith(completed: completed);
    setState(() {
      _todos = _todos.map((t) => t.id == todo.id ? updated : t).toList();
    });

    try {
      await LocalStorageService.instance.saveTodo(updated);
      _showSnackBar(completed ? 'Task marked complete' : 'Task marked pending');
    } catch (e) {
      _showSnackBar('Failed to update task: $e');
      _loadData();
    }
  }

  Future<void> _handleSaveTodo(Todo todo) async {
    try {
      final result = await LocalStorageService.instance.saveTodo(todo);
      setState(() {
        if (todo.id != null) {
          _todos = _todos.map((t) => t.id == result.id ? result : t).toList();
        } else {
          _todos.insert(0, result);
        }
      });
      _showSnackBar(todo.id != null ? 'Task updated' : 'Task created');
    } catch (e) {
      _showSnackBar('Failed to save task: $e');
    }
  }

  Future<void> _handleDeleteTodo(int id) async {
    try {
      await LocalStorageService.instance.deleteTodo(id);
      setState(() {
        _todos.removeWhere((t) => t.id == id);
      });
      _showSnackBar('Task deleted');
    } catch (e) {
      _showSnackBar('Failed to delete task: $e');
    }
  }

  // ==========================================
  // NOTE ACTIONS (Local SharedPreferences)
  // ==========================================
  Future<void> _handleSaveNote(Note note) async {
    try {
      final result = await LocalStorageService.instance.saveNote(note);
      setState(() {
        if (note.id != null) {
          _notes = _notes.map((n) => n.id == result.id ? result : n).toList();
        } else {
          _notes.insert(0, result);
        }
        _notes.sort((a, b) => (b.pinned ? 1 : 0) - (a.pinned ? 1 : 0));
      });
      _showSnackBar(note.id != null ? 'Note updated' : 'Note created');
    } catch (e) {
      _showSnackBar('Failed to save note: $e');
    }
  }

  Future<void> _handleTogglePinNote(Note note) async {
    final updated = note.copyWith(pinned: !note.pinned);
    try {
      final result = await LocalStorageService.instance.saveNote(updated);
      setState(() {
        _notes = _notes.map((n) => n.id == result.id ? result : n).toList();
        _notes.sort((a, b) => (b.pinned ? 1 : 0) - (a.pinned ? 1 : 0));
      });
      _showSnackBar(result.pinned ? 'Note pinned' : 'Note unpinned');
    } catch (e) {
      _showSnackBar('Failed to toggle pin: $e');
    }
  }

  Future<void> _handleDeleteNote(int id) async {
    try {
      await LocalStorageService.instance.deleteNote(id);
      setState(() {
        _notes.removeWhere((n) => n.id == id);
      });
      _showSnackBar('Note deleted');
    } catch (e) {
      _showSnackBar('Failed to delete note: $e');
    }
  }

  // Action Menu for FAB
  void _openCreateChoiceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.primarySubtle,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppColors.primary),
              ),
              title: const Text('Add New Task', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Create a task with priority indicator'),
              onTap: () {
                Navigator.pop(ctx);
                CreateTodoSheet.show(context, onSave: _handleSaveTodo);
              },
            ),
            const Divider(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.description_outlined, color: AppColors.onSurface),
              ),
              title: const Text('Create New Note', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Write meeting notes or ideas'),
              onTap: () {
                Navigator.pop(ctx);
                CreateNoteSheet.show(context, onSave: _handleSaveNote);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Filtered Todos
  List<Todo> get _filteredTodos {
    final query = _searchController.text.toLowerCase().trim();
    return _todos.where((t) {
      final matchesQuery = query.isEmpty || t.title.toLowerCase().contains(query);
      if (!matchesQuery) return false;

      switch (_activeFilter) {
        case TaskFilter.pending:
          return !t.completed;
        case TaskFilter.highPriority:
          return t.priority.toUpperCase() == 'HIGH';
        case TaskFilter.notes:
          return false;
        case TaskFilter.all:
          return true;
      }
    }).toList();
  }

  // Filtered Notes
  List<Note> get _filteredNotes {
    final query = _searchController.text.toLowerCase().trim();
    return _notes.where((n) {
      final matchesQuery = query.isEmpty ||
          n.title.toLowerCase().contains(query) ||
          n.content.toLowerCase().contains(query);
      return matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _todos.where((t) => !t.completed).length;
    final completedCount = _todos.where((t) => t.completed).length;
    final pinnedCount = _notes.where((n) => n.pinned).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              // 1. Top Workspace Header
              SliverToBoxAdapter(
                child: WorkspaceHeader(
                  tasksDueToday: pendingCount,
                  onSearchPressed: () {
                    setState(() {
                      _isSearchActive = !_isSearchActive;
                      if (!_isSearchActive) _searchController.clear();
                    });
                  },
                  onRefresh: _loadData,
                ),
              ),

              // Search Bar (if active)
              if (_isSearchActive)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search tasks and notes...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceCard,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.outlineSubtle),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),

              // 2. Filter Chips Row
              SliverToBoxAdapter(
                child: FilterChipsBar(
                  activeFilter: _activeFilter,
                  pendingCount: pendingCount,
                  notesCount: _notes.length,
                  onFilterChanged: (filter) {
                    setState(() {
                      _activeFilter = filter;
                    });
                  },
                ),
              ),

              // 3. 2-Column Bento Metrics Grid
              SliverToBoxAdapter(
                child: MetricsBentoCards(
                  totalTasks: _todos.length,
                  completedTasks: completedCount,
                  totalNotes: _notes.length,
                  pinnedNotes: pinnedCount,
                  onNotesTap: () {
                    setState(() {
                      _activeFilter = TaskFilter.notes;
                    });
                  },
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // 4. Section: Today's Focus (Tasks)
              if (_activeFilter != TaskFilter.notes) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Today's Focus",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${_filteredTodos.length}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            CreateTodoSheet.show(context, onSave: _handleSaveTodo);
                          },
                          child: const Text(
                            '+ Add Task',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (_isLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    ),
                  )
                else if (_filteredTodos.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Center(
                        child: Text(
                          'No tasks in this view.',
                          style: TextStyle(color: AppColors.onSurfaceVariant),
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final todo = _filteredTodos[index];
                        return TodoCard(
                          todo: todo,
                          onToggleCompleted: (val) => _handleToggleTodo(todo, val),
                          onEdit: () {
                            CreateTodoSheet.show(
                              context,
                              initialTodo: todo,
                              onSave: _handleSaveTodo,
                            );
                          },
                          onDelete: () => _handleDeleteTodo(todo.id!),
                        );
                      },
                      childCount: _filteredTodos.length,
                    ),
                  ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // 5. Section: Recent Notes
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Notes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          CreateNoteSheet.show(context, onSave: _handleSaveNote);
                        },
                        child: const Text(
                          '+ New Note',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Note List Items
              if (_filteredNotes.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Center(
                      child: Text(
                        'No notes created yet.',
                        style: TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final note = _filteredNotes[index];
                      return NoteCard(
                        note: note,
                        onTap: () {
                          CreateNoteSheet.show(
                            context,
                            initialNote: note,
                            onSave: _handleSaveNote,
                          );
                        },
                        onTogglePin: () => _handleTogglePinNote(note),
                        onDelete: () => _handleDeleteNote(note.id!),
                      );
                    },
                    childCount: _filteredNotes.length,
                  ),
                ),

              // Bottom padding so content is not obscured by FAB or bottom bar
              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),
        ),
      ),

      // Floating Action Button (FAB) matching screen.png
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateChoiceSheet,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        child: const Icon(Icons.add, size: 28),
      ),

      // Bottom Navigation Bar matching screen.png
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceCard,
          border: Border(top: BorderSide(color: AppColors.surfaceContainerHigh, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.check_circle_outline,
              label: 'Tasks',
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.description_outlined,
              label: 'Notes',
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.search,
              label: 'Search',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentNavIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
          if (index == 0) {
            _activeFilter = TaskFilter.all;
            _isSearchActive = false;
          } else if (index == 1) {
            _activeFilter = TaskFilter.notes;
            _isSearchActive = false;
          } else if (index == 2) {
            _isSearchActive = true;
          }
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.darkPill : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
