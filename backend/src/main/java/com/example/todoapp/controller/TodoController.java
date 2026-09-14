package com.example.todoapp.controller;

import com.example.todoapp.model.Todo;
import com.example.todoapp.service.TodoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST Controller exposing endpoints for Todo operations under /api/v1/todos.
 * @CrossOrigin enables Cross-Origin Resource Sharing for React web and Flutter clients.
 */
@RestController
@RequestMapping("/api/v1/todos")
@CrossOrigin(origins = "*")
public class TodoController {

    private final TodoService todoService;

    // Constructor injection of TodoService
    public TodoController(TodoService todoService) {
        this.todoService = todoService;
    }

    /**
     * GET /api/v1/todos
     * Retrieves all todos. Optionally filters by completed status: /api/v1/todos?completed=true
     */
    @GetMapping
    public ResponseEntity<List<Todo>> getAllTodos(@RequestParam(required = false) Boolean completed) {
        List<Todo> todos = todoService.getAllTodos(completed);
        return ResponseEntity.ok(todos);
    }

    /**
     * GET /api/v1/todos/{id}
     * Retrieves a single todo by its ID.
     */
    @GetMapping("/{id}")
    public ResponseEntity<Todo> getTodoById(@PathVariable Long id) {
        Todo todo = todoService.getTodoById(id);
        return ResponseEntity.ok(todo);
    }

    /**
     * POST /api/v1/todos
     * Creates a new todo.
     */
    @PostMapping
    public ResponseEntity<Todo> createTodo(@RequestBody Todo todo) {
        Todo createdTodo = todoService.createTodo(todo);
        return new ResponseEntity<>(createdTodo, HttpStatus.CREATED);
    }

    /**
     * PUT /api/v1/todos/{id}
     * Updates an existing todo (title, completed state, priority).
     */
    @PutMapping("/{id}")
    public ResponseEntity<Todo> updateTodo(@PathVariable Long id, @RequestBody Todo todoDetails) {
        Todo updatedTodo = todoService.updateTodo(id, todoDetails);
        return ResponseEntity.ok(updatedTodo);
    }

    /**
     * DELETE /api/v1/todos/{id}
     * Deletes a todo by its ID.
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteTodo(@PathVariable Long id) {
        todoService.deleteTodo(id);
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Todo with id " + id + " deleted successfully");
        return ResponseEntity.ok(response);
    }
}
