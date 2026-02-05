import 'package:go_router/go_router.dart';
import 'package:pulse_news/ui/screens/home_screen.dart';
import '../../ui/screens/splash_screen.dart';


final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/', builder: (context, state) => const Homescreen()),
    GoRoute(
      path: '/details',
      // builder: (context, state) {
      //   final article = state.extra as Article;
      //   return Detailscreen(article: article);
      // },
    ),
  ],
);
