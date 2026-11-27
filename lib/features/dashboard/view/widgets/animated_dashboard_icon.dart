import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// The Dashboard tab's original "insights" icon (outlined, or rounded when
/// [active]), with a light animation: every loop it pops up a little and a
/// soft shine sweeps across it; the rest of the time it sits still.
///
/// Colour and size come from the surrounding [IconTheme], so the glass tab bar
/// tints it like the other tab icons. The phase comes from the wall clock, so
/// every copy the bar draws stays in step. Shows the plain icon when the
/// system asks to reduce motion.
class AnimatedDashboardIcon extends StatefulWidget {
  const AnimatedDashboardIcon({super.key, this.active = false});

  /// Selected tab: uses the filled/rounded glyph.
  final bool active;

  static const Duration period = Duration(milliseconds: 2800);

  @override
  State<AnimatedDashboardIcon> createState() => _AnimatedDashboardIconState();
}

class _AnimatedDashboardIconState extends State<AnimatedDashboardIcon>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker((_) => setState(() {}));

  // Timeline (fractions of one loop).
  static const _popEnd = 0.26;
  static const _shineStart = 0.12;
  static const _shineEnd = 0.56;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduceMotion && _ticker.isActive) _ticker.stop();
    if (!reduceMotion && !_ticker.isActive) _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      widget.active ? Icons.insights_rounded : Icons.insights_outlined,
      semanticLabel: 'Dashboard',
    );
    if (!_ticker.isActive) return icon;

    final ms = AnimatedDashboardIcon.period.inMilliseconds;
    final phase = (DateTime.now().millisecondsSinceEpoch % ms) / ms;

    // Pop: up and back down once, with a slight lift.
    final pop = phase < _popEnd ? math.sin(math.pi * phase / _popEnd) : 0.0;
    final scale = 1 + 0.16 * pop;
    final lift = -1.6 * pop;

    // Shine: a light band moving left → right across the glyph.
    final shine = ((phase - _shineStart) / (_shineEnd - _shineStart));
    final shining = shine > 0 && shine < 1;

    Widget child = icon;
    if (shining) {
      final base = IconTheme.of(context).color ?? Colors.black87;
      final light = Color.lerp(base, Colors.white, 0.7)!;
      final center = -0.3 + 1.6 * Curves.easeInOut.transform(shine);
      child = ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (rect) => LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [base, light, base],
          stops: [
            (center - 0.22).clamp(0.0, 1.0),
            center.clamp(0.0, 1.0),
            (center + 0.22).clamp(0.0, 1.0),
          ],
        ).createShader(rect),
        child: icon,
      );
    }

    return Transform.translate(
      offset: Offset(0, lift),
      child: Transform.scale(scale: scale, child: child),
    );
  }
}
