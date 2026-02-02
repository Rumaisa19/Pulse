import 'package:dio/dio.dart';
import '../models/article.dart';

class NewsApiService {
  final Dio _dio = Dio();

  final String _apiKey = '2d6bc043-b40e-48ea-b0dc-07ba31921e60';
  final String _baseUrl = 'https://content.guardianapis.com/search';
  Future<List<Article>> fetchNews()async{
    try{
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'api-key': _apiKey,
          'show-fields': 'thumbnail,trailText',
          'page-size':20,
        },
      );
      if(response.statusCode==200){
        final List results = response.data['response']['results'];
        return results.map((json)=> Article.fromJson(json)).toList();
      }
      else{
        throw Exception('Failed to load news');
      }
      
    }
    catch(e){
      rethrow;
    }
  }
}