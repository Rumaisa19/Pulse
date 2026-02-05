import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pulse_news/core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'data/models/article.dart';
import 'data/services/news_api_service.dart';
import 'data/repositories/news_repository.dart';
import 'providers/news_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load Secrets
  await dotenv.load(fileName: ".env");

  // 2. Local Database Init
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ArticleAdapter());
  }
  final newsBox = await Hive.openBox<Article>('news_box');

  // 3. Dependency Injection Logic
  final apiService = NewsApiService();
  final newsRepository = NewsRepository(
    apiService: apiService,
    articleBox: newsBox,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(repository: newsRepository),
        ),
      ],
      child: const ChronicleApp(),
    ),
  );
}

class ChronicleApp extends StatelessWidget {
  const ChronicleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter, // Using GoRouter logic
      debugShowCheckedModeBanner: false,
      title: 'Chronicle News',
      theme: AppTheme.lightTheme,
    );
  }
}
