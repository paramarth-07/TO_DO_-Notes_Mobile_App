package com.example.todoapp;

import com.example.todoapp.model.Todo;
import com.example.todoapp.repository.TodoRepository;
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
public class TodoControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private TodoRepository todoRepository;

    @Autowired
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        todoRepository.deleteAll();
    }

    @Test
    void testCreateAndGetTodo() throws Exception {
        Todo newTodo = new Todo("Write Report", "HIGH");

        // 1. Test POST /api/v1/todos
        mockMvc.perform(post("/api/v1/todos")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(newTodo)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.title").value("Write Report"))
                .andExpect(jsonPath("$.completed").value(false))
                .andExpect(jsonPath("$.priority").value("HIGH"));

        // 2. Test GET /api/v1/todos
        mockMvc.perform(get("/api/v1/todos"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].title").value("Write Report"));
    }

    @Test
    void testUpdateTodo() throws Exception {
        Todo saved = todoRepository.save(new Todo("Initial Task", "LOW"));

        Todo updatePayload = new Todo("Updated Task", "HIGH");
        updatePayload.setCompleted(true);

        // Test PUT /api/v1/todos/{id}
        mockMvc.perform(put("/api/v1/todos/" + saved.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updatePayload)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Updated Task"))
                .andExpect(jsonPath("$.completed").value(true))
                .andExpect(jsonPath("$.priority").value("HIGH"));
    }

    @Test
    void testDeleteTodo() throws Exception {
        Todo saved = todoRepository.save(new Todo("Task to delete", "MEDIUM"));

        // Test DELETE /api/v1/todos/{id}
        mockMvc.perform(delete("/api/v1/todos/" + saved.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        // Verify it was deleted
        mockMvc.perform(get("/api/v1/todos/" + saved.getId()))
                .andExpect(status().isNotFound());
    }

    @Test
    void testFilterTodosByCompleted() throws Exception {
        Todo completedTodo = new Todo(null, "Done task", true, "LOW");
        Todo pendingTodo = new Todo(null, "Pending task", false, "HIGH");
        todoRepository.save(completedTodo);
        todoRepository.save(pendingTodo);

        // Filter completed=true
        mockMvc.perform(get("/api/v1/todos?completed=true"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].title").value("Done task"));

        // Filter completed=false
        mockMvc.perform(get("/api/v1/todos?completed=false"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].title").value("Pending task"));
    }
}
