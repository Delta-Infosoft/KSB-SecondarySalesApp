import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/constants/app_assets.dart';
import '../../../core/utils/extentions/context_extention.dart';
import '../../../core/utils/widgets/app_refresh.dart';
import '../../../core/utils/widgets/shimmer_loaders.dart';
import '../model/customer_approval_model.dart';
import '../view_model/customer_approval_controller.dart';
import 'customer_approval_form.dart';

/// Customers waiting for approval (and approved ones), like the web list.
class CustomerApprovalList extends GetView<CustomerApprovalController> {
  const CustomerApprovalList({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Expanded(child: Text('Customer Approval')),
              SvgPicture.asset(AppAssets.ksbLogo, height: 30),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                onChanged: (v) => controller.query.value = v,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search name, GST, ASC, C4C ID',
                  prefixIcon: const Icon(Icons.search_rounded),
                  isDense: true,
                  filled: true,
                  fillColor: context.primaryColor.withValues(alpha: .06),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Obx(() => _StatusTabs(
                  value: controller.status.value,
                  onChanged: controller.changeStatus,
                )),
            const SizedBox(height: 4),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const ShimmerCardList(lines: 2);
                }
                final list = controller.filtered;
                return AppRefreshScrollView(
                  onRefresh: controller.load,
                  slivers: [
                    if (list.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyState(
                          error: controller.hasError.value,
                          status: controller.status.value,
                          searching: controller.query.value.isNotEmpty,
                        ),
                      )
                    else ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
                          child: Text(
                            '${list.length} customer${list.length == 1 ? '' : 's'}',
                            style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16,
                            24 + MediaQuery.paddingOf(context).bottom),
                        sliver: SliverList.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) =>
                              _ApprovalCard(customer: list[i]),
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  const _StatusTabs({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: .06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            for (final s in CustomerApprovalController.statuses)
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: value == s
                          ? context.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: value == s ? Colors.white : Colors.grey.shade700,
                      ),
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

class _ApprovalCard extends GetView<CustomerApprovalController> {
  const _ApprovalCard({required this.customer});
  final ApprovalCustomer customer;

  Future<void> _open() async {
    final approved =
        await Get.to<bool>(() => CustomerApprovalForm(customer: customer));
    if (approved == true) controller.onApproved(customer.customerId);
  }

  @override
  Widget build(BuildContext context) {
    final date = customer.insertedOn;
    final types = [customer.customerType, customer.industryType]
        .where((e) => e.isNotEmpty)
        .join(' • ');
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: context.primaryColor.withValues(alpha: .06),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: _open,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: context.primaryColor,
                child: Text(
                  customer.customerName.isEmpty
                      ? '?'
                      : customer.customerName[0].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            customer.customerName.isEmpty
                                ? 'Unnamed customer'
                                : customer.customerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15.5, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ApprovalStatusChip(approved: customer.isApproved),
                      ],
                    ),
                    if (types.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(types,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade700)),
                    ],
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        if (customer.gstNo.isNotEmpty)
                          _Meta(Icons.receipt_long_rounded,
                              'GST ${customer.gstNo}'),
                        if (customer.linkedAscUserName.isNotEmpty)
                          _Meta(Icons.storefront_rounded,
                              'ASC ${customer.linkedAscUserName}'),
                        if (date != null)
                          _Meta(Icons.calendar_today_rounded,
                              DateFormat('dd MMM yyyy').format(date)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
      ],
    );
  }
}

/// Small "Pending" / "Approved" pill.
class ApprovalStatusChip extends StatelessWidget {
  const ApprovalStatusChip({super.key, required this.approved});
  final bool approved;

  @override
  Widget build(BuildContext context) {
    final color = approved ? const Color(0xFF16A34A) : const Color(0xFFF59E0B);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(approved ? Icons.verified_rounded : Icons.schedule_rounded,
              size: 13, color: color),
          const SizedBox(width: 4),
          Text(approved ? 'Approved' : 'Pending',
              style: TextStyle(
                  fontSize: 11.5, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState(
      {required this.error, required this.status, required this.searching});
  final bool error;
  final String status;
  final bool searching;

  @override
  Widget build(BuildContext context) {
    final String title;
    final String subtitle;
    final IconData icon;
    if (error) {
      icon = Icons.cloud_off_rounded;
      title = 'Could not load customers';
      subtitle = 'Pull down to try again.';
    } else if (searching) {
      icon = Icons.search_off_rounded;
      title = 'No matching customers';
      subtitle = 'Try a different name, GST or ASC.';
    } else {
      icon = status == 'Pending'
          ? Icons.task_alt_rounded
          : Icons.people_outline_rounded;
      title = status == 'Pending'
          ? 'No customers waiting for approval'
          : 'No customers found';
      subtitle = 'Pull down to refresh.';
    }
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
