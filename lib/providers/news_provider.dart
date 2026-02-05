import 'package:flutter/material.dart';
import '../data/models/article.dart';
import '../data/repositories/news_repository.dart';

class NewsProvider with ChangeNotifier {
  final NewsRepository _repository;
  NewsProvider({required NewsRepository repository}) : _repository = repository;

  List<Article> _articles = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Inside NewsProvider class
  Future<void> fetchNews({
    String category = 'technology',
    bool forceRefresh = false,
  }) async {
    // If we already have articles and the user didn't ask for a 'hard refresh', do nothing.
    if (_articles.isNotEmpty && !forceRefresh) return;

    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _articles = await _repository.getNews(category);
    } catch (e) {
      _errorMessage = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
