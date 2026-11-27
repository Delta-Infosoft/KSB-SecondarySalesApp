import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../model/analytics_models.dart';
import 'dash_common.dart';

String _short(String s, [int max = 14]) =>
    s.length <= max ? s : '${s.substring(0, max).trimRight()}…';

double _niceMax(num maxValue) {
  if (maxValue <= 0) return 5;
  if (maxValue <= 5) return 5;
  final step =
      math.pow(10, (math.log(maxValue) / math.ln10).floor()).toDouble();
  return (maxValue / step).ceil() * step;
}

const _axisStyle = TextStyle(fontSize: 11, color: DashColors.axis);

// ---------------------------------------------------------------------------
// Overall % linking — donut
// ---------------------------------------------------------------------------
class LinkingDonut extends StatelessWidget {
  const LinkingDonut({
    super.key,
    required this.issued,
    required this.linked,
    required this.pending,
    required this.percent,
  });

  final int issued;
  final int linked;
  final int pending;
  final double percent;

  @override
  Widget build(BuildContext context) {
    final hasData = issued > 0;
    return Column(
      children: [
        const DashLegend(items: [
          (DashColors.linkedBorder, 'Linked'),
          (Color(0xFFFDE68A), 'Unlinked'),
        ]),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  startDegreeOffset: -90,
                  sectionsSpace: 0,
                  centerSpaceRadius: 68,
                  sections: hasData
                      ? [
                          PieChartSectionData(
                            value: linked.toDouble(),
                            color: DashColors.linkedBorder,
                            radius: 26,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: pending.toDouble(),
                            color: const Color(0xFFFDE68A),
                            radius: 26,
                            showTitle: false,
                          ),
                        ]
                      : [
                          PieChartSectionData(
                            value: 1,
                            color: DashColors.border,
                            radius: 26,
                            showTitle: false,
                          ),
                        ],
                ),
                duration: const Duration(milliseconds: 500),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${percent.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: DashColors.title,
                    ),
                  ),
                  const Text('Linked',
                      style: TextStyle(fontSize: 13, color: DashColors.muted)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _stat('$issued', 'Total Issued'),
            _stat('$linked', 'Linked'),
            _stat('$pending', 'Pending'),
          ],
        ),
      ],
    );
  }

  Widget _stat(String value, String label) => Expanded(
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: DashColors.title)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(fontSize: 12, color: DashColors.muted)),
          ],
        ),
      );
}

// ---------------------------------------------------------------------------
// Vertical bar chart (Top customers / Top products)
// ---------------------------------------------------------------------------
class VerticalBarChart extends StatelessWidget {
  const VerticalBarChart({
    super.key,
    required this.data,
    this.xAxisTitle,
    this.showValues = false,
    this.legend,
  });

  final List<LabelValue> data;
  final String? xAxisTitle;
  final bool showValues;
  final String? legend;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const DashEmpty(height: 240);
    final maxY = _niceMax(data.map((e) => e.value).reduce(math.max));
    final interval = math.max(1, maxY / 5).toDouble();
    const barWidth = 24.0;

