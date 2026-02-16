import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/article.dart';

class NewsApiService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  final String _apiKey = dotenv.env['GUARDIAN_API_KEY'] ?? 'Key Not Found';
  final String _baseUrl =
      dotenv.env['GUARDIAN_BASE_URL'] ??
      'https://content.guardianapis.com/search';

  /// Fetches news articles based on the provided query or category.
  /// If [isSearch] is true, the [queryOrCategory] is treated as a search query.
  /// Otherwise, it is treated as a section filter. The method returns a map
  /// containing a list of articles and the total number of pages.
  Future<Map<String, dynamic>> fetchNews(
    String queryOrCategory, {
    int page = 1,
    bool isSearch = false,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'api-key': _apiKey,
          if (isSearch)
            'q': queryOrCategory
          else
            'section': queryOrCategory.isEmpty ? 'world' : queryOrCategory,
          'show-fields': 'thumbnail,trailText',
          'page-size': 20,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data['response'];
        final List results = responseData['results'];

        return {
          'articles': results.map((json) => Article.fromJson(json)).toList(),
          'totalPages': responseData['pages'],
        };
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network Failure: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}
