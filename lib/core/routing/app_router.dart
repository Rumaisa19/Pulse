import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_news/ui/screens/article_details_screen.dart';
import 'package:pulse_news/ui/screens/favorites_screen.dart';
import 'package:pulse_news/ui/screens/setting_screen.dart';
import 'package:pulse_news/ui/screens/splash_screen.dart';
import '../../data/models/article.dart';
import '../../ui/screens/news_feed_screen.dart';

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

// Router logic for the application using GoRouter.
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash', // Set the initial route to the splash screen.
  debugLogDiagnostics: true, // Enable navigation logs for debugging.
  routes: [
    // Route for the splash screen.
    GoRoute(
      name: 'splash',
      path: '/splash',
      builder: (_, __) => const SplashScreen(),
    ),

    // Route for the news feed screen.
    GoRoute(
      path: '/feed',
      name: 'feed',
      builder: (context, state) => const NewsFeedScreen(),
    ),

    // Route for the settings screen.
    GoRoute(
      name: 'settings',
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    // Route for the search screen, currently using a placeholder view.
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const PlaceholderView(name: 'Search'),
    ),

    // Route for displaying article details
    GoRoute(
      name: 'articleDetails',
      path: '/details',
      builder: (context, state) {
        // Retrieve the article object passed through the navigation state.
        final article = state.extra as Article;
        return ArticleDetailsScreen(article: article);
      },
    ),

    // Route for the favorites screen.
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
  ],

  // Global error handling for navigation errors.
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Navigation Error: ${state.error}'))),
);
