import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pulse_news/core/theme/app_colors.dart';
import 'package:pulse_news/core/theme/category_colors.dart';
import 'package:pulse_news/data/models/article.dart';
import 'package:pulse_news/providers/news_provider.dart';

class ArticleCard extends StatefulWidget {
  final Article article;
  const ArticleCard({super.key, required this.article});

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _isPressed = false;

  String _timeAgo(String dateStr) {
    try {
      final date = DateTime.tryParse(dateStr) ?? DateTime.now();
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      return '${diff.inMinutes}m ago';
    } catch (_) {
      return 'Recent';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFavorite = context.select<NewsProvider, bool>(
      (p) => p.isFavorite(widget.article),
    );

    final catColor = CategoryColors.getColor(
      widget.article.sectionName,
      isDark: isDark,
    );
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => context.push('/details', extra: widget.article),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: _isPressed ? 0.7 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.article.sectionName.toUpperCase(),
                      style: textTheme.labelSmall?.copyWith(
                        color: catColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.article.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: isDark
                            ? Colors.white
                            : AppColors.lightTextPrimary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    _buildFooter(context, isFavorite, isDark),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Image Section
              _buildImage(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isFavorite, bool isDark) {
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
      fontWeight: FontWeight.w600,
    );

    return Row(
      children: [
        Text(_timeAgo(widget.article.webPublicationDate), style: labelStyle),
        const SizedBox(width: 8),
        Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            color: isDark ? Colors.white24 : Colors.black12,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text('5 min read', style: labelStyle), // Logic placeholder
        const Spacer(),
        _FavoriteButton(
          isFavorite: isFavorite,
          onTap: () =>
              context.read<NewsProvider>().toggleFavorite(widget.article),
        ),
      ],
    );
  }

  Widget _buildImage(bool isDark) {
    return Hero(
      tag: 'article-${widget.article.id}',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: widget.article.thumbnail.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: widget.article.thumbnail,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => _placeholder(isDark),
                  errorWidget: (_, __, ___) => _placeholder(isDark),
                )
              : _placeholder(isDark),
        ),
      ),
    );
  }

  Widget _placeholder(bool isDark) {
    return Container(
      width: 100,
      height: 100,
      color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightDivider,
      child: Icon(
        Icons.newspaper_rounded,
        color: isDark ? Colors.white10 : Colors.black12,
        size: 32,
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _FavoriteButton({required this.isFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isFavorite
              ? AppColors.pulseRed.withValues(alpha: 0.1)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          size: 18,
          color: isFavorite ? AppColors.pulseRed : Colors.grey,
        ),
      ),
    );
  }
}
