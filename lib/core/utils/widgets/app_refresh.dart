import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Pull-to-refresh scroll view that looks native on each platform:
///
/// * iOS / macOS: the iOS refresh control. The list bounces down and the
///   grey activity spinner appears above the first item.
/// * Android and others: the Material circular [RefreshIndicator].
///
/// Pass the content as [slivers] (e.g. `SliverList`, `SliverToBoxAdapter`,
/// `SliverFillRemaining`). The view is always scrollable, so pull-to-refresh
/// also works when the content is short or empty.
class AppRefreshScrollView extends StatelessWidget {
  const AppRefreshScrollView({
    super.key,
    required this.onRefresh,
    required this.slivers,
    this.controller,
  });

  final Future<void> Function() onRefresh;
  final List<Widget> slivers;
  final ScrollController? controller;

  static bool isCupertino(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
  }

  @override
  Widget build(BuildContext context) {
    if (isCupertino(context)) {
      return CustomScrollView(
        controller: controller,
        // The iOS control is revealed by the bounce when pulling past the top.
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          ...slivers,
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: slivers,
      ),
    );
  }
}
