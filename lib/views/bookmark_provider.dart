import 'package:flutter/material.dart';
import 'package:matchupnews/views/home_screen.dart';
// Pastikan `News` bisa diakses

class BookmarkProvider extends ChangeNotifier {
  final List<News> _bookmarkedArticles = [];

  List<News> get bookmarks => _bookmarkedArticles;

  void toggleBookmark(News news) {
    if (_bookmarkedArticles.contains(news)) {
      _bookmarkedArticles.remove(news);
    } else {
      _bookmarkedArticles.add(news);
    }
    notifyListeners();
  }

  void removeBookmark(News news) {
    _bookmarkedArticles.remove(news);
    notifyListeners();
  }

  bool isBookmarked(News news) {
    return _bookmarkedArticles.contains(news);
  }
}
