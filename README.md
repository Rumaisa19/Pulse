# PULSE — News Engine for Android

PULSE is an offline-first news application for Android built on The Guardian API.
Delivers real-time global news through a clean repository architecture with full
offline availability, reactive state management, and premium UX patterns.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State Management | Provider |
| Networking | Dio + JsonSerializable |
| Local Storage | Hive NoSQL |
| Navigation | GoRouter |
| Offline Detection | Connectivity Plus |
| Security | flutter_dotenv |

---

## Architecture

Clean Repository Pattern — three distinct layers:

- **Presentation** — Modular screens and widgets consuming `NewsProvider.`
- **Repository** — Orchestrates network vs cache decision via `connectivity_plus.`
- **Data** — JSON-to-Hive model mapping via generated `TypeAdapters.`

---

## Features

- Offline-first — full article availability without a network
- Smart search with debounce to minimize API calls
- Shimmer skeleton loading states
- CachedNetworkImage for optimized bandwidth
- Dark and light theme support
- GoRouter deep-link-ready navigation
- API credentials isolated via `.env` — never hardcoded

---

## Screenshots

### Light Mode

**Splash**  
<img src="assets/screenshots/light theme/1.splash_screen.jpeg" width="400" alt="Light Mode Dashboard – Real-time Ledger" />

**Home**  
<img src="assets/screenshots/light theme/2.home_Screen.jpeg" width="400" alt="Light Mode Analytics – Weekly Insights" />

**Saved**  
<img src="assets/screenshots/light theme/3.saved_stories.jpeg" width="400" alt="Light Mode Add Expense Screen" />

**Settings**  
<img src="assets/screenshots/light theme/4.settings_screen.jpeg" width="400" alt="Light Mode Add Expense Screen" />

### Dark Mode

**Splash**  
<img src="assets/screenshots/dark theme/1.splash_screen.jpeg" width="400" alt="Light Mode Dashboard – Real-time Ledger" />

**Home**  
<img src="assets/screenshots/dark theme/2.home_Screen.jpeg" width="400" alt="Light Mode Analytics – Weekly Insights" />

**Saved**  
<img src="assets/screenshots/dark theme/3.saved_stories.jpeg" width="400" alt="Light Mode Add Expense Screen" />

**Settings**  
<img src="assets/screenshots/dark theme/4.settings_screen.jpeg" width="400" alt="Light Mode Add Expense Screen" />

---

## Setup

1. Clone
```bash
git clone https://github.com/Rumaisa19/Pulse.git
cd Pulse
```

2. Add your Guardian API key
```
assets/.env
GUARDIAN_API_KEY=your_key_here
```

3. Run code generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run
```bash
flutter run
```

---

## Developer

**Rumaisa Mushtaq** — Flutter Developer
- GitHub: [Rumaisa19](https://github.com/Rumaisa19)
- LinkedIn: [rumaisamushtaq](https://linkedin.com/in/rumaisamushtaq)
```

