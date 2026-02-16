import 'dart:async';
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
  String _searchQuery = '';
  Timer? _debounce;

  // Getters
  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  String get currentCategory => _currentCategory;
  String get searchQuery => _searchQuery; // ✅ Added for empty state check
  List<Article> get favoriteArticles => repository.getFavorites();

  // Dispose timer to prevent memory leak
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// Search Logic with Debounce
  void searchNews(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = query.trim();
      _articles.clear();
      _currentPage = 1;
      loadInitialNews();
    });
  }

  // Immediate search when user hits Enter
  void searchNewsImmediate(String query) {
    _debounce?.cancel();
    _searchQuery = query.trim();
    _articles.clear();
    _currentPage = 1;
    loadInitialNews();
  }

  //Clear search state properly
  void clearSearch() {
    _debounce?.cancel();
    _searchQuery = '';
    _articles.clear();
    _currentPage = 1;
    loadInitialNews();
  }

  // ensures we don't crash if the box is briefly unavailable
  bool isFavorite(Article article) {
    try {
      return repository.isFavorite(article.id);
    } catch (e) {
      return false;
    }
  }

  void toggleFavorite(Article article) {
    repository.toggleFavorite(article);
    notifyListeners();
  }

  Future<void> loadInitialNews({String? category}) async {
    if (category != null) {
      if (_currentCategory == category) {
        _currentCategory = '';
      } else {
        _currentCategory = category;
      }

      notifyListeners();
    }

    _isLoading = true;
    _currentPage = 1;
    notifyListeners();

    try {
      final query = _searchQuery.isNotEmpty
          ? _searchQuery
          : (_currentCategory.isEmpty ? 'news' : _currentCategory);

      _articles = await repository.getNews(
        query,
        page: _currentPage,
        isSearch: _searchQuery.isNotEmpty,
      );
    } catch (e) {
      debugPrint("Provider Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pagination
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
