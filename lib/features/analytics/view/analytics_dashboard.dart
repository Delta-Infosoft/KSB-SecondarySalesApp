import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/utils/constants/app_assets.dart';
import '../model/analytics_models.dart';
import '../view_model/analytics_controller.dart';
import 'widgets/dash_charts.dart';
import 'widgets/dash_common.dart';
import 'widgets/dash_filters.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/app_refresh.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/shimmer_loaders.dart';

/// Mobile version of the web dashboard (galaxy.ierp.in:58/#/dashboard/default).
class AnalyticsDashboard extends GetView<AnalyticsController> {
  const AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(child: Text('Dashboard')),
            SvgPicture.asset(AppAssets.ksbLogo, height: 28),
          ],
        ),
        actions: const [DashFilterButton(), SizedBox(width: 4)],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Obx(() => controller.isLoading.value
              ? const LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                )
              : const SizedBox(height: 3)),
        ),
      ),
      body: AppRefreshScrollView(
        onRefresh: controller.loadAll,
        slivers: [
          SliverPadding(
            // Extra bottom space so the last card clears the floating glass bar.
            padding: EdgeInsets.fromLTRB(
                16, 16, 16, 28 + MediaQuery.paddingOf(context).bottom),
            // Skeleton while the dashboard (re)loads; real cards afterwards.
            sliver: SliverToBoxAdapter(
              child: Obx(() => controller.isLoading.value
                  ? const ShimmerDashboard()
                  : _content()),
            ),
          ),
        ],
      ),
    );
  }

  /// Sections are shown according to the user's role (see DashboardAccess).
  Widget _content() {
    final access = controller.access;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (access.summary) ...[
          _overallLinking(),
          _topCustomers(),
          _topProducts(),
          _pumpLinkedOverTime(),
        ],
        if (access.zonal) ...[
          const SizedBox(height: 4),
          const SectionTitle('Zonal'),
          _zonal(),
        ],
        if (access.branch) ...[
          const SizedBox(height: 4),
          const SectionTitle('Branch'),
          _branch(),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------- cards
  Widget _overallLinking() => Obx(() {
        final issued = controller.totalIssued.value;
        final linked = controller.totalLinked;
        final pending = controller.totalPending;
        return DashCard(
          title: 'Overall % linking',
          subtitle: 'Linked vs unlinked pumps',
          icon: Icons.donut_large_rounded,
          chart: LinkingDonut(
            issued: issued,
            linked: linked,
            pending: pending,
            percent: controller.linkedPercent,
          ),
          table: DashTable(
            columns: const ['Status', 'Count', 'Linking %'],
            flex: const [2, 1, 1],
            rows: issued == 0
                ? const []
                : [
                    ['Linked', '$linked', percentText(linked, issued)],
                    ['Unlinked', '$pending', percentText(pending, issued)],
                  ],
          ),
        );
      });

  Widget _topCustomers() => Obx(() {
        final data = controller.topCustomers.toList();
        return DashCard(
          title: 'Top 10 Customers by Linked Pumps',
          icon: Icons.groups_rounded,
          accent: DashColors.tabActive,
          chart: VerticalBarChart(data: data, xAxisTitle: 'Customers'),
          table: DashTable(
            columns: const ['Customer', 'Linked'],
            rows: data.map((e) => [e.label, '${e.value}']).toList(),
          ),
        );
      });

  Widget _topProducts() => Obx(() {
        final data = controller.topProducts.toList();
        return DashCard(
          title: 'Top products',
          icon: Icons.precision_manufacturing_rounded,
          accent: DashColors.linkedLine,
          chart: VerticalBarChart(
            data: data.map((e) => LabelValue(e.name, e.linked)).toList(),
            showValues: true,
            legend: 'Linked Products',
          ),
          table: DashTable(
            columns: const ['Product', 'Issued', 'Linked', 'Linking%'],
            flex: const [4, 1, 1, 1],
            rows: data
                .map((e) => [
                      e.name,
                      '${e.issued}',
                      '${e.linked}',
                      percentText(e.linked, e.issued),
                    ])
                .toList(),
          ),
        );
      });

  Widget _pumpLinkedOverTime() => Obx(() {
        final points = controller.timeline.toList();
        final period = controller.periodType.value;
        return DashCard(
          title: 'Pump Linked Over Time',
          subtitle:
              'Latest 10 ${period == 'DAY' ? 'days' : 'weeks'} with activity',
          icon: Icons.show_chart_rounded,
          accent: DashColors.issuedLine,
          headerActions: [
            _PeriodSwitch(
              value: period,
              onChanged: controller.switchPeriod,
            ),
          ],
          chart: controller.isTimelineLoading.value && points.isEmpty
              ? const ShimmerChart(height: 240)
              : PumpLinkedLineChart(points: points),
          table: DashTable(
            columns: const ['Date', 'Issued', 'Linked'],
            flex: const [2, 1, 1],
            rows: points
                .map((p) => [p.date, '${p.issued}', '${p.linked}'])
                .toList(),
          ),
        );
      });

  Widget _zonal() => Obx(() {
        final zones = controller.zoneLinking.toList();
        final ascs = controller.ascZoneLinking.toList();
        final products = controller.productZoneLinking.toList();
        return Column(
          children: [
            DashCard(
              title: 'Top Zone by Linking',
              icon: Icons.public_rounded,
              accent: DashColors.tabActive,
              chart: HorizontalBarList(data: zones),
              table: DashTable(
                columns: const ['Zone', 'Linked'],
                rows: zones.map((e) => [e.label, '${e.value}']).toList(),
              ),
            ),
            DashCard(
              title: 'Top ASC by Linking',
              icon: Icons.storefront_rounded,
              accent: DashColors.success,
              chart: HorizontalBarList(data: ascs),
              table: DashTable(
                columns: const ['Username', 'Linked'],
                rows: ascs.map((e) => [e.label, '${e.value}']).toList(),
              ),
            ),
            DashCard(
              title: 'Top Products by Linked',
              icon: Icons.category_rounded,
              accent: DashColors.linkedLine,
              chart: HorizontalBarList(data: products),
              table: DashTable(
                columns: const ['Product', 'Linked'],
                flex: const [4, 1],
                rows: products.map((e) => [e.label, '${e.value}']).toList(),
              ),
            ),
          ],
        );
      });

  Widget _branch() => Obx(() {
        final ascRows = controller.ascBranchRows.toList();
        final productRows = controller.productBranchRows.toList();
        return Column(
          children: [
            DashCard(
              title: 'Top ASC by Linking',
              icon: Icons.storefront_rounded,
              accent: DashColors.success,
              chart: HorizontalBarList(data: controller.ascBranchLinking),
              table: DashTable(
                columns: const ['Branch', 'Name', 'Linked'],
                flex: const [2, 3, 1],
                rows: ascRows
                    .map((e) => [e.branch, e.name, '${e.linked}'])
                    .toList(),
              ),
            ),
            DashCard(
              title: 'Top ASC by Product Linking',
              icon: Icons.inventory_rounded,
              accent: DashColors.unlinkedStrong,
              chart: HorizontalBarList(data: controller.productBranchLinking),
              table: DashTable(
                columns: const ['Product', 'Branch', 'Issued', 'Linking%'],
                flex: const [4, 2, 1, 1],
                rows: productRows
                    .map((e) => [
                          e.product,
                          e.branch,
                          '${e.issued}',
                          percentText(e.linked, e.issued),
                        ])
                    .toList(),
              ),
            ),
          ],
        );
      });
}

/// Day / Week segmented switch.
class _PeriodSwitch extends StatelessWidget {
  const _PeriodSwitch({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget seg(String label, String key) {
      final active = value == key;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? DashColors.tabActive : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : DashColors.muted,
                )),
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F2F7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [seg('Day', 'DAY'), seg('Week', 'WEEK')]),
      ),
    );
  }
}
