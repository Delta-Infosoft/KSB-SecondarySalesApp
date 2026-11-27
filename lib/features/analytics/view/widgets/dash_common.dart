import 'package:flutter/material.dart';

import '../../model/analytics_models.dart';

/// Palette (web dashboard colours + a few accents for the mobile layout).
class DashColors {
  static const background = Color(0xFFF4F6FB);
  static const card = Colors.white;
  static const border = Color(0xFFE8EAF2);
  static const title = Color(0xFF111827);
  static const text = Color(0xFF374151);
  static const muted = Color(0xFF6B7280);
  static const axis = Color(0xFF9CA3AF);
  static const linkedFill = Color(0xFFE9D5FF);
  static const linkedBorder = Color(0xFFA78BFA);
  static const linkedStrong = Color(0xFF8B5CF6);
  static const unlinked = Color(0xFFFEF3C7);
  static const unlinkedStrong = Color(0xFFF59E0B);
  static const issuedLine = Color(0xFFA855F7);
  static const linkedLine = Color(0xFF06B6D4);
  static const tabActive = Color(0xFF3B82F6);
  static const tableHeader = Color(0xFFEDE9FE);
  static const tableHeaderText = Color(0xFF5B21B6);
  static const tableRow = Color(0xFFFAF8FF);
  static const gradientStart = Color(0xFF6D28D9);
  static const gradientEnd = Color(0xFF2563EB);
  static const success = Color(0xFF10B981);
}

const _cardShadow = [
  BoxShadow(color: Color(0x0D1F2937), blurRadius: 16, offset: Offset(0, 6)),
];

