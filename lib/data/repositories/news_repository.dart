import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import '../models/article.dart';
import '../services/news_api_service.dart';

// This Repository acts as the 'Single Source of Truth' for the UI.
// It decides whether to pull fresh data from the web or fallback to the local database.
class NewsRepository {
  final NewsApiService
  apiService; // Handles network requests to The Guardian/NewsAPI
  final Box<Article> articleBox; // Handles local NoSQL storage via Hive

  NewsRepository({required this.apiService, required this.articleBox});

  Future<List<Article>> getNews(String category) async {
    // Check if the device has an active internet connection (Wi-Fi, Mobile, or Ethernet)
    final connectivity = await Connectivity().checkConnectivity();

    // Logic: If the list of results does NOT contain 'none', we are considered 'online'
    final bool isOnline = !connectivity.contains(ConnectivityResult.none);

    // Inside NewsRepository
    if (isOnline) {
      try {
        final remoteArticles = await apiService.fetchNews(category);

        // CHANGE: Transactional update
        await articleBox.clear();
        await articleBox.addAll(remoteArticles);

        return remoteArticles;
      } catch (e) {
        return _getCachedNews(); // Fallback to cache if remote fetch fails
      }
    } else {
      // Offline Mode: Immediately serve the news saved in the Hive box
      return _getCachedNews();
    }
  }

  // Helper method to retrieve data from local storage
  List<Article> _getCachedNews() {
    return articleBox.values.toList();
  }
}
