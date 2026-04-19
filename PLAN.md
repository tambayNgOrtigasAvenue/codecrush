# CodeCrush Flutter Implementation Plan

## Context

**What is CodeCrush?** A mobile coding/typing game app with a dark theme and pink accent design system. The app combines typing challenges (Word, Sentence, Binary modes), mini-games (Run, Shoot), a lesson/course browser, and score tracking.

**Figma Source:** `https://www.figma.com/design/Ea0WiOnh5RVGXd4wQw1rwD/cc106---codecrush-`

---

## 1. Design System (extracted from Figma)

### Color Palette
| Token | Hex | Usage |
|-------|-----|-------|
| `darkBackground` | `#3A3440` | Main screen background |
| `darkSurface` | `#2F2935` | Cards, headers, bottom nav, app bar |
| `pink` | `#F694BB` | Primary accent — buttons, active nav, highlights |
| `white` | `#FFFFFF` | Primary text |
| `white50` | `rgba(255,255,255,0.5)` | Secondary/muted text, borders |
| `yellow` | `#F5DA7E` | Highlighted/underlined text in game |
| `green` | `#34A853` / `#ADDCBA` | "Intermediate" badge |
| `orange` | `#FBBC05` / `#FDE49A` | "Advance" badge, duration text |
| `blue` | `#0073FF` / `#CCF4FF` | "Beginner" badge |
| `black20` | `rgba(0,0,0,0.2)` | Button bottom shadow |
| `black15` | `rgba(0,0,0,0.15)` | Text shadow |
| `black25` | `rgba(0,0,0,0.25)` | Card drop shadow |

### Typography
- **Primary Font:** Nunito (all weights: Regular, SemiBold, Bold, ExtraBold, Black)
- **Secondary Fonts:** Poppins (course titles), Inter (course descriptions), Plus Jakarta Sans (badges)
- **Text Sizes:** 48px (splash), 36px (game mode icons), 24px (headers/titles), 20px (labels/body), 16px (card text), 14px (tips/course names), 12px (search bar), 10px (metadata/timestamps)
- **Text Shadow:** All major text has `Shadow(offset: Offset(0, 2), color: rgba(0,0,0,0.15))`

### Button Styles
- **Large Button (homepage):** 152x107, rounded 12px, pink bg, white 50% border, bottom shadow `0px 10px 0px rgba(0,0,0,0.2)`, inner shadow, contains icon/text
- **Medium Button:** rounded 10px, pink bg, bottom shadow `0px 8px 0px rgba(0,0,0,0.2)`, uppercase text
- **Character Card:** 124x130, rounded 15px, dark surface bg, white 50% border, bottom shadow

### Shared Components
- **App Bar:** Dark surface, rounded bottom corners (30px), contains back arrow / title / settings icon
- **Bottom Navigation:** Dark surface, rounded top corners (30px), 3 items — Book (Lessons), Play (Home), Clock (History); active state = pink pill with icon + label
- **Score Item:** Timestamp (right-aligned, muted) + Username/Mode (pink, semibold) + Stats (muted, e.g. "42 wpm - 82%")
- **Course Card (grid):** 152x204, dark surface, cover image, badge (Intermediate/Advance/Beginner), title, description, action bar with lesson count + duration
- **Course List Item:** Horizontal card with icon, title, author, badge, duration, lesson/video count

---

## 2. Screens Inventory

| # | Screen | Description |
|---|--------|-------------|
| 1 | **Splash/Loading** | Full screen dark bg + "CODECRUSH" centered text (48px, Nunito Black, white) |
| 2 | **Home** | App bar ("CODECRUSH" + settings), 3x2 grid of game mode buttons, bottom nav (Play active) |
| 3 | **Game Mode Setup** (e.g. Word) | App bar (back + "WORD" + reset), tips section, "Start Game" button, scrollable high scores + recent scores |
| 4 | **Game Playing** | App bar (back + timer "0:48" + reset), stats row (correct/incorrect/accuracy/speed), text display with color-coded words, text input area, original vs entered comparison below |
| 5 | **Settings** | App bar (back + "CUSTOMIZE" + settings), System section (theme color picker, volume slider), Support section (help, about — with arrow navigation) |
| 6 | **Character Select** | App bar (back + "CUSTOMIZE" + settings), "CHOOSE A CHARACTER" title, 2x2 grid of pixel-art character cards, Save button |
| 7 | **History** | App bar ("CODECRUSH" + settings), scrollable high scores + recent scores (grouped by game mode), bottom nav (History active) |
| 8 | **Lessons** | App bar ("CODECRUSH" + settings), search bar + filter button, category header, 2-column course card grid, bottom nav (Book active) |
| 9 | **Courses Detail** | App bar (back + "COURSES" + settings), search bar + filter, scrollable course list items |

