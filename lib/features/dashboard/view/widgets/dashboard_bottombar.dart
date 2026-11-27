import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'animated_dashboard_icon.dart';

/// The tabs of the main screen, in page order.
enum DashboardTab { home, dashboard, profile }

/// Floating frosted-glass bottom bar with a notch in the middle. Dashboard
/// sits in the notch as a raised liquid-glass circle; Home and Profile are on
/// either side.
///
/// Without [showDashboard] there is no notch and no centre button, just Home
/// and Profile.
///
/// The widget reserves [preferredSize] (the bar, the part of the button that
/// sticks up above it, and a small gap below). On iOS it also lifts itself
/// above the home indicator; on Android [GlassScaffold] does that for it.
class DashboardBottomBar extends StatelessWidget
    implements PreferredSizeWidget {
  const DashboardBottomBar({
    super.key,
    required this.selected,
    required this.onSelected,
    this.showDashboard = true,
  });

  final DashboardTab selected;
  final ValueChanged<DashboardTab> onSelected;
  final bool showDashboard;

  static const double barHeight = 68;
  static const double buttonSize = 58;

  /// Gap between the button and the edge of the notch.
  static const double notchGap = 6;

  /// How far the button's centre sits below the top edge of the bar.
  static const double buttonDrop = 2;
  static const double bottomGap = 10;
  static const double sideMargin = 16;

  static double get _overhang => buttonSize / 2 - buttonDrop;

  @override
  Size get preferredSize =>
      Size.fromHeight((showDashboard ? _overhang : 0) + barHeight + bottomGap);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final dark = theme.brightness == Brightness.dark;
    final idleColor = dark ? Colors.white70 : Colors.black87;

    // GlassScaffold already keeps the bar clear of Android's nav bar. On iOS
    // the bar floats over the home indicator, straddling it a little.
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    final extraBottom = isIos ? (safeBottom - 14).clamp(0.0, 40.0) : 0.0;

    final overhang = showDashboard ? _overhang : 0.0;
    const notchRadius = buttonSize / 2 + notchGap;

    Widget sideItem(
        DashboardTab tab, IconData icon, IconData activeIcon, String label) {
      return Expanded(
        child: _BarItem(
          icon: icon,
          activeIcon: activeIcon,
          label: label,
          selected: selected == tab,
          activeColor: primary,
          idleColor: idleColor,
          onTap: () => onSelected(tab),
        ),
      );
    }

    final dashboardSelected = selected == DashboardTab.dashboard;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          sideMargin, 0, sideMargin, bottomGap + extraBottom),
      child: SizedBox(
        height: overhang + barHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ---- the glass bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: barHeight,
              child: _GlassBarSurface(
                notchRadius: showDashboard ? notchRadius : 0,
                notchCenterY: buttonDrop,
                dark: dark,
                child: Row(
                  children: [
                    sideItem(DashboardTab.home, Icons.home_outlined,
                        Icons.home_rounded, 'Home'),
                    if (showDashboard)
                      // Label under the centre button, on the same line as
                      // the side labels.
                      SizedBox(
                        width: notchRadius * 2 + 8,
                        child: _CenterLabel(
                          selected: dashboardSelected,
                          activeColor: primary,
                          idleColor: idleColor,
                          onTap: () => onSelected(DashboardTab.dashboard),
                        ),
                      ),
                    sideItem(DashboardTab.profile, Icons.person_outline_rounded,
                        Icons.person_rounded, 'Profile'),
                  ],
                ),
              ),
            ),

            // ---- the raised Dashboard button in the notch
            if (showDashboard)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Semantics(
                    button: true,
                    selected: dashboardSelected,
                    label: 'Dashboard',
                    excludeSemantics: true,
                    child: GlassButton(
                      icon: AnimatedDashboardIcon(active: dashboardSelected),
                      onTap: () => onSelected(DashboardTab.dashboard),
                      width: buttonSize,
                      height: buttonSize,
                      iconSize: 28,
                      useOwnLayer: true,
                      style: dashboardSelected
                          ? GlassButtonStyle.prominent
                          : GlassButtonStyle.filled,
                      tintColor: dashboardSelected ? primary : null,
                      iconColor: dashboardSelected ? Colors.white : primary,
                      glowColor: primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Frosted glass shaped like a rounded bar with a round notch at the top
/// centre: blurred backdrop, light tint, bright rim and a soft shadow.
class _GlassBarSurface extends StatelessWidget {
  const _GlassBarSurface({
    required this.notchRadius,
    required this.notchCenterY,
    required this.dark,
    required this.child,
  });

  /// 0 for a plain bar with no notch.
  final double notchRadius;

  /// The notch circle's centre, measured down from the bar's top edge.
  final double notchCenterY;
  final bool dark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final shape = _NotchedBarShape(
      radius: 26,
      notchRadius: notchRadius,
      notchCenterY: notchCenterY,
    );
    return CustomPaint(
      painter: _BarShadowPainter(shape),
      child: ClipPath(
        clipper: _ShapeClipper(shape),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: CustomPaint(
            painter: _BarGlassPainter(shape, dark: dark),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Builds the bar outline: a rounded rectangle with a smooth circular notch
/// cut into the middle of its top edge.
class _NotchedBarShape {
  const _NotchedBarShape({
    required this.radius,
    required this.notchRadius,
    required this.notchCenterY,
  });

  final double radius;
  final double notchRadius;
  final double notchCenterY;

  Path pathFor(Size size) {
    final rect = Offset.zero & size;
    final rounded = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    if (notchRadius <= 0) return rounded;

    // CircularNotchedRectangle gives the smooth shoulders around the notch
    // but square corners; intersect it with the rounded rect for both.
    final guest = Rect.fromCircle(
      center: Offset(size.width / 2, notchCenterY),
      radius: notchRadius,
    );
    final notched = const CircularNotchedRectangle().getOuterPath(rect, guest);
    return Path.combine(PathOperation.intersect, rounded, notched);
  }
}

class _ShapeClipper extends CustomClipper<Path> {
  const _ShapeClipper(this.shape);
  final _NotchedBarShape shape;

  @override
  Path getClip(Size size) => shape.pathFor(size);

  @override
  bool shouldReclip(_ShapeClipper old) =>
      old.shape.notchRadius != shape.notchRadius;
}

class _BarShadowPainter extends CustomPainter {
  const _BarShadowPainter(this.shape);
  final _NotchedBarShape shape;

  @override
  void paint(Canvas canvas, Size size) {
    final path = shape.pathFor(size);
    canvas.drawPath(
      path.shift(const Offset(0, 6)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
  }

  @override
  bool shouldRepaint(_BarShadowPainter old) =>
      old.shape.notchRadius != shape.notchRadius;
}

class _BarGlassPainter extends CustomPainter {
  const _BarGlassPainter(this.shape, {required this.dark});
  final _NotchedBarShape shape;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final path = shape.pathFor(size);
    final rect = Offset.zero & size;

    // Tint: a little brighter at the top, like light hitting glass.
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: dark
              ? [
                  Colors.white.withValues(alpha: 0.16),
                  Colors.white.withValues(alpha: 0.08),
                ]
              : [
                  Colors.white.withValues(alpha: 0.72),
                  Colors.white.withValues(alpha: 0.52),
                ],
        ).createShader(rect),
    );

    // Rim: bright on the top-left, fading towards the bottom-right.
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: dark ? 0.45 : 0.95),
            Colors.white.withValues(alpha: dark ? 0.10 : 0.35),
            Colors.white.withValues(alpha: dark ? 0.25 : 0.70),
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_BarGlassPainter old) =>
      old.dark != dark || old.shape.notchRadius != shape.notchRadius;
}

/// Home / Profile: icon and label, with a soft pill behind the icon when
/// selected.
///
/// Jelly motion: pressing squashes the pill flat; on release (and whenever
/// the item becomes selected) it pops in and wobbles, stretching wide then
/// tall, settling in about 0.8 s. Turned off when the system asks to reduce
/// motion.
class _BarItem extends StatefulWidget {
  const _BarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.idleColor,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final Color activeColor;
  final Color idleColor;
  final VoidCallback onTap;

  @override
  State<_BarItem> createState() => _BarItemState();
}

class _BarItemState extends State<_BarItem> with TickerProviderStateMixin {
  /// 0 → 1 as the pill appears (reverses when the item is deselected).
  late final AnimationController _select = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
    reverseDuration: const Duration(milliseconds: 200),
    value: widget.selected ? 1 : 0,
  );

  /// One run of the jelly wobble.
  late final AnimationController _jelly = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 820),
  );

  bool _pressed = false;

  bool get _reduceMotion =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  @override
  void didUpdateWidget(_BarItem old) {
    super.didUpdateWidget(old);
    if (widget.selected == old.selected) return;
    if (widget.selected) {
      _select.forward();
      _wobble();
    } else {
      _select.reverse();
    }
  }

  void _wobble() {
    if (_reduceMotion) return;
    _jelly.forward(from: 0);
  }

  void _setPressed(bool value) {
    if (_pressed == value || _reduceMotion) return;
    setState(() => _pressed = value);
  }

  @override
  void dispose() {
    _select.dispose();
    _jelly.dispose();
    super.dispose();
  }

  /// Damped wobble: starts at 0, swings ± and dies out.
  static double _wave(double t) =>
      math.exp(-4.8 * t) * math.sin(2 * math.pi * 3.2 * t);

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final color = selected ? widget.activeColor : widget.idleColor;

    return Semantics(
      button: true,
      selected: selected,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: () {
          // Already selected: wobble anyway so the tap feels alive.
          if (selected) _wobble();
          widget.onTap();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([_select, _jelly]),
              builder: (context, _) {
                final appear = _select.value;
                final w = _jelly.isAnimating ? _wave(_jelly.value) : 0.0;

                // Squash & stretch: wider when shorter, like a jelly.
                var sx = 1 + 0.22 * w;
                var sy = 1 - 0.18 * w;
                if (_pressed) {
                  sx *= 1.12;
                  sy *= 0.84;
                }
                // The pill grows out from the icon as it appears.
                final pillScale =
                    0.5 + 0.5 * Curves.easeOutBack.transform(appear);

                return SizedBox(
                  width: 64,
                  height: 32,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (appear > 0)
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.diagonal3Values(
                              sx * pillScale, sy * pillScale, 1),
                          child: Opacity(
                            opacity: appear.clamp(0.0, 1.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color:
                                    widget.activeColor.withValues(alpha: 0.13),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const SizedBox(width: 60, height: 32),
                            ),
                          ),
                        ),
                      // The icon follows the jelly a little less than the
                      // pill, and lifts as the pill stretches tall.
                      Transform.translate(
                        offset: Offset(0, -2.5 * w),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.diagonal3Values(
                            (1 + (sx - 1) * 0.6) * (1 + 0.08 * appear),
                            (1 + (sy - 1) * 0.6) * (1 + 0.08 * appear),
                            1,
                          ),
                          child: Icon(
                            selected ? widget.activeIcon : widget.icon,
                            size: 24,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 3),
            _Label(widget.label, selected: selected, color: color),
          ],
        ),
      ),
    );
  }
}

/// "Dashboard" under the centre button (the button itself sits above).
class _CenterLabel extends StatelessWidget {
  const _CenterLabel({
    required this.selected,
    required this.activeColor,
    required this.idleColor,
    required this.onTap,
  });

  final bool selected;
  final Color activeColor;
  final Color idleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: _Label('Dashboard',
                selected: selected, color: selected ? activeColor : idleColor),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text, {required this.selected, required this.color});

  final String text;
  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(
        fontSize: 11,
        height: 1.2,
        color: color,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
      child: Text(text, maxLines: 1, overflow: TextOverflow.fade),
    );
  }
}
