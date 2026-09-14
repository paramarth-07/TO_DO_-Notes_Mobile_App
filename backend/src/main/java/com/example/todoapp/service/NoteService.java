package com.example.todoapp.service;

import com.example.todoapp.exception.ResourceNotFoundException;
import com.example.todoapp.model.Note;
import com.example.todoapp.repository.NoteRepository;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Service Layer containing business logic for Note management.
 * Injects NoteRepository through constructor injection.
 */
@Service
public class NoteService {

    private final NoteRepository noteRepository;

    // Constructor injection
    public NoteService(NoteRepository noteRepository) {
        this.noteRepository = noteRepository;
    }

    // Retrieve all notes with pinned notes sorted to the top
    public List<Note> getAllNotes() {
        return noteRepository.findAllByOrderByPinnedDescUpdatedAtDesc();
    }

    // Retrieve a single note by ID
    public Note getNoteById(Long id) {
        return noteRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Note not found with id: " + id));
    }

    // Create a new note
    public Note createNote(Note note) {
        return noteRepository.save(note);
    }

    // Update an existing note
    public Note updateNote(Long id, Note updatedNote) {
        Note existingNote = getNoteById(id);

        if (updatedNote.getTitle() != null) {
            existingNote.setTitle(updatedNote.getTitle());
        }
        if (updatedNote.getContent() != null) {
            existingNote.setContent(updatedNote.getContent());
        }
        existingNote.setPinned(updatedNote.isPinned());

        return noteRepository.save(existingNote);
    }

    // Delete a note by ID
    public void deleteNote(Long id) {
        Note existingNote = getNoteById(id);
        noteRepository.delete(existingNote);
    }
}
