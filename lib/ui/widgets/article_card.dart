import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // REQUIRED: Add this import
import 'package:pulse_news/data/models/article.dart';
import 'package:pulse_news/providers/news_provider.dart'; // REQUIRED: Add this import

class ArticleCard extends StatelessWidget {
  final Article article;
  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    // 1. Access the NewsProvider to check favorite status
    final newsProvider = context.watch<NewsProvider>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.pushNamed('articleDetails', extra: article);
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: article.thumbnail.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: article.thumbnail,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[100],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  )
                : Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[100],
                    child: const Icon(Icons.newspaper, color: Colors.grey),
                  ),
          ),
          title: Text(
            article.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              article.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ),
          // 2. Updated Trailing logic
          trailing: IconButton(
            icon: Icon(
              newsProvider.isFavorite(article)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: newsProvider.isFavorite(article) ? Colors.red : null,
            ),
            onPressed: () => newsProvider.toggleFavorite(article),
          ),
        ),
      ),
    );
  }
}
