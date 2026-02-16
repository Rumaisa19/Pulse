import 'package:flutter/material.dart';

/// A delegate for creating a sticky header in a Sliver.
class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child; // The widget to be displayed as the sticky header.
  final double height; // The height of the sticky header.

  StickyHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Builds the sticky header widget, expanding to fill available space.
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => height; // Returns the maximum height of the header.

  @override
  double get minExtent => height; // Returns the minimum height of the header.

  @override
  bool shouldRebuild(covariant StickyHeaderDelegate oldDelegate) {
    // Determines if the delegate should rebuild based on changes in height or child.
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
