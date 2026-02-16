import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pulse_news/providers/news_provider.dart';
import 'package:pulse_news/ui/widgets/article_card.dart';
import 'package:pulse_news/ui/widgets/pulse_empty_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<NewsProvider>().favoriteArticles;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          'SAVED STORIES',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: 22,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: favorites.isEmpty
            ? const PulseEmptyState(
                key: ValueKey('empty'),
                icon: Icons.bookmarks_outlined,
                title: 'No saved stories yet',
                subtitle: 'Bookmark articles to read them later',
              )
            : ListView.separated(
                key: const ValueKey('list'),
                itemCount: favorites.length,
                separatorBuilder: (_, __) =>
                    const Divider(indent: 16, endIndent: 16),
                itemBuilder: (context, index) =>
                    ArticleCard(article: favorites[index]),
              ),
      ),
    );
  }
}
