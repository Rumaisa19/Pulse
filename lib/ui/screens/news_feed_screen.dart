import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pulse_news/core/theme/app_colors.dart';
import 'package:pulse_news/logic/news_feed_controller.dart';
import 'package:pulse_news/providers/news_provider.dart';
import 'package:pulse_news/ui/widgets/article_card.dart';
import 'package:pulse_news/ui/widgets/article_card_skeleton.dart';
import 'package:pulse_news/ui/widgets/hero_article_card.dart';
import 'package:pulse_news/ui/widgets/pulse_empty_state.dart';
import 'package:pulse_news/ui/widgets/sticky_header_delegate.dart';
import 'package:pulse_news/ui/widgets/news_search_header.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  late final NewsFeedController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NewsFeedController(context);
    _controller.init(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();

    return Scaffold(
      body: provider.isLoading
          ? const NewsSkeleton()
          : provider.articles.isEmpty
          ? _buildEmpty(provider)
          : RefreshIndicator(
              color: AppColors.pulseRed,
              onRefresh: () => provider.loadInitialNews(),
              child: CustomScrollView(
                controller: _controller.scrollController,
                slivers: [
                  _buildAppBar(context),

                  // Sticky Search & Filter Section
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: StickyHeaderDelegate(
                      height: _controller.filterExpanded ? 130 : 75,
                      child: NewsSearchHeader(controller: _controller),
                    ),
                  ),

                  // Main Article List
                  _buildSliverList(provider),
                ],
              ),
            ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      centerTitle: false,
      title: Text(
        'PULSE',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          fontSize: 35,
          letterSpacing: 4,
          fontWeight: FontWeight.w900,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.tune_rounded,
            color: _controller.filterExpanded ? AppColors.pulseRed : null,
          ),
          onPressed: () => _controller.toggleFilter(() => setState(() {})),
        ),
        IconButton(
          icon: const Icon(Icons.bookmarks_outlined),
          onPressed: () => context.push('/favorites'),
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context.push('/settings'),
        ),
      ],
    );
  }

  Widget _buildSliverList(NewsProvider provider) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= provider.articles.length) {
              return const _PaginationLoader();
            }

            final article = provider.articles[index];

            // Show Hero Card only at the top and only if not searching
            if (index == 0 && provider.searchQuery.isEmpty) {
              return HeroArticleCard(article: article);
            }

            return ArticleCard(article: article);
          },
          childCount:
              provider.articles.length + (provider.isFetchingMore ? 1 : 0),
        ),
      ),
    );
  }

  Widget _buildEmpty(NewsProvider provider) {
    return provider.searchQuery.isNotEmpty
        ? PulseEmptyState(
            icon: Icons.search_off_rounded,
            title: 'No results found',
            onAction: _controller.clearSearch,
            actionLabel: 'Clear Search',
          )
        : PulseEmptyState(
            icon: Icons.cloud_off_rounded,
            title: 'No news available',
            onAction: () => provider.loadInitialNews(),
            actionLabel: 'Retry',
          );
  }
}

class _PaginationLoader extends StatelessWidget {
  const _PaginationLoader();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.pulseRed,
        ),
      ),
    );
  }
}
