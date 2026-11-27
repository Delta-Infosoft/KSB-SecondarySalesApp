import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shared shimmer (skeleton) loaders. Each one mirrors the layout of the
/// content it stands in for, so the screen doesn't jump when data arrives.
///
/// Use a single [AppShimmer] around a whole skeleton (not one per box) so
/// the highlight sweeps across the layout in sync.
class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  static const Color base = Color(0xFFE2E8F0);
  static const Color highlight = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1300),
      enabled: enabled,
      child: child,
    );
  }
}

/// A plain rounded block; the building piece of every skeleton.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 8,
    this.shape = BoxShape.rectangle,
  });

  /// A circle of the given [size] (avatars, icons).
  const ShimmerBox.circle({super.key, required double size})
      : width = size,
        height = size,
        radius = 0,
        shape = BoxShape.circle;

  final double? width;
  final double height;
  final double radius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // Any opaque colour works: Shimmer repaints it with its gradient.
        color: Colors.white,
        shape: shape,
        borderRadius:
            shape == BoxShape.circle ? null : BorderRadius.circular(radius),
      ),
    );
  }
}

/// Skeleton for list screens whose rows are rounded cards with a leading
/// avatar, two text lines and a trailing icon (customers, sales, pickers).
class ShimmerCardList extends StatelessWidget {
  const ShimmerCardList({
    super.key,
    this.itemCount = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    this.spacing = 15,
    this.lines = 2,
    this.showAvatar = true,
    this.shrinkWrap = false,
  });

  final int itemCount;
  final EdgeInsetsGeometry padding;
  final double spacing;

  /// Text lines under the title (1–3).
  final int lines;
  final bool showAvatar;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        // Skeletons aren't interactive; also lets a parent RefreshIndicator
        // or scroll view stay in charge.
        physics: shrinkWrap
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        shrinkWrap: shrinkWrap,
        padding: padding,
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(height: spacing),
        itemBuilder: (_, i) => _ShimmerRow(
          lines: lines,
          showAvatar: showAvatar,
          // Vary widths a little so it reads as text, not a grid.
          titleFactor: const [0.62, 0.48, 0.7, 0.55][i % 4],
        ),
      ),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  const _ShimmerRow({
    required this.lines,
    required this.showAvatar,
    required this.titleFactor,
  });

  final int lines;
  final bool showAvatar;
  final double titleFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        // Slightly translucent card so the shimmer reads as the card shape.
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          if (showAvatar) ...[
            const ShimmerBox.circle(size: 40),
            const SizedBox(width: 15),
          ],
          Expanded(
            child: LayoutBuilder(builder: (context, c) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShimmerBox(width: c.maxWidth * titleFactor, height: 14),
                  for (var l = 0; l < lines; l++) ...[
                    const SizedBox(height: 8),
                    ShimmerBox(
                        width: c.maxWidth * (l.isEven ? 0.4 : 0.3), height: 11),
                  ],
                ],
              );
            }),
          ),
          const SizedBox(width: 12),
          const ShimmerBox(width: 14, height: 14, radius: 4),
        ],
      ),
    );
  }
}

/// Skeleton for "label / value" detail lists (Profile).
class ShimmerDetailList extends StatelessWidget {
  const ShimmerDetailList({
    super.key,
    this.itemCount = 9,
    this.padding = EdgeInsets.zero,
  });

  final int itemCount;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        itemCount: itemCount,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: i.isEven ? 120 : 150, height: 14),
                    const SizedBox(height: 8),
                    ShimmerBox(width: i.isEven ? 180 : 140, height: 12),
                  ],
                ),
              ),
              const ShimmerBox.circle(size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton for the document cards (file icon, title, chips, two buttons).
class ShimmerDocumentList extends StatelessWidget {
  const ShimmerDocumentList({
    super.key,
    this.itemCount = 5,
    this.padding = const EdgeInsets.fromLTRB(16, 4, 16, 16),
  });

  final int itemCount;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(width: 48, height: 48, radius: 10),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FractionallySizedBox(
                          widthFactor: i.isEven ? 0.8 : 0.6,
                          child: const ShimmerBox(height: 15),
                        ),
                        const SizedBox(height: 8),
                        const FractionallySizedBox(
                          widthFactor: 0.45,
                          child: ShimmerBox(height: 11),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            ShimmerBox(width: 64, height: 20, radius: 10),
                            SizedBox(width: 6),
                            ShimmerBox(width: 84, height: 20, radius: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Expanded(child: ShimmerBox(height: 36, radius: 10)),
                  SizedBox(width: 10),
                  Expanded(child: ShimmerBox(height: 36, radius: 10)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A chart-sized placeholder: faint bars inside the card's chart area.
class ShimmerChart extends StatelessWidget {
  const ShimmerChart({super.key, this.height = 240});

  final double height;

  @override
  Widget build(BuildContext context) {
    const bars = [0.55, 0.8, 0.45, 0.95, 0.65, 0.75, 0.5, 0.85];
    return AppShimmer(
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final f in bars)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ShimmerBox(height: (height - 24) * f, radius: 6),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the analytics dashboard: a stack of chart cards.
class ShimmerDashboard extends StatelessWidget {
  const ShimmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    Widget card({double chartHeight = 200}) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  ShimmerBox(width: 36, height: 36, radius: 10),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 150, height: 14),
                        SizedBox(height: 6),
                        ShimmerBox(width: 100, height: 10),
                      ],
                    ),
                  ),
                  ShimmerBox(width: 72, height: 30, radius: 15),
                ],
              ),
              const SizedBox(height: 18),
              ShimmerBox(height: chartHeight, radius: 12),
            ],
          ),
        );

    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          card(chartHeight: 180),
          card(),
          card(),
        ],
      ),
    );
  }
}

/// Skeleton of a document page (PDF viewer while it loads).
class ShimmerPage extends StatelessWidget {
  const ShimmerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        // Never overflow on short screens; the skeleton just gets clipped.
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FractionallySizedBox(
                  widthFactor: 0.6, child: ShimmerBox(height: 20)),
              const SizedBox(height: 24),
              for (var i = 0; i < 4; i++) ...const [
                ShimmerBox(height: 11),
                SizedBox(height: 10),
                ShimmerBox(height: 11),
                SizedBox(height: 10),
                FractionallySizedBox(
                    widthFactor: 0.7, child: ShimmerBox(height: 11)),
                SizedBox(height: 24),
              ],
              const ShimmerBox(height: 120, radius: 8),
            ],
          ),
        ),
      ),
    );
  }
}