---

## 3. Flutter Project Architecture (Beginner-Friendly)

Using the **feature-first** folder structure recommended by Flutter docs for small-to-medium apps. No heavy state management -- just `StatefulWidget` + `ChangeNotifier` with `Provider` (the simplest recommended approach).

```
lib/
├── main.dart                      # App entry point, MaterialApp, routes
├── app/
│   ├── theme/
│   │   ├── app_colors.dart        # All color constants
│   │   ├── app_text_styles.dart   # All text style presets
│   │   └── app_theme.dart         # ThemeData configuration
│   └── routes.dart                # Named route definitions
├── shared/
│   ├── widgets/
│   │   ├── cc_app_bar.dart        # Reusable custom app bar (dark, rounded bottom)
│   │   ├── cc_bottom_nav.dart     # Bottom navigation bar
│   │   ├── cc_button_large.dart   # Large pink game-mode button
│   │   ├── cc_button_medium.dart  # Medium pink action button
│   │   ├── cc_score_item.dart     # Score entry row (timestamp + name + stats)
│   │   └── cc_course_card.dart    # Course card for grid view
│   └── models/
│       ├── score.dart             # Score data model
│       ├── course.dart            # Course data model
│       └── game_mode.dart         # GameMode enum
├── features/
│   ├── splash/
│   │   └── splash_screen.dart     # Loading/splash screen
│   ├── home/
│   │   └── home_screen.dart       # Homepage with game mode grid
│   ├── game/
│   │   ├── game_setup_screen.dart  # Game mode setup (tips, start, scores)
│   │   ├── game_play_screen.dart   # Active game with typing
│   │   └── game_provider.dart      # Game state (timer, score, words)
│   ├── history/
│   │   └── history_screen.dart     # Score history
│   ├── lessons/
│   │   ├── lessons_screen.dart     # Course grid view
│   │   └── courses_screen.dart     # Course list detail view
│   ├── settings/
│   │   ├── settings_screen.dart    # Theme, volume, help, about
│   │   └── settings_provider.dart  # Settings state (theme, volume)
│   └── customize/
│       └── customize_screen.dart   # Character selection
└── assets/
    ├── fonts/
    │   └── Nunito/                # Nunito font files (.ttf)
    ├── images/
    │   ├── characters/            # Pixel-art character sprites
    │   ├── icons/                 # Custom icons (ghost, game controller)
    │   └── courses/               # Course cover images
    └── icons/                     # SVG/PNG for nav and UI icons
```

### Key Architecture Decisions

1. **State Management: Provider + ChangeNotifier** -- This is the simplest approach recommended by Flutter docs. Each feature that needs state gets a `ChangeNotifier` class (e.g., `GameProvider`, `SettingsProvider`). No complex patterns like BLoC or Riverpod.

2. **Navigation: Named Routes** -- Using `Navigator.pushNamed()` with a central route table in `routes.dart`. Easy to understand for beginners.

3. **Theming: Central ThemeData** -- All colors, text styles, and component themes defined in `app/theme/`. Widgets reference `Theme.of(context)` for consistency.

4. **Reusable Widgets: `cc_` prefix** -- All shared widgets prefixed with `cc_` (CodeCrush) to distinguish from Flutter built-ins.

---

## 4. Implementation Steps

### Phase 1: Project Setup
1. Create Flutter project: `flutter create codecrush`
2. Add dependencies to `pubspec.yaml`:
   - `provider` (state management)
   - `google_fonts` (for Nunito, or bundle Nunito .ttf files)
3. Set up asset folders and register in `pubspec.yaml`
4. Create the theme files (`app_colors.dart`, `app_text_styles.dart`, `app_theme.dart`)
5. Configure `main.dart` with `MaterialApp`, dark theme, and route table

### Phase 2: Shared Components
6. Build `CcAppBar` widget -- dark surface, rounded bottom corners, back/title/action layout
7. Build `CcBottomNav` widget -- 3-tab navigation with active pink pill state
8. Build `CcButtonLarge` widget -- pink button with icon/text, shadows, press effect
9. Build `CcButtonMedium` widget -- smaller pink action button
10. Build `CcScoreItem` widget -- reusable score row

