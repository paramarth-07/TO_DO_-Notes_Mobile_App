package com.example.todoapp.config;

import com.example.todoapp.model.Note;
import com.example.todoapp.model.Todo;
import com.example.todoapp.repository.NoteRepository;
import com.example.todoapp.repository.TodoRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * DataInitializer seeds sample data into the in-memory H2 database on application startup.
 * Ensures the React web and Flutter clients immediately display live data during demonstrations.
 */
@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner initDatabase(TodoRepository todoRepository, NoteRepository noteRepository) {
        return args -> {
            // Seed Todos if database is empty
            if (todoRepository.count() == 0) {
                todoRepository.save(new Todo(null, "Finalize Project Presentation Slides", false, "HIGH"));
                todoRepository.save(new Todo(null, "Implement React Web Dashboard components", false, "MEDIUM"));
                todoRepository.save(new Todo(null, "Test Spring Boot REST API endpoints in Postman", true, "LOW"));
                todoRepository.save(new Todo(null, "Setup Flutter Warm Minimal design tokens", false, "MEDIUM"));
            }

            // Seed Notes if database is empty
            if (noteRepository.count() == 0) {
                noteRepository.save(new Note(
                        null,
                        "Project Architecture Overview",
                        "The backend is built with Spring Boot 3 + H2 In-Memory DB. Decoupled frontend clients (React & Flutter) consume the same RESTful API endpoints at /api/v1.",
                        true // Pinned note
                ));
                noteRepository.save(new Note(
                        null,
                        "Color Palette Tokens",
                        "Canvas: #F5F5F3, Card Surface: #FFFFFF, Primary Accent: #F36C21 (Flame Orange), Ink: #1E1E1E.",
                        false
                ));
                noteRepository.save(new Note(
                        null,
                        "Viva Discussion Topics",
                        "1. Inversion of Control & DI\n2. Spring Data JPA repository pattern\n3. Embedded Tomcat servlet container vs standalone server",
                        true // Pinned note
                ));
            }
        };
    }
}
