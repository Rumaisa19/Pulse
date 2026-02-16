import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_news/core/theme/app_colors.dart';
import 'package:pulse_news/core/theme/category_colors.dart';
import 'package:pulse_news/data/models/article.dart';
import 'package:pulse_news/logic/article_details_controller.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final Article article;
  const ArticleDetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final controller = ArticleDetailsController(context, article);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFavorite = controller.isFavorite;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: isDark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
            automaticallyImplyLeading: false,
            // Standard back button matching your FavoritesScreen
            leading: IconButton(
              onPressed: () => context.go('/feed'),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              tooltip: 'Back',
            ),
            actions: [_buildFavoriteAction(controller, isFavorite)],
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroImage(article: article),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CategoryTag(article.sectionName, isDark: isDark),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    article.summary,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  _buildLaunchButton(controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteAction(
    ArticleDetailsController controller,
    bool isFavorite,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        onPressed: controller.toggleFavorite,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: child),
          child: Icon(
            isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            key: ValueKey(isFavorite),
            color: isFavorite ? AppColors.pulseRed : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLaunchButton(ArticleDetailsController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: controller.launchArticleUrl,
        icon: const Icon(Icons.open_in_new_rounded, size: 16),
        label: const Text('Read Full Article'),
      ),
    );
  }
}

// UI Components
class _HeroImage extends StatelessWidget {
  final Article article;
  const _HeroImage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'article-${article.id}',
          child: article.thumbnail.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: article.thumbnail,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      const ColoredBox(color: Color(0xFF111111)),
                  errorWidget: (_, __, ___) =>
                      const ColoredBox(color: Color(0xFF111111)),
                )
              : const ColoredBox(color: Color(0xFF111111)),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x55000000), Color(0x00000000), Color(0x22000000)],
              stops: [0.0, 0.4, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final String category;
  final bool isDark;
  const _CategoryTag(this.category, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = CategoryColors.getColor(category, isDark: isDark);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: CategoryColors.getSurface(category),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