// ---------------------------------------------------------------------------
// Card with icon, title, optional subtitle and a Chart / Table segmented toggle
// ---------------------------------------------------------------------------
class DashCard extends StatefulWidget {
  const DashCard({
    super.key,
    required this.title,
    required this.chart,
    this.table,
    this.icon,
    this.accent = DashColors.linkedStrong,
    this.subtitle,
    this.headerActions,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color accent;
  final Widget chart;
  final Widget? table;
  final List<Widget>? headerActions;

  @override
  State<DashCard> createState() => _DashCardState();
}

class _DashCardState extends State<DashCard> {
  bool _showTable = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: DashColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DashColors.border),
        boxShadow: _cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (widget.icon != null) ...[
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: widget.accent.withOpacity(.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon, size: 19, color: widget.accent),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: DashColors.title)),
                      if (widget.subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(widget.subtitle!,
                              style: const TextStyle(
                                  fontSize: 12, color: DashColors.muted)),
                        ),
                    ],
                  ),
                ),
                if (widget.table != null)
                  _ViewToggle(
                    showTable: _showTable,
                    onChanged: (v) => setState(() => _showTable = v),
                  ),
              ],
            ),
            if (widget.headerActions != null) ...[
              const SizedBox(height: 12),
              Row(children: widget.headerActions!),
            ],
            const SizedBox(height: 14),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              child: _showTable && widget.table != null
                  ? KeyedSubtree(
                      key: const ValueKey('table'), child: widget.table!)
                  : KeyedSubtree(
                      key: const ValueKey('chart'), child: widget.chart),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.showTable, required this.onChanged});
  final bool showTable;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget seg(IconData icon, bool selected, String tip, VoidCallback onTap) {
      return Tooltip(
        message: tip,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: selected
                  ? const [BoxShadow(color: Color(0x1A000000), blurRadius: 4)]
                  : null,
            ),
            child: Icon(icon,
                size: 18,
                color: selected ? DashColors.linkedStrong : DashColors.axis),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          seg(Icons.bar_chart_rounded, !showTable, 'Show chart',
              () => onChanged(false)),
          seg(Icons.table_rows_rounded, showTable, 'Show table',
              () => onChanged(true)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// KPI tile
// ---------------------------------------------------------------------------
class KpiTile extends StatelessWidget {
  const KpiTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DashColors.border),
        boxShadow: _cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(value,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: DashColors.title)),
                ),
                const SizedBox(height: 2),
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 12, color: DashColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashEmpty extends StatelessWidget {
  const DashEmpty({super.key, this.height = 160});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_chart_outlined_rounded,
                size: 40, color: Color(0xFFD1D5DB)),
            SizedBox(height: 8),
            Text('No data available',
                style: TextStyle(color: DashColors.muted, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class DashLegend extends StatelessWidget {
  const DashLegend({super.key, required this.items, this.dot = false});
  final List<(Color, String)> items;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 6,
      children: items
          .map((e) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: e.$1,
                      shape: dot ? BoxShape.circle : BoxShape.rectangle,
                      borderRadius: dot ? null : BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(e.$2,
                      style: const TextStyle(
                          fontSize: 12.5, color: DashColors.text)),
                ],
              ))
          .toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Table: shows the first rows with a "Show all" toggle (no inner vertical
// scroll, so the dashboard scrolls as one smooth page); the whole table
// scrolls horizontally when columns don't fit.
// ---------------------------------------------------------------------------
class DashTable extends StatefulWidget {
  const DashTable({
    super.key,
    required this.columns,
    required this.rows,
    this.flex,
    this.maxHeight = 300,
  });

  final List<String> columns;
  final List<List<String>> rows;

  /// Relative column widths (defaults: first column 3, others 1).
  final List<int>? flex;
  final double maxHeight;

  @override
  State<DashTable> createState() => _DashTableState();
}

class _DashTableState extends State<DashTable> {
  final _horizontal = ScrollController();
  bool _expanded = false;

  static const _rowHeight = 44.0;
  static const _headerHeight = 42.0;

  @override
  void dispose() {
    _horizontal.dispose();
    super.dispose();
  }

  bool _isNumeric(int col) =>
      widget.rows.isNotEmpty &&
      widget.rows.every((r) =>
          col < r.length && RegExp(r'^-?[\d.,]+%?$').hasMatch(r[col].trim()));

  @override
  Widget build(BuildContext context) {
    if (widget.rows.isEmpty) return const DashEmpty();
    final cols = widget.columns.length;
    final flex = widget.flex ??
        List.generate(cols, (i) => i == 0 ? 3 : (_isNumeric(i) ? 1 : 2));
    final numeric = List.generate(cols, _isNumeric);
    final totalFlex = flex.fold<int>(0, (a, b) => a + b);

    return LayoutBuilder(builder: (context, constraints) {
      // Minimum ~70px per flex unit so text stays readable; otherwise fill width.
      final minWidth = totalFlex * 70.0;
      final width =
          constraints.maxWidth > minWidth ? constraints.maxWidth : minWidth;
      final widths = flex.map((f) => width * f / totalFlex).toList();
      // Rows that fit in maxHeight are shown; the rest behind "Show all".
      final collapsed = ((widget.maxHeight - _headerHeight) / _rowHeight)
          .floor()
          .clamp(1, 1000);
      final canExpand = widget.rows.length > collapsed;
      final shown = canExpand && !_expanded ? collapsed : widget.rows.length;

      Widget cell(String text, int i, {bool header = false}) => Container(
            width: widths[i],
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment:
                numeric[i] ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: numeric[i] ? TextAlign.right : TextAlign.left,
              style: header
                  ? const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: DashColors.tableHeaderText)
                  : const TextStyle(fontSize: 13, color: DashColors.text),
            ),
          );

      final table = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: DashColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Scrollbar(
            controller: _horizontal,
            thumbVisibility: width > constraints.maxWidth,
            notificationPredicate: (n) => n.depth == 0,
            child: SingleChildScrollView(
              controller: _horizontal,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sticky header
                    Container(
                      height: _headerHeight,
                      color: DashColors.tableHeader,
                      child: Row(
                        children: [
                          for (var i = 0; i < cols; i++)
                            cell(widget.columns[i], i, header: true),
                        ],
                      ),
                    ),
                    // Rows: no inner vertical scroll, the page scrolls.
                    for (var r = 0; r < shown; r++)
                      Container(
                        height: _rowHeight,
                        decoration: BoxDecoration(
                          color: r.isEven ? Colors.white : DashColors.tableRow,
                          border: const Border(
                              top: BorderSide(color: DashColors.border)),
                        ),
                        child: Row(
                          children: [
                            for (var i = 0; i < cols; i++)
                              cell(
                                  i < widget.rows[r].length
                                      ? widget.rows[r][i]
                                      : '',
                                  i),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      return AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            table,
            if (canExpand)
              DashShowMore(
                expanded: _expanded,
                total: widget.rows.length,
                onTap: () => setState(() => _expanded = !_expanded),
              ),
          ],
        ),
      );
    });
  }
}

/// "Show all (N)" / "Show less" toggle under a collapsed list or table.
class DashShowMore extends StatelessWidget {
  const DashShowMore({
    super.key,
    required this.expanded,
    required this.total,
    required this.onTap,
  });

  final bool expanded;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton.icon(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: DashColors.linkedStrong,
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        icon: Icon(
          expanded
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded,
          size: 20,
        ),
        label: Text(expanded ? 'Show less' : 'Show all ($total)'),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Horizontal bar list (Zonal / Branch sections): first items + "Show all".
// ---------------------------------------------------------------------------
class HorizontalBarList extends StatefulWidget {
  const HorizontalBarList(
      {super.key, required this.data, this.maxHeight = 300});
  final List<LabelValue> data;
  final double maxHeight;

  @override
  State<HorizontalBarList> createState() => _HorizontalBarListState();
}

class _HorizontalBarListState extends State<HorizontalBarList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    if (data.isEmpty) return const DashEmpty();
    final maxValue =
        data.map((e) => e.value).fold<int>(0, (a, b) => a > b ? a : b);
    const itemHeight = 58.0;
    final collapsed = (widget.maxHeight / itemHeight).floor().clamp(1, 1000);
    final canExpand = data.length > collapsed;
    final shown = canExpand && !_expanded ? collapsed : data.length;

    Widget itemAt(int i) {
      final item = data[i];
      final ratio = maxValue == 0 ? 0.0 : item.value / maxValue;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              _RankBadge(rank: i + 1),
              const SizedBox(width: 8),
              Expanded(
                child: Text(item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: DashColors.title)),
              ),
              const SizedBox(width: 8),
              Text('${item.value}',
                  style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: DashColors.title)),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(height: 8, color: const Color(0xFFF1EDFB)),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: ratio),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, __) => FractionallySizedBox(
                    widthFactor: v.clamp(0.02, 1.0),
                    child: Container(
                      height: 8,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                          DashColors.linkedBorder,
                          DashColors.linkedStrong,
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // No inner vertical scroll: the page scrolls as one.
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < shown; i++)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(height: itemHeight, child: itemAt(i)),
            ),
          if (canExpand)
            DashShowMore(
              expanded: _expanded,
              total: data.length,
              onTap: () => setState(() => _expanded = !_expanded),
            ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});
  final int rank;

  @override
  Widget build(BuildContext context) {
    final top = rank <= 3;
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: top ? DashColors.linkedStrong : const Color(0xFFF1F2F7),
        shape: BoxShape.circle,
      ),
      child: Text('$rank',
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: top ? Colors.white : DashColors.muted)),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.subtitle});
  final String text;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12, left: 2),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [DashColors.gradientStart, DashColors.gradientEnd],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text(text,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: DashColors.title)),
          if (subtitle != null) ...[
            const SizedBox(width: 8),
            Text(subtitle!,
                style:
                    const TextStyle(fontSize: 12.5, color: DashColors.muted)),
          ],
        ],
      ),
    );
  }
}

String percentText(int part, int total) =>
    total == 0 ? '0%' : '${(part / total * 100).toStringAsFixed(0)}%';
