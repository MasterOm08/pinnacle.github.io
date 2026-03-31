# Padhoplay: Educational App for Rural Children (Grades 1-6)

This document outlines the architecture, feature breakdown, and tech stack for **Padhoplay**, an offline-first, gamified learning platform tailored for rural children in grades 1 through 6. 

The primary focus is to build a Duolingo-style app with a gently scaling difficulty curve, heavy reliance on visuals and voice-overs, bilingual support, and robust offline capabilities.

## User Review Required

> [!IMPORTANT]
> Please review the chosen technical stack and the offline-first strategy below. Since an offline-first experience is critical for rural areas with patchy internet, we propose using **Service Workers (PWA)** combined with **IndexedDB (via Dexie.js)** to heavily cache assets and sync progress logic automatically.

> [!WARNING]
> Building a full offline app means the first load of the app will need an internet connection to download the necessary assets (images, audio snippets, and lesson data). Are you okay with the initial setup requring a stable internet connection?

## Technical Stack

*   **Core framework**: React via Vite (fast bundling, excellent PWA support).
*   **Styling**: Vanilla CSS (modular, performant, dynamic micro-animations) built around the requested primary palette (Blue, White, Red).
*   **Offline capability**: 
    *   **Vite PWA Plugin**: To cache the application shell, UI assets, icons, and audio.
    *   **Dexie.js (IndexedDB wrapper)**: To locally store all app content (450 questions per grade), user profiles, and sync queues for teacher/student progress.
*   **Localization**: `i18next` for seamless English/Hindi toggling.
*   **Voice-over & Accessibility**: Web Speech API for synthesizing on-screen text, along with abundant visual cues (SVG icons).
*   **Routing**: `react-router-dom` for switching between Teacher Dashboard and Student views.

## App Architecture

### Teacher Architecture
*   **Dashboard**: Overview of classes and enrolled students.
*   **Student Management**: UI to add/remove students from a specific class.
*   **Progress Tracking**: Real-time stats on completed lessons, subject mastery, and login frequency (synced when online).

### Student Architecture
*   **Profile Selection**: Simple, highly visual login/profile selection to support multiple students on a single device.
*   **Gamified Map (The "Tree")**: A Duolingo-style progression path where subjects (English, Math, Science) are broken down into units and lessons. 
    *   *Math:* 10 Units → 3 Lessons/Unit → 5 Questions/Lesson.
*   **Learning Interface**: The quiz UI. Large touch targets, vivid visual feedback (green for correct, red/orange for incorrect, accompanied by corresponding sound effects/voice-overs).

## Proposed Implementation Phases

### Phase 1: Project Setup & Design System
*   Initialize Vite React app.
*   Establish `index.css` with CSS variables for the Blue, White, and Red theme.
*   Set up localization (English/Hindi).
*   Configure the Vite PWA plugin for application asset caching.

### Phase 2: Offline Data Layer
*   Initialize Dexie.js database schemas for `users`, `classes`, `progress`, and `lessons`.
*   Mock the hierarchical question structure (10 units, 30 lessons, 150 questions per subject).

### Phase 3: Core UI Components
*   Design universal buttons, bilingual toggle headers, gamified progression nodes (map UI).
*   Build the core Learning/Quiz component with voice-over button support.

### Phase 4: Teacher & Student Views Assembly
*   Build the Teacher Dashboard & stats viewer.
*   Connect the Student map nodes to the underlying question datastore.
*   Integrate visual rewards (stars, animations) upon lesson completion.

## Open Questions

1.  **Authentication Mode**: Given the target demographic (rural kids), should the student login be passwordless (e.g., picking a picture or a 4-digit PIN), or just choosing a profile picture on a shared device?
2.  **Voice-over Implementation**: We can use the browser's native Text-to-Speech (Web Speech API) which supports basic Hindi and English. Does this suffice, or do you eventually plan to provide pre-recorded human MP3 files for questions?
3.  **Content Mocking**: For now, do you want me to generate placeholder questions perfectly mirroring the exact mathematical structure (5 qs × 3 lessons × 10 units = 150 per subject) to validate the app flow?

## Verification Plan

### Automated Tests
*   Run local dev builds and verify Vite PWA offline readiness.
*   Simulate offline networks via Developer Tools to prove the app loads, lessons play out, and progress saves to IndexedDB locally.

### Manual Verification
*   Please open the application on a local browser (or phone) to test the UI aesthetics (Blue, White, Red), the "cute" visual scale, and English/Hindi layout text switches.
*   Interact with the student gamified map to ensure difficulty curves scale smoothly between units.
