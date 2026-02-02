import 'package:chronicle/data/models/article.dart';
import 'package:chronicle/data/repositories/news_repository.dart';
import 'package:chronicle/data/services/news_api_service.dart';
import 'package:chronicle/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());

  // 2. Open the box and assign it to a variable (This fixes the newsBox error)
  final Box<Article> newsBox = await Hive.openBox<Article>('news_box');

  // 3. Initialize the Service Layer
  final apiService = NewsApiService();

  // 4. Initialize the Repository (This fixes the newsRepository error)
  // We pass the service and the box we just created
  final newsRepository = NewsRepository(
    apiService: apiService,
    articleBox: newsBox,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // 5. Inject the repository into the Provider
          create: (_) => NewsProvider(repository: newsRepository),
        ),
      ],
      child: const ChronicleTestApp(),
    ),
  );
}

class ChronicleTestApp extends StatefulWidget {
  const ChronicleTestApp({super.key});

  @override
  State<ChronicleTestApp> createState() => _ChronicleTestAppState();
}

class _ChronicleTestAppState extends State<ChronicleTestApp> {
  @override
  void initState() {
    super.initState();
    // This calls the API ONLY ONCE when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("CHRONICLE"),
          centerTitle: true,
          elevation: 2,
        ),
        // The Consumer "listens" to the NewsProvider
        body: Consumer<NewsProvider>(
          builder: (context, provider, child) {
            // 1. Check Loading State
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Check Error State
            if (provider.errorMessage.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Error: ${provider.errorMessage}"),
                ),
              );
            }
            if (provider.articles.isEmpty) {
              return const Center(child: Text("No news available."));
            }

            // 3. Show Data
            return ListView.builder(
              itemCount: provider.articles.length,
              // This ensures the list only builds what is visible
              itemBuilder: (context, index) {
                final article = provider.articles[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.thumbnail.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            article.thumbnail,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: Icon(Icons.broken_image, size: 50),
                                  ),
                                ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Divider(height: 30),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
