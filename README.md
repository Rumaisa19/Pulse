# PULSE News

**PULSE** is a high-performance, minimalist news engine built for Android. It leverages **The Guardian API** to deliver real-time global news through a sophisticated, offline-first architecture.

## 🚀 Key Technical Features

- **Offline-First Strategy:** Implemented using **Hive (NoSQL)** for blazingly fast local storage and 100% offline availability of cached articles via local persistence.
- **Reactive State Management:** Utilizes the **Provider** pattern to maintain a clean unidirectional data flow and synchronize the UI with the repository.
- **Type-Safe API Integration:** Built with **Dio** and **JsonSerializable** for robust HTTP networking and automated JSON-to-Model mapping.
- **Smart Search:** Features custom **Debouncing** logic to minimize API overhead and enhance user experience during keyword queries.
- **Dynamic Navigation:** Powered by **GoRouter** for declarative, deep-link-ready routing within the application.
- **Premium UX:** Includes **Shimmer** effects for skeleton loading states and **CachedNetworkImage** for optimized image handling and bandwidth saving.

---

## 🛠️ Tech Stack

| Layer                 | Technology                            |
| :-------------------- | :------------------------------------ |
| **Framework**         | Flutter ^3.10.7                       |
| **State Management**  | Provider                              |
| **Networking**        | Dio                                   |
| **Local Database**    | Hive & Hive Flutter                   |
| **Navigation**        | GoRouter                              |
| **Offline Detection** | Connectivity Plus                     |
| **Design System**     | Google Fonts & Custom w900 Typography |

---

## 🏗️ Architectural Overview

The app follows a **Clean Repository Pattern**:

1.  **UI Layer:** Modular widgets and specialized screens listening to the `NewsProvider`.
2.  **Domain/Repository Layer:** The `NewsRepository` acts as the orchestrator. It checks network status via `connectivity_plus` and decides whether to fetch fresh data from **The Guardian** or serve stored articles from **Hive**.
3.  **Data Layer:** Handles raw JSON responses and maps them to Hive-enabled `Article` models using generated `TypeAdapters`.

---

## 📦 Installation & Configuration

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/Rumaisa19/pulse_news.git](https://github.com/Rumaisa19/pulse_news.git)
    ```
2.  **Environment Setup:**
    - Ensure your `assets/.env` file exists.
    - Add your Guardian API Key: `GUARDIAN_API_KEY=your_key_here`.
3.  **Code Generation:**
    This project uses `json_serializable` and `hive_generator`. Run the following to generate the necessary adapters:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
4.  **Launch:**
    ```bash
    flutter run
    ```

---

## 👤 Developer

- **Project Track:** Expert Flutter Developer.

---

### Final Project Note

This app is optimized for **Android**. It ensures strict security by utilizing `flutter_dotenv` to keep API credentials out of the source code and utilizes **Section Mapping** to bridge UI categories to specific Guardian API backend identifiers.
