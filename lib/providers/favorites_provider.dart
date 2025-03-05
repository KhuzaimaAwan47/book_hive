import 'package:bookhive/auth/database_helper.dart';
import 'package:bookhive/models/books_model.dart';
import 'package:flutter/foundation.dart';

class FavoriteBooksProvider with ChangeNotifier {
  List<Book> _favorites = [];
  bool _isLoading = true;

  List<Book> get favorites => _favorites;
  bool get isLoading => _isLoading;

  FavoriteBooksProvider() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _favorites = await DatabaseHelper().getFavorites();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addFavorite(Book book) async {
    try {
      await DatabaseHelper().insertFavorite(book);
      if (! _favorites.any((b) => b.id == book.id)) {
        _favorites.add(book);
      }
      notifyListeners();
    } catch (e) {
    }
  }

  Future<void> removeFavorite(String bookId) async {
    try {
      await DatabaseHelper().removeFavorite(bookId);
      _favorites.removeWhere((book) => book.id == bookId);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}