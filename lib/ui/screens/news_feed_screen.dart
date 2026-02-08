import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pulse_news/providers/news_provider.dart';
import '../../ui/widgets/article_card_skeleton.dart';
import 'package:pulse_news/ui/widgets/article_card.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<NewsProvider>().loadInitialNews());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        context.read<NewsProvider>().loadMoreNews();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.watch<NewsProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.pushNamed('favorites'),
            icon: const Icon(Icons.bookmarks),
          ),
        ],
        title: const Text('Pulse News'),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for news...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                    context.read<NewsProvider>().searchNews('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) =>
                  context.read<NewsProvider>().searchNews(value),
            ),
          ),
        ),
      ),
      body: newsProvider.isLoading
          ? const NewsSkeleton() // <--- Swap the single spinner for the skeleton list
          : newsProvider.articles.isEmpty
          ? const Center(
              child: Text("No news found for this search."),
            ) // Day 9: Empty State
          : RefreshIndicator(
              onRefresh: () => newsProvider.loadInitialNews(),
              child: ListView.builder(
                controller: _scrollController,
                itemCount:
                    newsProvider.articles.length +
                    (newsProvider.isFetchingMore &&
                            newsProvider.articles.isNotEmpty
                        ? 1
                        : 0),
                itemBuilder: (context, index) {
                  if (index >= newsProvider.articles.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                    );
                  }
                  final article = newsProvider.articles[index];
                  return ArticleCard(article: article);
                },
              ),
            ),
    );
  }
}
