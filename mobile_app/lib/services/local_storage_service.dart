import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';
import '../models/note.dart';
import '../data/sample_data.dart';

/// Standalone on-device persistence service using SharedPreferences.
/// Completely offline-first with zero external backend dependency.
class LocalStorageService {
  static final LocalStorageService instance = LocalStorageService._internal();
  LocalStorageService._internal();

  static const String _todosKey = 'taskflow_todos_v1';
  static const String _notesKey = 'taskflow_notes_v1';
  static const String _initializedKey = 'taskflow_has_seeded_v1';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Initialize and seed sample demo data on first launch
  Future<void> init() async {
    final prefs = await _getPrefs();
    final hasSeeded = prefs.getBool(_initializedKey) ?? false;

    if (!hasSeeded) {
      await resetToDemoData();
      await prefs.setBool(_initializedKey, true);
    }
  }

  // ==========================================
  // TODOS CRUD
  // ==========================================

  Future<List<Todo>> getTodos() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_todosKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> rawList = jsonDecode(jsonString);
      return rawList.map((item) => Todo.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Todo> saveTodo(Todo todo) async {
    final todos = await getTodos();
    Todo resultTodo;

    if (todo.id != null) {
      // Update existing
      resultTodo = todo;
      final index = todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        todos[index] = todo;
      } else {
        todos.insert(0, todo);
      }
    } else {
      // Create new with incremental ID
      final nextId = (todos.isEmpty ? 0 : todos.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b)) + 1;
      resultTodo = todo.copyWith(
        id: nextId,
        createdAt: todo.createdAt ?? DateTime.now(),
      );
      todos.insert(0, resultTodo);
    }

    await _saveTodoList(todos);
    return resultTodo;
  }

  Future<void> deleteTodo(int id) async {
    final todos = await getTodos();
    todos.removeWhere((t) => t.id == id);
    await _saveTodoList(todos);
  }

  Future<void> _saveTodoList(List<Todo> todos) async {
    final prefs = await _getPrefs();
    final jsonString = jsonEncode(todos.map((t) => t.toJson()).toList());
    await prefs.setString(_todosKey, jsonString);
  }

  // ==========================================
  // NOTES CRUD
  // ==========================================

  Future<List<Note>> getNotes() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_notesKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> rawList = jsonDecode(jsonString);
      final notes = rawList.map((item) => Note.fromJson(item)).toList();
      // Pinned first, then newest updated
      notes.sort((a, b) => (b.pinned ? 1 : 0) - (a.pinned ? 1 : 0));
      return notes;
    } catch (e) {
      return [];
    }
  }

  Future<Note> saveNote(Note note) async {
    final notes = await getNotes();
    Note resultNote;

    if (note.id != null) {
      // Update existing
      resultNote = note.copyWith(updatedAt: DateTime.now());
      final index = notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        notes[index] = resultNote;
      } else {
        notes.insert(0, resultNote);
      }
    } else {
      // Create new with incremental ID
      final nextId = (notes.isEmpty ? 0 : notes.map((n) => n.id ?? 0).reduce((a, b) => a > b ? a : b)) + 1;
      resultNote = note.copyWith(
        id: nextId,
        updatedAt: DateTime.now(),
      );
      notes.insert(0, resultNote);
    }

    notes.sort((a, b) => (b.pinned ? 1 : 0) - (a.pinned ? 1 : 0));
    await _saveNoteList(notes);
    return resultNote;
  }

  Future<void> deleteNote(int id) async {
    final notes = await getNotes();
    notes.removeWhere((n) => n.id == id);
    await _saveNoteList(notes);
  }

  Future<void> _saveNoteList(List<Note> notes) async {
    final prefs = await _getPrefs();
    final jsonString = jsonEncode(notes.map((n) => n.toJson()).toList());
    await prefs.setString(_notesKey, jsonString);
  }

  // ==========================================
  // DEMO DATA SEEDING
  // ==========================================

  Future<void> resetToDemoData() async {
    await _saveTodoList(SampleData.initialTodos);
    await _saveNoteList(SampleData.initialNotes);
  }

  Future<void> clearAllData() async {
    await _saveTodoList([]);
    await _saveNoteList([]);
  }
}
