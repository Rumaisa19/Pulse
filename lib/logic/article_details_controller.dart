import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pulse_news/data/models/article.dart';
import 'package:pulse_news/providers/news_provider.dart';

class ArticleDetailsController {
  final BuildContext context;
  final Article article;

  ArticleDetailsController(this.context, this.article);

  bool get isFavorite =>
      context.select<NewsProvider, bool>((p) => p.isFavorite(article));

  void toggleFavorite() {
    context.read<NewsProvider>().toggleFavorite(article);
  }

  Future<void> launchArticleUrl() async {
    final uri = Uri.parse(article.webUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch URL: $e');
    }
  }
}
