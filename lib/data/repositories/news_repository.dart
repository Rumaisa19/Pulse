import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:chronicle/data/models/article.dart';

// Assuming your API service is here:
// import 'package:chronicle/data/services/news_api_service.dart';
class NewsRepository {
  final dynamic apiService;
  final Box<Article> articleBox;

  NewsRepository({required this.apiService, required this.articleBox});

  Future<List<Article>> getNews() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    final bool isOnline = !connectivityResult.contains(ConnectivityResult.none);

    if (isOnline) {
      try {
        final List<Article> remoteArticles = await apiService.fetchNews();

        await articleBox.clear();
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
    if (articleBox.isNotEmpty) {
      return articleBox.values.toList();
    }
    return [];
  }
}
