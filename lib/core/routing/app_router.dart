import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_news/ui/screens/article_details_screen.dart';
import 'package:pulse_news/ui/screens/favorites_screen.dart';
import '../../data/models/article.dart';
import '../../ui/screens/news_feed_screen.dart';

// --- STUB VIEWS (Temporary safety against AssertionErrors) ---

class PlaceholderView extends StatelessWidget {
  final String name;
  const PlaceholderView({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), centerTitle: true),
      body: Center(child: Text('$name Screen: Implementation in Progress')),
    );
  }
}

// --- ROUTER LOGIC ---

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true, // Lead Dev tip: Shows navigation logs in console
  routes: [
    // 1. Home Route
    GoRoute(
      path: '/',
      name: 'home',
      // Replace PlaceholderView with the real screen
      builder: (context, state) => const NewsFeedScreen(),
    ),

    // 2. Search Route
    GoRoute(
      path: '/search',
      name: 'search',
      // Replace with SearchView() when Day 8 logic is ready
      builder: (context, state) => const PlaceholderView(name: 'Search'),
    ),

    // 3. Article Detail Route
    GoRoute(
      name: 'articleDetails',
      path: '/details',
      builder: (context, state) {
        // Cast the extra object back to an Article
        final article = state.extra as Article;
        return ArticleDetailScreen(article: article);
      },
    ),
    // Add this route to your GoRouter 'routes' list
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
  ],

  // 4. Global Error Handling
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Navigation Error: ${state.error}'))),
);
