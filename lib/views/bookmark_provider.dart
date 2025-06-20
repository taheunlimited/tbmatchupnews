import 'package:flutter/foundation.dart';
import '../views/home_screen.dart'; // karena model News kamu ada di situ

class BookmarkProvider with ChangeNotifier {
  final List<News> _bookmarkedNews = [];

  List<News> get bookmarkedNews => _bookmarkedNews;

  void addBookmark(News news) {
    if (!_bookmarkedNews.any((item) => item.title == news.title)) {
      _bookmarkedNews.add(news);
      notifyListeners();
    }
  }

  void removeBookmark(News news) {
    _bookmarkedNews.removeWhere((item) => item.title == news.title);
    notifyListeners();
  }

  bool isBookmarked(News news) {
    return _bookmarkedNews.any((item) => item.title == news.title);
  }
}
