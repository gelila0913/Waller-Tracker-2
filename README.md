# Flutter Clean Architecture CRUD Application (Provider & HTTP Edition)

A production-ready Flutter application demonstrating complete **CRUD (Create, Read, Update, Delete)** operations. The project consumes a live, publicly available REST API using the native **HTTP** network client package and implements the **Provider** state management ecosystem following absolute **Clean Architecture** patterns.

---

## 🛠️ Tech Stack & Architecture Blueprint

This application implements **Clean Architecture** by separating the software into isolated layers (Data, Domain, and Presentation). This decoupling ensures that the core business rules are completely independent of external packages, databases, and UI components, making the codebase scalable, maintainable, and highly testable.

### Core Stack
* **State Management:** `provider` (v6.1+) & `equatable`
* **HTTP Network Client:** `http` (v1.2+)
* **Architecture Rules:** Feature-First Clean Architecture (Data ➔ Domain ➔ Presentation)
* **API Target Endpoint:** JSONPlaceholder REST API (`https://jsonplaceholder.typicode.com/posts`)

### Architectural Layers
1. **Domain Layer:** The independent core containing the blueprint definition contract. It holds business rules, entity models (`PostEntity`), and abstract repository boundaries.
2. **Data Layer:** The infrastructure implementation. It manages the serialization models (`PostModel`), remote data sources (`PostRemoteDataSource` handling native HTTP requests), and concrete repository implementations handling error code transformations.
3. **Presentation Layer:** The UI visual canvas and reactive states. It encapsulates the change notifier controllers (`PostProvider`), interactive view screens, responsive layout elements, and user form dialogues.

---

## 📂 Complete Project Directory Structure

Below is the absolute file structure mapping of the application workspace inside the `lib/` root folder:

```text
lib/
├── core/
│   ├── errors/
│   │   └── failures.dart              # Core translation maps for exceptions
├── features/
│   └── posts/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── post_remote_datasource.dart # Native HTTP request implementation
│       │   ├── models/
│       │   │   └── post_model.dart             # JSON serialization logic
│       │   └── repositories/
│       │       └── post_repository_impl.dart   # Implements domain contract
│       ├── domain/
│       │   ├── entities/
│       │   │   └── post_entity.dart            # Core structural business model
│       │   └── repositories/
│       │       └── post_repository.dart        # Abstract repository contract
│       └── presentation/
│           ├── provider/
│           │   └── post_provider.dart          # ChangeNotifier State Controller
│           ├── pages/
│           │   └── posts_page.dart             # Main screen display list view
│           └── widgets/
│               ├── post_card_item.dart         # Reusable card UI component
│               └── post_form_dialog.dart       # Form creation layout helper
└── main.dart                                  # Global root initialization container

## 👥 Developed by

This application was engineered and compiled as part of the formal Software Engineering evaluation curriculum.

* **Developer:** Gelila Sintayehu  
* **Section:** Section-2  
* **Student ID:** UGR/3508/16  
* **Institution:** Addis Ababa University, Science and Technology Campus (AAiT)
