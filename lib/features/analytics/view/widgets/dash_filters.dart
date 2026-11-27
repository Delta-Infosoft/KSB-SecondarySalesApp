import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/analytics_models.dart';
import '../../view_model/analytics_controller.dart';
import 'dash_common.dart';

/// One-line summary of the current filters, e.g. "EAST • PATNA • KSB Admin (aaa)".
String dashFilterSummary(AnalyticsController c) {
  final parts = <String>[
    c.labelFor(c.zoneOptions, c.selectedZone.value),
    c.labelFor(c.branchOptions, c.selectedBranch.value),
    c.labelFor(c.userOptions, c.selectedUserId.value),
  ];
  return parts.join('  •  ');
}

/// App-bar filter button. Shows a dot when any filter is applied.
class DashFilterButton extends GetView<AnalyticsController> {
  const DashFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = controller.selectedZone.value.isNotEmpty ||
          controller.selectedBranch.value.isNotEmpty ||
          controller.selectedUserId.value.isNotEmpty ||
          controller.fromDate.value != null ||
          controller.toDate.value != null;
      return IconButton(
        tooltip: 'Filters',
        onPressed: () => showDashFilterSheet(context),
        icon: Badge(
          isLabelVisible: active,
          smallSize: 8,
          backgroundColor: const Color(0xFFF59E0B),
          child: const Icon(Icons.filter_alt_outlined),
        ),
      );
    });
  }
}

/// Zone / Branch / User / From date / To date + "Filter Results", like the web,
/// shown in a bottom sheet opened from the app bar.
Future<void> showDashFilterSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => const _FilterSheet(),
  );
}

class _FilterSheet extends GetView<AnalyticsController> {
  const _FilterSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        child: Obx(() {
          final zoneOpts = controller.zoneOptions;
          final branchOpts = controller.branchOptions;
          final userOpts = controller.userOptions;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: DashColors.border,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: DashColors.tabActive.withOpacity(.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.tune_rounded,
                        size: 19, color: DashColors.tabActive),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Filters',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: DashColors.title)),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded,
                        color: DashColors.muted),
                  ),
                ],
              ),
              // Zone / Branch / User only for roles allowed to change them;
              // others stay on their own data (dates still work).
              if (controller.access.filters) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _PickerField(
                        label: 'Zone',
                        icon: Icons.place_outlined,
                        value: controller.labelFor(
                            zoneOpts, controller.selectedZone.value),
                        onTap: () => _pick(
                            context,
                            'Select Zone',
                            zoneOpts,
                            controller.selectedZone.value,
                            controller.onZoneChange),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickerField(
                        label: 'Branch',
                        icon: Icons.apartment_rounded,
                        value: controller.labelFor(
                            branchOpts, controller.selectedBranch.value),
                        onTap: () => _pick(
                            context,
                            'Select Branch',
                            branchOpts,
                            controller.selectedBranch.value,
                            controller.onBranchChange),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _PickerField(
                  label: 'User',
                  icon: Icons.person_outline_rounded,
                  value: controller.labelFor(
                      userOpts, controller.selectedUserId.value),
                  onTap: () => _pick(context, 'Select User', userOpts,
                      controller.selectedUserId.value, controller.onUserChange),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      label: 'From Date',
                      date: controller.fromDate.value,
                      onChanged: (d) => controller.fromDate.value = d,
                      lastDate: controller.toDate.value,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateField(
                      label: 'To Date',
                      date: controller.toDate.value,
                      onChanged: (d) => controller.toDate.value = d,
                      firstDate: controller.fromDate.value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _GradientButton(
                loading: controller.isLoading.value,
                onTap: () {
                  Navigator.pop(context);
                  controller.onFilter();
                },
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _pick(
      BuildContext context,
      String title,
      List<FilterOption> options,
      String selected,
      ValueChanged<String> onSelected) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) =>
          _OptionSheet(title: title, options: options, selected: selected),
    );
    if (result != null) onSelected(result);
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: DashColors.muted)),
      );
}

BoxDecoration get _fieldDecoration => BoxDecoration(
      color: const Color(0xFFF8F9FC),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: DashColors.border),
    );

class _PickerField extends StatelessWidget {
  const _PickerField(
      {required this.label,
      required this.value,
      required this.onTap,
      required this.icon});
  final String label;
  final String value;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: _fieldDecoration,
            child: Row(
              children: [
                Icon(icon, size: 17, color: DashColors.muted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, color: DashColors.title)),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    size: 20, color: DashColors.axis),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final DateTime? date;
  final ValueChanged<DateTime?> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            final first = firstDate ?? DateTime(2020);
            final last = lastDate ?? DateTime(DateTime.now().year + 5);
            var initial = date ?? DateTime.now();
            if (initial.isBefore(first)) initial = first;
            if (initial.isAfter(last)) initial = last;
            final picked = await showDatePicker(
              context: context,
              initialDate: initial,
              firstDate: first,
              lastDate: last,
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            height: 46,
            padding: const EdgeInsets.only(left: 12, right: 4),
            decoration: _fieldDecoration,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date == null
                        ? 'Select date'
                        : DateFormat('yyyy-MM-dd').format(date!),
                    style: TextStyle(
                      fontSize: 14,
                      color: date == null ? DashColors.axis : DashColors.title,
                    ),
                  ),
                ),
                if (date != null)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close_rounded,
                        size: 18, color: DashColors.axis),
                    onPressed: () => onChanged(null),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.calendar_today_outlined,
                        size: 16, color: DashColors.axis),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.onTap, required this.loading});
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [DashColors.gradientStart, DashColors.gradientEnd]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Color(0x402563EB), blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: loading ? null : onTap,
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('✨ Filter Results',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionSheet extends StatefulWidget {
  const _OptionSheet(
      {required this.title, required this.options, required this.selected});
  final String title;
  final List<FilterOption> options;
  final String selected;

  @override
  State<_OptionSheet> createState() => _OptionSheetState();
}

class _OptionSheetState extends State<_OptionSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.options
        : widget.options
            .where((o) => o.label.toLowerCase().contains(_query.toLowerCase()))
            .toList();
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: DashColors.border,
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Text(widget.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            if (widget.options.length > 8)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final o = filtered[i];
                  final isSelected = o.value == widget.selected;
                  return ListTile(
                    title: Text(o.label),
                    trailing: isSelected
                        ? const Icon(Icons.check_rounded,
                            color: DashColors.tabActive)
                        : null,
                    selected: isSelected,
                    onTap: () => Navigator.pop(context, o.value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
