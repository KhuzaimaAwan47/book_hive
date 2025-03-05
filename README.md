# Book Hive 📚

A Flutter app to search for books using the Google Books API and save favorites locally. Supports theme switching (light/dark) and uses `sqflite` for local storage.

## Features

- **Search Books**: Search for books by title, author, or keyword using the Google Books API.
- **Favorites**: Save favorite books to a local SQLite database.
- **Theme Switching**: Toggle between light/dark themes.
- **Responsive UI**: Works on mobile and desktop platforms.

## Installation

1. **Prerequisites**:
    - Flutter SDK (version 3.0 or newer)
    - Dart (version 3.0 or newer)

2. **Packages used**
    - shared_preferences: ^2.5.2
    - provider: ^6.1.2
    - path: ^1.9.1
    - http: ^1.3.0
    - sqflite: ^2.4.2
    - path_provider: ^2.1.5

2. **Clone the repository**:
   ```bash
   git clone https://github.com/KhuzaimaAwan47/book_finder.git
   cd book_finder
## Technologies Used

- **Flutter**: UI framework for building cross-platform applications.
- **Dart**: Programming language used for Flutter development.
- **Google Books API**: Provides book search data and metadata.
- **sqflite**: Local SQLite database for storing favorite books.
- **Provider**: State management solution for Flutter apps.

## Troubleshooting

### Thumbnails Not Loading
- **HTTPS Enforcement**: Book thumbnails are forced to use HTTPS in the `Book.fromJson()` constructor.
- **CORS Issues**: During development, use a browser extension or configure your development environment to handle CORS policies.
- **Invalid URLs**: Debug by checking printed thumbnail URLs in the console (added in `Book.fromJson()`).

### Database Errors
- **Desktop Platforms**:
  ```dart
  // Add this initialization in main.dart
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;