### Phase 3: Core Screens
11. **Splash Screen** -- Timer-based auto-navigate to Home after 2-3 seconds
12. **Home Screen** -- GridView of 6 `CcButtonLarge` widgets + `CcBottomNav`
13. **History Screen** -- ListView of `CcScoreItem` grouped by high scores / recent
14. **Settings Screen** -- Theme picker, volume slider, help/about rows
15. **Customize Screen** -- 2x2 GridView of character cards + Save button

### Phase 4: Game Feature
16. Build `GameProvider` with timer, word generation, scoring logic
17. **Game Setup Screen** -- Tips, Start button, scores list
18. **Game Play Screen** -- Timer, stats bar, text display with color coding, text input, original vs entered comparison

### Phase 5: Lessons Feature
19. Build `Course` model and sample data
20. **Lessons Screen** -- Search bar, filter button, course card grid
21. **Courses Screen** -- Course list with horizontal cards

---

## 5. Key Files to Create

| File | Purpose |
|------|---------|
| `lib/app/theme/app_colors.dart` | `class AppColors` with static const Color fields |
| `lib/app/theme/app_text_styles.dart` | `class AppTextStyles` with static TextStyle methods |
| `lib/app/theme/app_theme.dart` | `ThemeData` builder using AppColors/AppTextStyles |
| `lib/app/routes.dart` | Route name constants + `onGenerateRoute` function |
| `lib/main.dart` | `MultiProvider` wrapping `MaterialApp` |
| `lib/shared/widgets/cc_app_bar.dart` | Custom app bar matching Figma design |
| `lib/shared/widgets/cc_bottom_nav.dart` | Bottom nav with Book/Play/Clock tabs |
| `lib/features/splash/splash_screen.dart` | Animated splash with auto-navigation |
| `lib/features/home/home_screen.dart` | Game mode grid layout |
| `lib/features/game/game_provider.dart` | `ChangeNotifier` for game state |
| `lib/features/game/game_play_screen.dart` | Core typing gameplay screen |

---

## 6. Verification Plan

1. **Run the app:** `flutter run` -- verify splash screen appears and navigates to home
2. **Visual check:** Compare each screen side-by-side with the Figma screenshots
3. **Navigation test:** Tap through all bottom nav tabs, verify correct screen shows with active state
4. **Game flow:** Start a Word game, verify timer counts down, text displays correctly, typing input works
5. **Settings:** Change theme color, adjust volume slider, verify state persists
6. **Responsive check:** Test on different screen sizes (the design targets 390px width / iPhone)

---

## 7. Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  google_fonts: ^6.2.1

flutter:
  uses-material-design: true
  assets:
    - assets/images/characters/
    - assets/images/icons/
    - assets/images/courses/
  fonts:
    - family: Nunito
      fonts:
        - asset: assets/fonts/Nunito/Nunito-Regular.ttf
        - asset: assets/fonts/Nunito/Nunito-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Nunito/Nunito-Bold.ttf
          weight: 700
        - asset: assets/fonts/Nunito/Nunito-ExtraBold.ttf
          weight: 800
        - asset: assets/fonts/Nunito/Nunito-Black.ttf
          weight: 900
```

---

## 8. Flutter Learning Resources

As you work through each phase, here are the key Flutter concepts you'll encounter:

| Phase | Concepts to Learn |
|-------|-------------------|
| Setup | `MaterialApp`, `ThemeData`, `pubspec.yaml` asset registration |
| Shared Widgets | `StatelessWidget`, `Container`, `BoxDecoration`, `BoxShadow`, `BorderRadius` |
| Navigation | `Navigator.pushNamed()`, `onGenerateRoute`, route arguments |
| State | `StatefulWidget`, `setState()`, `ChangeNotifier`, `Provider`, `Consumer` |
| Layouts | `Column`, `Row`, `GridView`, `ListView`, `Stack`, `Padding`, `SizedBox` |
| Game Logic | `Timer`, `TextEditingController`, `FocusNode`, string comparison |
| Styling | `TextStyle`, `Shadow`, `Color`, `EdgeInsets`, custom fonts |

Take it one phase at a time. Build Phase 1, run it, understand it, then move to Phase 2.
