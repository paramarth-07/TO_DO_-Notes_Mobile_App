package com.example.todoapp.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Note Entity representing a text or rich-text note snippet.
 * Mapped to the 'notes' table in the H2 database.
 */
@Entity
@Table(name = "notes")
public class Note {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String content;

    private boolean pinned = false;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    // Default constructor required by JPA
    public Note() {
    }

    // Parameterized constructor for convenience
    public Note(String title, String content, boolean pinned) {
        this.title = title;
        this.content = content;
        this.pinned = pinned;
    }

    public Note(Long id, String title, String content, boolean pinned) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.pinned = pinned;
    }

    // Automatically update timestamp before insert or update operations
    @PrePersist
    protected void onCreate() {
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isPinned() {
        return pinned;
    }

    public void setPinned(boolean pinned) {
        this.pinned = pinned;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Note{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", pinned=" + pinned +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
