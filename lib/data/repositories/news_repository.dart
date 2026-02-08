import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import '../models/article.dart';
import '../services/news_api_service.dart';

class NewsRepository {
  final NewsApiService apiService;
  final Box<Article> articleBox;
  final Box<Article> favoritesBox;

  NewsRepository({
    required this.apiService,
    required this.articleBox,
    required this.favoritesBox,
  });
  List<Article> getFavorites() {
    return favoritesBox.values.toList();
  }

  void toggleFavorite(Article article) {
    if (favoritesBox.containsKey(article.id)) {
      favoritesBox.delete(article.id);
    } else {
      favoritesBox.put(article.id, article);
    }
  }

  bool isFavorite(String id) {
    return favoritesBox.containsKey(id);
  }

  Future<List<Article>> getNews(
    String queryOrCategory, {
    int page = 1,
    bool isSearch = false,
  }) async {
    final connectivity = await Connectivity().checkConnectivity();
    final bool isOnline = !connectivity.contains(ConnectivityResult.none);

    if (isOnline) {
      try {
        // Correctly passing all three parameters to the fixed service
        final result = await apiService.fetchNews(
          queryOrCategory,
          page: page,
          isSearch: isSearch,
        );
        final List<Article> remoteArticles = result['articles'];

        if (page == 1) {
          await articleBox.clear();
        }

        await articleBox.addAll(remoteArticles);
        return remoteArticles;
      } catch (e) {
        return _getCachedNews();
      }
    } else {
      return _getCachedNews();
    }
  }

  List<Article> _getCachedNews() {
    return articleBox.values.toList();
  }
}
