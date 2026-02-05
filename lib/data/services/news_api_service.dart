import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // REQUIRED IMPORT
import '../models/article.dart';

// This Service is responsible ONLY for the raw network handshake.
// It doesn't care about caching or state; it just talks to the server.
class NewsApiService {
  // Initialize Dio with high-performance configurations
  final Dio _dio = Dio(
    BaseOptions(
      // Connection timeout: How long to wait to establish a handshake with The Guardian servers
      connectTimeout: const Duration(seconds: 20),
      // Receive timeout: How long to wait for the server to send the JSON body
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  // Security Note: In production, these should be in an .env file or native config
  final String _apiKey = dotenv.env['GUARDIAN_API_KEY'] ?? 'Key Not Found';
  final String _baseUrl =
      dotenv.env['GUARDIAN_BASE_URL'] ??
      'https://content.guardianapis.com/search';

  Future<List<Article>> fetchNews(String category) async {
    try {
      // Logic: Passing parameters as a Map ensures Dio handles URL encoding (e.g., spaces to %20)
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'api-key': _apiKey,
          'section': category.isEmpty
              ? 'world'
              : category, // Fallback to 'world' news
          // CRITICAL: Requesting 'fields' metadata to get thumbnails and trailText
          'show-fields': 'thumbnail,trailText',
          'page-size': 20,
        },
      );

      // Check for success (HTTP 200)
      if (response.statusCode == 200) {
        // Integration Logic: The Guardian wraps data in a 'response' object, then a 'results' list
        final List results = response.data['response']['results'];

        // Data Mapping: Convert the raw dynamic List into strongly-typed Article objects
        return results.map((json) => Article.fromJson(json)).toList();
      } else {
        // Handle server-side errors (401 Unauthorized, 429 Rate Limit, 500 Server Error)
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Specific handling for network-level issues (No internet, DNS failure, etc.)
      throw Exception('Network Failure: ${e.message}');
    } catch (e) {
      // General safety rethrow for repository catch blocks to handle
      rethrow;
    }
  }
}
