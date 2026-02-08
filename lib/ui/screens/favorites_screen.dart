import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_news/providers/news_provider.dart';
import 'package:pulse_news/ui/widgets/article_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<NewsProvider>().favoriteArticles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Stories'),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text("No saved stories yet.", 
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return ArticleCard(article: favorites[index]);
              },
            ),
    );
  }
}