import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Internal Imports
import 'package:pulse_news/core/theme/app_theme.dart';
import 'package:pulse_news/core/routing/app_router.dart';
import 'package:pulse_news/data/models/article.dart';
import 'package:pulse_news/data/services/news_api_service.dart';
import 'package:pulse_news/data/repositories/news_repository.dart';
import 'package:pulse_news/providers/news_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load Secrets (.env)
  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    debugPrint("Warning: .env file not found. Ensure API keys are handled.");
  }

  // 2. Local Database (Hive) Initialization
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ArticleAdapter());
  }
  final newsBox = await Hive.openBox<Article>('news_box');
  final favoritesBox = await Hive.openBox<Article>('favorites_box');

  // 3. Dependency Injection
  final apiService = NewsApiService();
  final newsRepository = NewsRepository(
    apiService: apiService,
    articleBox: newsBox,
    favoritesBox: favoritesBox,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(repository: newsRepository),
        ),
      ],
      child: const PulseNewsApp(), // Updated Name
    ),
  );
}

class PulseNewsApp extends StatelessWidget {
  const PulseNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Using the GoRouter configuration from app_router.dart
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'Pulse News', // Rebranded Title
      theme: AppTheme.lightTheme,
    );
  }
}
