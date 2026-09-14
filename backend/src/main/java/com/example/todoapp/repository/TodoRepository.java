package com.example.todoapp.repository;

import com.example.todoapp.model.Todo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * TodoRepository interface extending Spring Data JPA's JpaRepository.
 * Automatically provides standard CRUD methods (findAll, findById, save, deleteById)
 * and custom derived finder queries.
 */
@Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {

    // Find all todos ordered by creation date (newest first)
    List<Todo> findAllByOrderByCreatedAtDesc();

    // Filter todos by completed status, ordered by newest first
    List<Todo> findByCompletedOrderByCreatedAtDesc(boolean completed);
}
