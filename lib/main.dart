import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pulse_news/core/theme/app_theme.dart';
import 'package:pulse_news/core/routing/app_router.dart';
import 'package:pulse_news/data/models/article.dart';
import 'package:pulse_news/data/services/news_api_service.dart';
import 'package:pulse_news/data/repositories/news_repository.dart';
import 'package:pulse_news/providers/news_provider.dart';
import 'package:pulse_news/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    debugPrint("Warning: .env file not found. Ensure API keys are handled.");
  }

  // Initialize Hive for local storage
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ArticleAdapter());
  }
  final newsBox = await Hive.openBox<Article>('news_box');
  final favoritesBox = await Hive.openBox<Article>('favorites_box');
  await Hive.openBox('settings'); // Ensure settings box is opened before ThemeProvider._load()

  // Set up dependency injection for the news repository
  final newsRepository = NewsRepository(
    apiService: NewsApiService(),
    articleBox: newsBox,
    favoritesBox: favoritesBox,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider(repository: newsRepository)),
      ],
      child: const PulseNewsApp(),
    ),
  );
}

class PulseNewsApp extends StatelessWidget {
  const PulseNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Build the MaterialApp with theme support based on ThemeProvider
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) => MaterialApp.router(
        routerConfig: appRouter,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: theme.themeMode, // Theme mode is controlled by the provider
        debugShowCheckedModeBanner: false,
        title: 'Pulse News',
      ),
    );
  }
}