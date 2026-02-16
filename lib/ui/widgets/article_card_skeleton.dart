import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsSkeleton extends StatelessWidget {
  const NewsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark
        ? const Color(0xFF161618)
        : const Color(0xFFEBEBEF);
    final highlightColor = isDark
        ? const Color(0xFF1C1C1E)
        : const Color(0xFFF9F9FB);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1500),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          _heroPlaceholder(),
          const SizedBox(height: 32), // Clear separation
          ...List.generate(4, (_) => _cardPlaceholder()),
        ],
      ),
    );
  }

  Widget _heroPlaceholder() {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
    );
  }

  Widget _cardPlaceholder() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bar(60, 10),
                const SizedBox(height: 12),
                _bar(double.infinity, 16),
                const SizedBox(height: 8),
                _bar(200, 16),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _bar(40, 10), // Date
                    const SizedBox(width: 12),
                    _bar(40, 10), // Read time
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
