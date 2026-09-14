# Todo & Notes Spring Boot Backend

A lightweight, robust, and clean Spring Boot RESTful API service built for the Todo & Notes multi-client productivity suite.

---

## 1. Quick Start

### Prerequisites
- **Java 17 or higher** (e.g., OpenJDK / Oracle JDK 17, 21, or 26)
- Maven (or use the included `./mvnw` / `mvnw.cmd` wrapper)

### Running the Application

From within the `backend/` directory, run:

```bash
# On Windows (Command Prompt or PowerShell)
.\mvnw.cmd spring-boot:run

# On macOS / Linux
./mvnw spring-boot:run
```

The application starts on **port 8080**:
- **API Base URL:** `http://localhost:8080/api/v1`
- **H2 In-Memory Database Web Console:** `http://localhost:8080/h2-console`

---

## 2. In-Memory H2 Database & Web Console

This backend uses an embedded, zero-configuration **H2 Database**. No local database installation (such as MySQL or PostgreSQL) is required.

To inspect tables and data live in your web browser:
1. Open: `http://localhost:8080/h2-console`
2. Enter the connection settings from `application.properties`:
   - **JDBC URL:** `jdbc:h2:mem:tododb`
   - **User Name:** `sa`
   - **Password:** *(leave blank)*
3. Click **Connect**. You will see the `TODOS` and `NOTES` tables with auto-seeded demo records.

---

## 3. Architecture: The 4 Clean Layers

The project follows standard Spring enterprise design patterns split across 4 distinct layers:

```
src/main/java/com/example/todoapp/
├── model/                  <-- Layer 1: Data Models & JPA Entities
│   ├── Todo.java
│   └── Note.java
│
├── repository/             <-- Layer 2: Data Access Layer
│   ├── TodoRepository.java
│   └── NoteRepository.java
│
├── service/                <-- Layer 3: Business Logic Layer
│   ├── TodoService.java
│   └── NoteService.java
│
├── controller/             <-- Layer 4: REST API Endpoints & CORS
│   ├── TodoController.java
│   └── NoteController.java
│
├── config/                 <-- Configuration & Seed Data
│   └── DataInitializer.java
│
├── exception/              <-- Uniform JSON Error Responses
│   ├── ResourceNotFoundException.java
│   └── GlobalExceptionHandler.java
│
└── TodoAppApplication.java <-- Spring Boot Main Entry Point
```

### Layer Details:
1. **Model (`model/`)**:
   - `Todo.java`: Entity representing tasks with `id`, `title`, `completed`, `priority` ("HIGH", "MEDIUM", "LOW"), and `createdAt`.
   - `Note.java`: Entity representing notes with `id`, `title`, `content` (TEXT), `pinned`, and `updatedAt`.
2. **Repository (`repository/`)**:
   - Extends `JpaRepository<T, ID>`. Eliminates repetitive SQL queries by leveraging Spring Data JPA derived queries (e.g. `findAllByOrderByPinnedDescUpdatedAtDesc()`).
3. **Service (`service/`)**:
   - Encapsulates business logic, validation, and orchestration. Injects repositories via constructor-based Dependency Injection.
4. **Controller (`controller/`)**:
   - Exposes REST endpoints (`/api/v1/todos`, `/api/v1/notes`) using `@RestController`.
   - Marked with `@CrossOrigin(origins = "*")` to seamlessly connect React web dashboard and Flutter mobile app.

---

## 4. REST API Endpoint Reference

### Todos API (`/api/v1/todos`)

| Method | Endpoint | Description | Query Parameters |
|---|---|---|---|
| `GET` | `/api/v1/todos` | List all todos | `?completed=true` or `false` |
| `GET` | `/api/v1/todos/{id}` | Get a single todo by ID | - |
| `POST` | `/api/v1/todos` | Create a new todo | - |
| `PUT` | `/api/v1/todos/{id}` | Update existing todo | - |
| `DELETE`| `/api/v1/todos/{id}` | Delete a todo | - |

#### Sample Create Todo Request (`POST /api/v1/todos`):
```json
{
  "title": "Complete Final Year Report",
  "priority": "HIGH",
  "completed": false
}
```

---

### Notes API (`/api/v1/notes`)

| Method | Endpoint | Description | Behavior |
|---|---|---|---|
| `GET` | `/api/v1/notes` | List all notes | Sorted with pinned notes first, then latest updated |
| `GET` | `/api/v1/notes/{id}` | Get note by ID | - |
| `POST` | `/api/v1/notes` | Create a new note | - |
| `PUT` | `/api/v1/notes/{id}` | Update note body/pinned | - |
| `DELETE`| `/api/v1/notes/{id}` | Delete note | - |

#### Sample Create Note Request (`POST /api/v1/notes`):
```json
{
  "title": "Design System Tokens",
  "content": "Canvas: #F5F5F3, Card Surface: #FFFFFF, Primary Accent: #F36C21",
  "pinned": true
}
```

---

## 5. College Viva / Presentation Guide

When presenting this project to university evaluators, highlight the following software engineering principles:

### 1. Inversion of Control (IoC) & Dependency Injection (DI)
- **Concept:** Rather than classes instantiating their own dependencies using `new TodoRepository()`, the Spring IoC container creates beans on startup and injects them.
- **Where to show:** Point to [TodoService.java](src/main/java/com/example/todoapp/service/TodoService.java):
  ```java
  public TodoService(TodoRepository todoRepository) {
      this.todoRepository = todoRepository;
  }
  ```
- **Why it matters:** Decouples classes, simplifies unit testing with mocks, and adheres to the Single Responsibility Principle.

### 2. Spring Data JPA & Hibernate ORM
- **Concept:** Object-Relational Mapping (ORM) maps Java entity objects directly to SQL database tables.
- **Where to show:** Point to [TodoRepository.java](src/main/java/com/example/todoapp/repository/TodoRepository.java):
  Notice that `TodoRepository` is an interface with no SQL implementation code! Spring Data automatically generates the queries (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) at runtime.

### 3. Embedded Tomcat Servlet Container
- **Concept:** Traditional Java web applications required installing Apache Tomcat externally and deploying a `.war` file. Spring Boot packages Tomcat *inside* the executable `.jar`.
- **Why it matters:** Portable and self-contained. Anyone can execute `mvn spring-boot:run` without server configuration.

### 4. Cross-Platform Decoupled Architecture
- **Concept:** The backend is client-agnostic. Both the React Web Dashboard and the Flutter Mobile Client communicate with the exact same HTTP JSON endpoints, demonstrating separation of concerns.
