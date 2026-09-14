# TaskFlow Mobile Application (Flutter)

A cross-platform productivity mobile client implementing the **Warm Minimal Tactile** design language, connected to the Spring Boot REST backend service.

---

## 1. Design System & Visual Alignment

The mobile client matches the specifications in `DESIGN.md` and the reference layout in `stitch_material_productivity_workspace_app/screen.png`:

- **Background Canvas (`#F7F7F5` / `#F5F5F3`):** Warm neutral cream canvas reducing screen glare.
- **Card Surfaces (`#FFFFFF`):** Pure white floating cards with `24px` border radius and subtle ambient drop shadows.
- **Flame Orange Accent (`#F36C21`):** Primary operational color used for the Today badge, FAB, progress bar, pinned indicators, and active toggles.
- **Charcoal Ink (`#141414` / `#1E1E1E`):** High-contrast typography using the **Plus Jakarta Sans** font.
- **Bento Metric Tiles:** Dual-tile grid presenting active task progress and quick notes with pinned counters.
- **Tactile Circular Checkbox:** Custom circular toggle with smooth completion and strikethrough animation.

---

## 2. Spring Boot REST API Integration

The app communicates directly with the Spring Boot backend (`/api/v1/todos` and `/api/v1/notes`):

### Dynamic Host Configuration
Different runtime environments reach `localhost:8080` via different addresses:
- **Android Emulator:** `http://10.0.2.2:8080/api/v1` *(Android maps host machine's localhost to 10.0.2.2)*
- **Chrome / Web / Windows Desktop:** `http://localhost:8080/api/v1`
- **Physical Phone (via Wi-Fi):** `http://<YOUR_PC_LOCAL_IP>:8080/api/v1`

> **Interactive Host Switcher:** Tap the **DNS / Settings icon** in the top app bar anytime to instantly switch or customize the API endpoint without recompiling!

---

## 3. Directory Structure

```
mobile_app/
├── pubspec.yaml                 <-- Flutter dependencies (http, google_fonts, intl)
├── README.md                    <-- Setup and viva documentation
└── lib/
    ├── main.dart                <-- App entry point & theme setup
    ├── theme/
    │   └── app_theme.dart       <-- Warm Minimal Tactile colors, text styles, and shadows
    ├── models/
    │   ├── todo.dart            <-- Todo model with fromJson, toJson, copyWith
    │   └── note.dart            <-- Note model with fromJson, toJson, copyWith
    ├── services/
    │   └── api_service.dart     <-- CRUD HTTP calls targeting Spring Boot REST API
    ├── widgets/
    │   ├── workspace_header.dart <-- "Workspace", "Today" badge, search, avatar, host dialog
    │   ├── filter_chips_bar.dart <-- "All Tasks", "Pending", "Notes", "High Priority" pills
    │   ├── metrics_bento_cards.dart <-- 2-tile bento grid (Active Tasks & Quick Notes)
    │   ├── todo_card.dart        <-- Circular checkbox, title, priority pill, 3-dot menu
    │   ├── note_card.dart        <-- Document icon, title, pinned badge, snippet, tags
    │   ├── create_todo_sheet.dart<-- Bottom sheet modal to add/edit task
    │   └── create_note_sheet.dart<-- Bottom sheet modal to add/edit note
    └── screens/
        └── main_screen.dart      <-- Master scaffold, state management, FAB, bottom navigation
```

---

## 4. How to Run

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Spring Boot backend running on `http://localhost:8080`

### Running the App

```bash
cd mobile_app

# Fetch packages
flutter pub get

# Run on connected device or emulator:
flutter run

# Or run directly in Chrome (Web):
flutter run -d chrome

# Or run on Windows Desktop:
flutter run -d windows
```

---

## 5. College Viva / Presentation Talking Points

When presenting this Flutter application to evaluators:

1. **Decoupled Client Architecture:**
   - Emphasize that **both the React Web Dashboard and this Flutter Mobile App consume the exact same Spring Boot REST backend**. Neither client contains hardcoded data; changes made on mobile instantly reflect on the web dashboard upon refresh.
2. **State Management & Asynchronous Network Calls:**
   - Explain how `StatefulWidget` with `setState()` manages UI reactivity, while the `http` package handles REST requests asynchronously using `async/await` and `Future`.
3. **Model Serialization:**
   - Point to `lib/models/todo.dart` and show how factory constructors (`fromJson`) transform backend JSON responses into strongly-typed Dart objects, preventing runtime crashes.
4. **Platform Networking Gotcha:**
   - Explain why `10.0.2.2` is required for Android emulators (loopback alias for host OS) versus `localhost` for web/desktop.
