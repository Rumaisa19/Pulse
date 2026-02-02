import 'package:flutter/material.dart';
import '../data/models/article.dart';
import '../data/repositories/news_repository.dart';

class NewsProvider with ChangeNotifier {
  // Inject the repository through the constructor
  final NewsRepository _repository;

  NewsProvider({required NewsRepository repository}) : _repository = repository;

  List<Article> _articles = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchNews() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // The Provider doesn't care about Dio or Hive anymore
      // It just trusts the Repository to give it a List<Article>
      _articles = await _repository.getNews();
    } catch (e) {
      _errorMessage = "Failed to load news. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
