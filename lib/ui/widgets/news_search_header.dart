import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pulse_news/logic/category_selector.dart';
import 'package:pulse_news/logic/news_feed_controller.dart';

class NewsSearchHeader extends StatelessWidget {
  final NewsFeedController controller;

  const NewsSearchHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          color: isDark
              ? Colors.black.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.9),
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: controller.handleSearch,
                    onSubmitted: controller.handleSearchSubmit,
                    decoration: InputDecoration(
                      hintText: 'Search stories...',
                      filled: true,
                      fillColor: isDark
                          ? Colors.white10
                          : Colors.black.withValues(alpha: 0.05),
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      suffixIcon: controller.searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: controller.clearSearch,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              if (controller.filterExpanded)
                const SizedBox(height: 60, child: CategorySelector()),
            ],
          ),
        ),
      ),
    );
  }
}
