import '../models/todo.dart';
import '../models/note.dart';

/// Pre-seeded sample data matching the Stitch Warm Minimal Workspace design
class SampleData {
  static List<Todo> get initialTodos => [
        Todo(
          id: 1,
          title: 'Finalize UI System Guidelines',
          completed: false,
          priority: 'HIGH',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        Todo(
          id: 2,
          title: 'Submit Database Architecture assignment',
          completed: false,
          priority: 'MEDIUM',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        Todo(
          id: 3,
          title: 'Review PR #142 for Auth Microservice',
          completed: true,
          priority: 'LOW',
          createdAt: DateTime.now().subtract(const Duration(hours: 7)),
        ),
        Todo(
          id: 4,
          title: 'Prepare slides for Final Year Viva demo',
          completed: false,
          priority: 'HIGH',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        Todo(
          id: 5,
          title: 'Test on-device SharedPreferences persistence',
          completed: true,
          priority: 'MEDIUM',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];

  static List<Note> get initialNotes => [
        Note(
          id: 1,
          title: 'Spring Boot REST Endpoints',
          content: 'Configured JWT filter chain with Redis token blacklist. Verified OpenAPI Swagger docs...',
          pinned: true,
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Note(
          id: 2,
          title: 'Warm Minimal Palette Tokens',
          content: 'Background: #F7F7F5, Cards: #FFFFFF, Flame Orange: #F36C21, Primary Ink: #141414.',
          pinned: false,
          updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        Note(
          id: 3,
          title: 'Viva Evaluation Architecture',
          content: 'Standalone mobile application using SharedPreferences local key-value persistence. Zero network required.',
          pinned: true,
          updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ];
}
