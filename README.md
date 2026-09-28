# Product Catalogue App

A Flutter product catalogue app powered by the [DummyJSON API](https://dummyjson.com/docs/products).

## Features & Completed Requirements

- ✅ **Product List** — Browse products displayed in a beautiful grid with images, names, prices, and ratings.
- ✅ **Infinite Scroll** — Products load 20 at a time, with more loading seamlessly as you scroll to the bottom.
- ✅ **Search** — Search products by name using the DummyJSON search endpoint.
- ✅ **Product Detail** — Tapping a product opens a detail page showing a swipeable image carousel, description, price, and stock status.
- ✅ **Error & Loading States** — Handled loading, empty results, and no-internet states with a retry button.
- ✅ **Pull-to-Refresh** — Pull down to refresh the product list or search results.
- ✅ **Favourites** — Heart button on products. Favourites persist after the app is closed and reopened using local storage.
- ✅ **Recent Searches** — Shows under the search bar when tapped:
  - Saved the last 5 searches, most recent on top.
  - No duplicates (searching the same word again moves it to the top).
  - Persisted after the app is closed and reopened.
- ✅ **UI Separation** — Separated UI and pure functions into different folders (`functions/` layer).
- ✅ **Customizations** — Added a custom Splash Screen and updated the App Icon/Logo.

## State Management Choice: Provider

**Why Provider?**

Provider was chosen as the state management solution for this project for several reasons:

1. **Simplicity** — Provider is built on top of Flutter's `InheritedWidget` and integrates seamlessly with the framework. It requires minimal boilerplate compared to alternatives like BLoC or Redux.
2. **Official Recommendation** — Provider is recommended by the Flutter team as a pragmatic approach to state management for most apps.
3. **Separation of Concerns** — Provider encourages clean separation between UI and business logic through `ChangeNotifier` classes, making the code testable and maintainable.
4. **Scalability** — While simple, Provider scales well for apps of this size. The three providers (`ProductProvider`, `FavouritesProvider`, `RecentSearchesProvider`) each manage a distinct piece of state, keeping responsibilities clear.
5. **Minimal Learning Curve** — Provider is easy to understand for developers at all levels, making the codebase accessible and easy to onboard.

### Architecture Layers

| Layer | Responsibility |
|---|---|
| `Screens & Widgets` (UI) | Displays data and captures user input. Listens to Providers. |
| `Providers` (State) | Holds application state and notifies UI of changes. |
| `Functions` (Logic) | Handles business logic, data formatting, and coordinates with Services. |
| `Services` (API/DB) | Performs raw HTTP requests or local storage read/writes. |

## Tech Stack

- **Flutter** 3.47.5 (managed via **FVM**)
- **Provider** for state management
- **SharedPreferences** for local persistence
- **cached_network_image** for image caching and optimized loading
- **DummyJSON API** for product data

## Project Structure

```
lib/
├── main.dart                          # App entry point, providers, theme
├── models/
│   ├── product.dart                   # Product data model
│   └── products_response.dart         # API pagination response model
├── providers/
│   ├── product_provider.dart          # Product list & search state
│   ├── favourites_provider.dart       # Favourites state
│   └── recent_searches_provider.dart  # Recent searches state
├── functions/
│   ├── product_functions.dart         # Product business logic
│   ├── favourites_functions.dart      # Favourites persistence logic
│   └── recent_searches_functions.dart # Searches persistence logic
├── services/
│   └── api_service.dart               # DummyJSON API client
├── screens/
│   ├── splash_screen.dart             # Custom animated splash screen
│   ├── home_screen.dart               # Home with search & product grid
│   └── product_detail_screen.dart     # Product detail with image carousel
├── widgets/
│   ├── product_card.dart              # Product grid card widget
│   ├── error_widget.dart              # Error & empty state widgets
│   └── recent_searches_widget.dart    # Recent searches dropdown
└── utils/
    └── constants.dart                 # API URL, page size constants
```

## Getting Started

### Prerequisites

- [FVM (Flutter Version Management)](https://fvm.app/) installed.
- Android/iOS development environment set up.

### Setup & Run

We use FVM to ensure everyone uses the exact same Flutter version. Always prefix your flutter commands with `fvm`.

```bash
# 1. Install the specific Flutter version defined in .fvmrc
fvm install

# 2. Get dependencies
fvm flutter pub get

# 3. Run the app on an emulator or connected device
fvm flutter run
```

## API Endpoints Used

| Purpose | Endpoint |
|---|---|
| Get products (paginated) | `GET /products?limit=20&skip={offset}` |
| Search products | `GET /products/search?q={query}&limit=20&skip={offset}` |
| Get single product | `GET /products/{id}` |
