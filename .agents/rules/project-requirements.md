# Product Catalogue App — Project Requirements

## Overview
A Flutter product catalogue app powered by the free [DummyJSON API](https://dummyjson.com/docs/products). No login required.

## Tech Stack
- **Framework:** Flutter (latest stable via FVM)
- **State Management:** Provider
- **Local Persistence:** SharedPreferences (for favourites and recent searches)
- **HTTP Client:** http package
- **Flutter Version Manager:** FVM

## API Endpoints Used
| Purpose | Endpoint |
|---|---|
| Get all products (paginated) | `GET /products?limit=20&skip={offset}` |
| Search products | `GET /products/search?q={query}&limit=20&skip={offset}` |
| Get single product | `GET /products/{id}` |

## Feature Requirements

### 1. Product List (Home Screen)
- Display products as a list/grid showing: **image, name, price, rating**
- Load **20 items at a time** with **infinite scroll** (load more on scroll to bottom)
- **Pull-to-refresh** support
- **Favourite button** on each product card

### 2. Search
- Search bar at the top that searches products by name via the DummyJSON search endpoint
- Infinite scroll also applies to search results
- **Recent Searches:**
  - Show last **5 searches**, most recent on top
  - **No duplicates** — searching the same word moves it to the top
  - Tapping a recent search **runs it again**
  - Option to **clear all** recent searches
  - Must **persist** after app close/reopen (SharedPreferences)

### 3. Product Detail Page
- Opened by tapping a product in the list
- Shows: **images** (carousel/swipeable), **description**, **price**, **stock**
- Favourite button available here as well

### 4. Favourites
- Heart/favourite button on product cards and detail page
- Favourites must **persist** after app close/reopen (SharedPreferences)

### 5. Error Handling & States
- **Loading state:** Show loading indicator while fetching data
- **Empty results:** Show a friendly "No products found" message
- **No-internet / error:** Show error message with a **Retry** button
- All states apply to both product list and search results

## Architecture Guidelines
- Use **Provider** for state management across the app
- Separate concerns: `models/`, `providers/`, `services/`, `screens/`, `widgets/`
- API calls in a dedicated service class
- Models should use `fromJson` factory constructors
- Keep widget trees clean — extract reusable widgets

## Project Structure
```
lib/
├── main.dart
├── models/
│   └── product.dart
├── providers/
│   ├── product_provider.dart
│   ├── favourites_provider.dart
│   └── recent_searches_provider.dart
├── services/
│   └── api_service.dart
├── screens/
│   ├── home_screen.dart
│   └── product_detail_screen.dart
├── widgets/
│   ├── product_card.dart
│   ├── search_bar_widget.dart
│   ├── recent_searches_widget.dart
│   └── error_widget.dart
└── utils/
    └── constants.dart
```

## Design
- Modern Material Design 3
- Clean, minimal UI with proper spacing
- Smooth transitions and animations
- Responsive layout

## Rules
- AI tools are allowed
- State management choice (Provider) must be explained in README.md