    final chart = BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        alignment: BarChartAlignment.spaceAround,
        borderData: FlBorderData(
          show: true,
          border: const Border(bottom: BorderSide(color: DashColors.border)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: DashColors.border, strokeWidth: 1),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF1F2937),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItem: (group, _, rod, __) => BarTooltipItem(
              '${data[group.x].label}\n${rod.toY.toInt()}',
              const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: showValues,
              reservedSize: 20,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= data.length) return const SizedBox();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 2,
                  child: Text('${data[i].value}',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: DashColors.title)),
                );
              },
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: interval,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(value.toInt().toString(), style: _axisStyle),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: xAxisTitle == null
                ? null
                : Text(xAxisTitle!,
                    style:
                        const TextStyle(fontSize: 13, color: DashColors.text)),
            axisNameSize: xAxisTitle == null ? 0 : 22,
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 64,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= data.length) return const SizedBox();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 6,
                  angle: -math.pi / 4,
                  child: Text(_short(data[i].label), style: _axisStyle),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(data.length, (i) {
          return BarChartGroupData(x: i, barRods: [
            BarChartRodData(
              toY: data[i].value.toDouble(),
              width: barWidth,
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [DashColors.linkedFill, DashColors.linkedBorder],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(6)),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxY,
                color: const Color(0xFFF7F5FD),
              ),
            ),
          ]);
        }),
      ),
      duration: const Duration(milliseconds: 400),
    );

    return Column(
      children: [
        if (legend != null) ...[
          DashLegend(items: [(DashColors.linkedBorder, legend!)]),
          const SizedBox(height: 12),
        ],
        // Each bar gets at least 64px; with many bars the chart scrolls sideways.
        LayoutBuilder(builder: (context, c) {
          final needed = data.length * 64.0 + 40;
          if (needed <= c.maxWidth) return SizedBox(height: 270, child: chart);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(width: needed, height: 270, child: chart),
          );
        }),
        if (data.length * 64.0 + 40 > MediaQuery.of(context).size.width - 66)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text('Swipe to see more →',
                style: TextStyle(fontSize: 11, color: DashColors.axis)),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pump linked over time — line chart
// ---------------------------------------------------------------------------
class PumpLinkedLineChart extends StatelessWidget {
  const PumpLinkedLineChart({super.key, required this.points});
  final List<TimePoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const DashEmpty(height: 240);
    final maxValue =
        points.map((p) => math.max(p.issued, p.linked)).reduce(math.max);
    final maxY = _niceMax(maxValue);
    final interval = math.max(1, maxY / 4).toDouble();

    LineChartBarData line(List<FlSpot> spots, Color color) => LineChartBarData(
          spots: spots,
          color: color,
          barWidth: 2.5,
          isCurved: true,
          curveSmoothness: 0.25,
          preventCurveOverShooting: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color.withOpacity(.22), color.withOpacity(0)],
            ),
          ),
          dotData: FlDotData(
            show: true,
            getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
              radius: 4,
              color: color,
              strokeWidth: 1.5,
              strokeColor: Colors.white,
            ),
          ),
        );

    return Column(
      children: [
        const DashLegend(dot: true, items: [
          (DashColors.issuedLine, 'Issued'),
          (DashColors.linkedLine, 'Linked'),
        ]),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (context, c) {
          // ~72px per date so labels never overlap; scroll sideways if needed.
          final needed = points.length * 72.0 + 40;
          final chart = SizedBox(
            width: needed > c.maxWidth ? needed : c.maxWidth,
            height: 240,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY,
                  minX: 0,
                  maxX:
                      (points.length - 1).toDouble().clamp(0, double.infinity),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (_) =>
                        const FlLine(color: DashColors.border, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                        bottom: BorderSide(color: DashColors.border, width: 2)),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => const Color(0xFF1F2937),
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipItems: (spots) => spots.map((s) {
                        final p = points[s.x.toInt()];
                        final isIssued = s.barIndex == 0;
                        return LineTooltipItem(
                          isIssued
                              ? '${p.date}\nIssued: ${p.issued}'
                              : 'Linked: ${p.linked}',
                          TextStyle(
                            color: isIssued
                                ? const Color(0xFFE9D5FF)
                                : const Color(0xFFA5F3FC),
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: interval,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          axisSide: meta.axisSide,
                          child:
                              Text(value.toInt().toString(), style: _axisStyle),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (value != i || i < 0 || i >= points.length) {
                            return const SizedBox();
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8,
                            child: Text(points[i].date, style: _axisStyle),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    line(
                      [
                        for (var i = 0; i < points.length; i++)
                          FlSpot(i.toDouble(), points[i].issued.toDouble())
                      ],
                      DashColors.issuedLine,
                    ),
                    line(
                      [
                        for (var i = 0; i < points.length; i++)
                          FlSpot(i.toDouble(), points[i].linked.toDouble())
                      ],
                      DashColors.linkedLine,
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 400),
              ),
            ),
          );
          if (needed <= c.maxWidth) return chart;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: chart,
          );
        }),
      ],
    );
  }
}
