import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_news/core/theme/category_colors.dart';
import 'package:pulse_news/data/models/article.dart';

class HeroArticleCard extends StatelessWidget {
  final Article article;
  const HeroArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push('/details', extra: article),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImage(),
              _buildGradientOverlay(),
              _buildContent(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Hero(
      tag: 'article-${article.id}',
      child: article.thumbnail.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: article.thumbnail,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  const ColoredBox(color: Color(0xFF121212)),
              errorWidget: (_, __, ___) => const _FallbackImage(),
            )
          : const _FallbackImage(),
    );
  }

  Widget _buildGradientOverlay() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00000000), Color(0x33000000), Color(0xAA000000)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _CategoryGlassChip(article.sectionName, isDark: isDark),
          const SizedBox(height: 12),
          Text(
            article.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CategoryGlassChip extends StatelessWidget {
  final String category;
  final bool isDark;
  const _CategoryGlassChip(this.category, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    final accentColor = CategoryColors.getColor(category, isDark: true);

    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Text(
            category.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _FallbackImage extends StatelessWidget {
  const _FallbackImage();
  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF121212),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.white24,
          size: 40,
        ),
      ),
    );
  }
}
