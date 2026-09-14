package com.example.todoapp.controller;

import com.example.todoapp.model.Note;
import com.example.todoapp.service.NoteService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST Controller exposing endpoints for Note operations under /api/v1/notes.
 * @CrossOrigin allows cross-origin communication from web dashboards and mobile clients.
 */
@RestController
@RequestMapping("/api/v1/notes")
@CrossOrigin(origins = "*")
public class NoteController {

    private final NoteService noteService;

    // Constructor injection of NoteService
    public NoteController(NoteService noteService) {
        this.noteService = noteService;
    }

    /**
     * GET /api/v1/notes
     * Retrieves all notes, with pinned notes ordered first.
     */
    @GetMapping
    public ResponseEntity<List<Note>> getAllNotes() {
        List<Note> notes = noteService.getAllNotes();
        return ResponseEntity.ok(notes);
    }

    /**
     * GET /api/v1/notes/{id}
     * Retrieves a specific note by ID.
     */
    @GetMapping("/{id}")
    public ResponseEntity<Note> getNoteById(@PathVariable Long id) {
        Note note = noteService.getNoteById(id);
        return ResponseEntity.ok(note);
    }

    /**
     * POST /api/v1/notes
     * Creates a new note.
     */
    @PostMapping
    public ResponseEntity<Note> createNote(@RequestBody Note note) {
        Note createdNote = noteService.createNote(note);
        return new ResponseEntity<>(createdNote, HttpStatus.CREATED);
    }

    /**
     * PUT /api/v1/notes/{id}
     * Updates an existing note (title, content, pinned state).
     */
    @PutMapping("/{id}")
    public ResponseEntity<Note> updateNote(@PathVariable Long id, @RequestBody Note noteDetails) {
        Note updatedNote = noteService.updateNote(id, noteDetails);
        return ResponseEntity.ok(updatedNote);
    }

    /**
     * DELETE /api/v1/notes/{id}
     * Deletes a note by its ID.
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteNote(@PathVariable Long id) {
        noteService.deleteNote(id);
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Note with id " + id + " deleted successfully");
        return ResponseEntity.ok(response);
    }
}
