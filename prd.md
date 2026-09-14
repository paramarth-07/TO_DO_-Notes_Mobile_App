# Product Requirement Document (PRD): Todo & Notes Full-Stack System

## 1. Project Overview & Architecture
A synchronized, full-stack productivity suite consisting of:
1. **Backend Service:** Spring Boot (Java) running on an embedded Tomcat server, providing a REST API and business logic.
2. **Web Dashboard:** React (JavaScript + Plain CSS) for desktop management and meeting academic evaluation criteria.
3. **Mobile Client:** Flutter app implementing the **Warm Minimal Tactile** design system.


+---------------------------------------------+
   |             Spring Boot REST API            |
   |          (Java 17/21 + Embedded Tomcat)     |
   |            Spring Data JPA + H2/MySQL       |
   +---------------------------------------------+
                ^                      ^
                | (HTTP JSON)          | (HTTP JSON)
                v                      v
   +-----------------------+ +---------------------+
   | React Web Client      | | Flutter Mobile App  |
   | (JavaScript + CSS)    | | (Dart / Material 3) |
   +-----------------------+ +---------------------+

   ---

## 2. Design System Tokens (Warm Minimal Tactile)
* **Background Canvas:** `#F5F5F3` (Warm neutral oat/cream)
* **Surface Cards:** `#FFFFFF` (Pure white, diffuse drop shadow, 20px–24px radius)
* **Primary Accent:** `#F36C21` (Flame Orange for active states, FAB, and badges)
* **Text Ink Primary:** `#1E1E1E` (Charcoal black)
* **Text Ink Secondary:** `#8A8A8E` (Muted gray for timestamps and subtitles)
* **Typography:** Clean sans-serif (`Plus Jakarta Sans` or system `Roboto`)

---

## 3. Backend: Spring Boot (Java) Architecture
Keep the code strictly layered, boilerplate-free, and easy to explain during code walk-throughs:

### 3.1 Entities
* **`Todo.java`**:
  * `Long id` (Primary Key, Auto-increment)
  * `String title`
  * `boolean completed`
  * `String priority` ("HIGH", "MEDIUM", "LOW")
  * `LocalDateTime createdAt`
* **`Note.java`**:
  * `Long id` (Primary Key, Auto-increment)
  * `String title`
  * `String content` (Rich or plain text snippet)
  * `boolean pinned`
  * `LocalDateTime updatedAt`

### 3.2 Spring Boot REST Endpoints (`/api/v1`)
* `GET /api/v1/todos` — Retrieve all todos (supports query filter: `?completed=true|false`)
* `POST /api/v1/todos` — Create a new todo
* `PUT /api/v1/todos/{id}` — Update todo or toggle completion state
* `DELETE /api/v1/todos/{id}` — Delete a todo
* `GET /api/v1/notes` — Retrieve all notes (pinned notes first)
* `POST /api/v1/notes` — Create a new note
* `PUT /api/v1/notes/{id}` — Update note title/body
* `DELETE /api/v1/notes/{id}` — Delete a note

### 3.3 Persistence
* **Spring Data JPA:** Use standard `JpaRepository<Todo, Long>` and `JpaRepository<Note, Long>` for out-of-the-box CRUD methods (`findAll()`, `save()`, `deleteById()`).
* **Database:** In-memory H2 database (or local MySQL) with `spring.jpa.hibernate.ddl-auto=update` for zero manual table-creation overhead.

---

## 4. Frontend 1: React Web Application (JavaScript + CSS)
A clean single-page administrative dashboard designed to showcase React fundamentals, asynchronous JavaScript, and custom styling:

### 4.1 Component Hierarchy
* `App.jsx`: Global theme wrapper, responsive navigation rail.
* `TodoList.jsx`: Renders active tasks, filter chips ("All", "Pending", "Completed"), and an inline task input bar.
* `TodoItem.jsx`: Individual task item with check toggle, priority badge, and delete button.
* `NotesGrid.jsx`: 2-column or 3-column card grid displaying note previews.
* `NoteEditorModal.jsx`: Modal for creating and editing notes.

### 4.2 State & Network Logic
* Use standard React `useState` and `useEffect` hooks.
* Asynchronous calls handled with standard ES6 `async/await` and native `fetch` or `axios` targeting `http://localhost:8080/api/v1/...`.
* CORS enabled in Spring Boot via `@CrossOrigin(origins = "*")` on controllers.

### 4.3 Styling (`App.css`)
* Pure CSS (Flexbox and CSS Grid) implementing the Warm Minimal palette without heavy external CSS frameworks.

---

## 5. Frontend 2: Mobile Application (Flutter)
A mobile client utilizing standard Material 3 components styled to the Warm Minimal aesthetic:

### 5.1 Screens & Layout
* **MainScreen (`Scaffold`)**:
  * Top App Bar: Minimalist display with greeting and quick stats counter ("3 Pending", "12 Notes").
  * Tab 1 (Tasks): Vertical `ListView.builder` of rounded white cards with circular checkboxes and priority indicators.
  * Tab 2 (Notes): Staggered or vertical list of note cards displaying titles and 2-line body previews.
  * Floating Action Button (FAB): Solid flame-orange (`#F36C21`) circular/squircle button with a `+` icon.
  * Bottom Navigation Bar: Minimalist 2-destination bar (`Tasks`, `Notes`).

### 5.2 Micro-Interactions
* Bottom Sheet modal via `showModalBottomSheet()` for task creation.
* Animated state toggling on checkbox selection.

---

## 6. Presentation Walkthrough Strategy (Viva Guide)
When presenting to college evaluators, frame the project around clear software engineering concepts:

1. **Java & Spring Boot Core:**
   * **Inversion of Control (IoC) & Dependency Injection:** Explain how `@RestController`, `@Service`, and `@Autowired` / constructor injection wire components together.
   * **Spring Data JPA:** Explain how interfaces extending `JpaRepository` eliminate boilerplate SQL queries.
   * **Embedded Tomcat:** Explain that Spring Boot bundles an embedded Tomcat servlet container, allowing the app to run via `mvn spring-boot:run` without external server setup.

2. **JavaScript & React Core:**
   * **Component Lifecycle & Hooks:** Explain how `useEffect` triggers backend fetch calls on component mount and how `useState` dynamically re-renders UI components.
   * **Asynchronous Execution:** Explain the Promise lifecycle (`async/await`) during REST API communication.

3. **Cross-Platform API Reuse:**
   * Emphasize that the Spring Boot backend is decoupled: both the React web dashboard and the Flutter mobile app communicate with the exact same REST endpoints.
