import 'dart:async'; // Added for Timer
import 'package:flutter/material.dart';
import 'package:pulse_news/data/models/article.dart';
import 'package:pulse_news/data/repositories/news_repository.dart';

class NewsProvider extends ChangeNotifier {
  final NewsRepository repository;

  NewsProvider({required this.repository});

  // State Variables
  List<Article> _articles = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  String _currentCategory = 'world';
  String _searchQuery = ''; // Track what user is searching
  Timer? _debounce; // To prevent hitting API too hard

  // Getters
  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;

  /// Search Logic with Debounce (Day 8)
  void searchNews(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = query;
      _articles.clear();
      // When we search, we reset the list and start from page 1
      loadInitialNews();
    });
  }

  // Defensive coding: ensures we don't crash if the repository/box is briefly unavailable
  bool isFavorite(Article article) {
    try {
      return repository.isFavorite(article.id);
    } catch (e) {
      return false;
    }
  }

  void toggleFavorite(Article article) {
    repository.toggleFavorite(article);
    notifyListeners(); // Refresh UI to show filled/empty heart
  }

  List<Article> get favoriteArticles => repository.getFavorites();

  /// Initial fetch (Updated for Search)
  Future<void> loadInitialNews({String? category}) async {
    _isLoading = true;
    _currentPage = 1;
    if (category != null) _currentCategory = category;

    notifyListeners();

    try {
      // LOGIC: If _searchQuery is not empty, we tell the repo to search.
      // Otherwise, we tell it to fetch the category.
      _articles = await repository.getNews(
        _searchQuery.isNotEmpty ? _searchQuery : _currentCategory,
        page: _currentPage,
        isSearch: _searchQuery.isNotEmpty, // New flag for the repository
      );
    } catch (e) {
      debugPrint("Provider Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Pagination (Updated for Search)
  Future<void> loadMoreNews() async {
    if (_isFetchingMore || _isLoading) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final newArticles = await repository.getNews(
        _searchQuery.isNotEmpty ? _searchQuery : _currentCategory,
        page: _currentPage,
        isSearch: _searchQuery.isNotEmpty,
      );

      _articles.addAll(newArticles);
    } catch (e) {
      _currentPage--;
      debugPrint("Pagination Error: $e");
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }
}
