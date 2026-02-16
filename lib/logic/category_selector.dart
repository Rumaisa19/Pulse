import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_news/providers/news_provider.dart';
import 'package:pulse_news/core/theme/category_colors.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final ScrollController _scrollController = ScrollController();

  // Mapping display labels to API values
  final Map<String, String> _categories = {
    'World': 'world',
    'Sport': 'sport',
    'Technology': 'technology',
    'Business': 'business',
    'Culture': 'culture',
    'Politics': 'politics',
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = context.select<NewsProvider, String>(
      (provider) => provider.currentCategory,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
          ),
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final label = _categories.keys.elementAt(index);
              final value = _categories.values.elementAt(index);
              final isSelected = currentCategory == value;

              return _buildCategoryChip(
                context,
                label: label,
                value: value,
                isSelected: isSelected,
                isDark: isDark,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context, {
    required String label,
    required String value,
    required bool isSelected,
    required bool isDark,
  }) {
    final categoryColor = CategoryColors.getColor(value, isDark: isDark);

    return GestureDetector(
      onTap: () {
        context.read<NewsProvider>().loadInitialNews(category: value);
        _scrollToSelected(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? categoryColor
              : (isDark ? Colors.white10 : const Color(0xFFF2F2F7)),
          borderRadius: BorderRadius.circular(100),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: categoryColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.grey[800]),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToSelected(String value) {
    final index = _categories.values.toList().indexOf(value);
    _scrollController.animateTo(
      index * 80.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }
}
