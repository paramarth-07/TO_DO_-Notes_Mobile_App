package com.example.todoapp.service;

import com.example.todoapp.exception.ResourceNotFoundException;
import com.example.todoapp.model.Todo;
import com.example.todoapp.repository.TodoRepository;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Service Layer containing business logic for Todo management.
 * Uses constructor-based Dependency Injection to access TodoRepository.
 */
@Service
public class TodoService {

    private final TodoRepository todoRepository;

    // Constructor injection: Promotes loose coupling and testability
    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    // Retrieve all todos, with optional filtering by completed status
    public List<Todo> getAllTodos(Boolean completed) {
        if (completed != null) {
            return todoRepository.findByCompletedOrderByCreatedAtDesc(completed);
        }
        return todoRepository.findAllByOrderByCreatedAtDesc();
    }

    // Retrieve a single todo by its ID
    public Todo getTodoById(Long id) {
        return todoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Todo not found with id: " + id));
    }

    // Create and persist a new todo
    public Todo createTodo(Todo todo) {
        return todoRepository.save(todo);
    }

    // Update an existing todo
    public Todo updateTodo(Long id, Todo updatedTodo) {
        Todo existingTodo = getTodoById(id);

        if (updatedTodo.getTitle() != null) {
            existingTodo.setTitle(updatedTodo.getTitle());
        }
        existingTodo.setCompleted(updatedTodo.isCompleted());

        if (updatedTodo.getPriority() != null) {
            existingTodo.setPriority(updatedTodo.getPriority());
        }

        return todoRepository.save(existingTodo);
    }

    // Delete a todo by ID
    public void deleteTodo(Long id) {
        Todo existingTodo = getTodoById(id);
        todoRepository.delete(existingTodo);
    }
}
