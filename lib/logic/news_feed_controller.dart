import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_news/providers/news_provider.dart';

class NewsFeedController {
  final BuildContext context;
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  // State variables
  bool filterExpanded = false;
  bool isLoadingMore = false;

  Timer? _debounce;

  NewsFeedController(this.context);

  void init(VoidCallback onStateChanged) {
    // Initial data fetch: Microtask ensures the build phase is complete
    Future.microtask(() => context.read<NewsProvider>().loadInitialNews());

    scrollController.addListener(() {
      if (isLoadingMore) return;

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.8) {
        _handleLoadMore(onStateChanged);
      }
    });

    searchController.addListener(onStateChanged);
  }

  Future<void> _handleLoadMore(VoidCallback onStateChanged) async {
    final provider = context.read<NewsProvider>();
    if (provider.isFetchingMore || provider.searchQuery.isNotEmpty) return;

    isLoadingMore = true;
    onStateChanged();

    await provider.loadMoreNews();

    isLoadingMore = false;
    onStateChanged();
  }

  void toggleFilter(VoidCallback onStateChanged) {
    filterExpanded = !filterExpanded;
    onStateChanged();
  }

  void handleSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = value.trim();
      if (query.isNotEmpty) {
        context.read<NewsProvider>().searchNews(query);
      } else if (query.isEmpty && value.isEmpty) {
        // Handle case where user deletes all text manually
        clearSearch();
      }
    });
  }

  void handleSearchSubmit(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.isNotEmpty) {
      context.read<NewsProvider>().searchNews(query);
    }
  }

  void clearSearch() {
    _debounce?.cancel();
    searchController.clear();
    context.read<NewsProvider>().clearSearch();
  }

  void dispose() {
    _debounce?.cancel();
    scrollController.dispose();
    searchController.dispose();
  }
}
