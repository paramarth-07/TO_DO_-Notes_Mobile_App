package com.example.todoapp.repository;

import com.example.todoapp.model.Note;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * NoteRepository interface extending Spring Data JPA's JpaRepository.
 * Provides out-of-the-box CRUD operations and custom query methods.
 */
@Repository
public interface NoteRepository extends JpaRepository<Note, Long> {

    // Retrieve all notes ordered with pinned items first, then by last updated timestamp
    List<Note> findAllByOrderByPinnedDescUpdatedAtDesc();
}
