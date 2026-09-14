package com.example.todoapp;

import com.example.todoapp.model.Note;
import com.example.todoapp.repository.NoteRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class NoteControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private NoteRepository noteRepository;

    @Autowired
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        noteRepository.deleteAll();
    }

    @Test
    void testCreateAndGetNotesOrderedByPinned() throws Exception {
        Note unpinnedNote = new Note("Regular Note", "Normal description", false);
        Note pinnedNote = new Note("Important Note", "Must be pinned on top", true);

        noteRepository.save(unpinnedNote);
        noteRepository.save(pinnedNote);

        // GET /api/v1/notes should return pinned note first
        mockMvc.perform(get("/api/v1/notes"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[0].title").value("Important Note"))
                .andExpect(jsonPath("$[0].pinned").value(true))
                .andExpect(jsonPath("$[1].title").value("Regular Note"))
                .andExpect(jsonPath("$[1].pinned").value(false));
    }

    @Test
    void testCreateNoteViaPost() throws Exception {
        Note newNote = new Note("New Architecture Note", "Spring Boot + H2", true);

        mockMvc.perform(post("/api/v1/notes")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(newNote)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.title").value("New Architecture Note"))
                .andExpect(jsonPath("$.pinned").value(true))
                .andExpect(jsonPath("$.updatedAt").exists());
    }

    @Test
    void testUpdateNote() throws Exception {
        Note saved = noteRepository.save(new Note("Old Note", "Old Content", false));

        Note updatePayload = new Note("Revised Note", "Revised Content", true);

        mockMvc.perform(put("/api/v1/notes/" + saved.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updatePayload)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Revised Note"))
                .andExpect(jsonPath("$.content").value("Revised Content"))
                .andExpect(jsonPath("$.pinned").value(true));
    }

    @Test
    void testDeleteNote() throws Exception {
        Note saved = noteRepository.save(new Note("Disposable Note", "Content", false));

        mockMvc.perform(delete("/api/v1/notes/" + saved.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        mockMvc.perform(get("/api/v1/notes/" + saved.getId()))
                .andExpect(status().isNotFound());
    }
}
