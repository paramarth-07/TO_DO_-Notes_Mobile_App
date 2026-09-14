package com.example.todoapp.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Todo Entity representing a single task item.
 * Mapped to the 'todos' table in the H2 database.
 */
@Entity
@Table(name = "todos")
public class Todo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    private boolean completed = false;

    @Column(nullable = false)
    private String priority = "MEDIUM"; // "HIGH", "MEDIUM", "LOW"

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    // Default constructor required by JPA
    public Todo() {
    }

    // Parameterized constructor for convenience
    public Todo(String title, String priority) {
        this.title = title;
        this.priority = priority != null ? priority : "MEDIUM";
        this.completed = false;
    }

    public Todo(Long id, String title, boolean completed, String priority) {
        this.id = id;
        this.title = title;
        this.completed = completed;
        this.priority = priority != null ? priority : "MEDIUM";
    }

    // Automatically set createdAt timestamp before persisting to database
    @PrePersist
    protected void onCreate() {
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
        if (this.priority == null || this.priority.trim().isEmpty()) {
            this.priority = "MEDIUM";
        }
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Todo{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", completed=" + completed +
                ", priority='" + priority + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
