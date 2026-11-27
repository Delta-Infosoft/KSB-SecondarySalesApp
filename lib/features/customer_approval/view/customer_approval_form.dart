import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/common_services/local_db.dart';
import '../../../core/utils/constants/app_constants.dart';
import '../../../core/utils/extentions/context_extention.dart';
import '../../auth/model/models/user_model.dart';
import '../model/customer_approval_model.dart';
import '../model/customer_approval_repository.dart';
import 'customer_approval_list.dart';

/// Mobile version of the web "Add Edit Customer" approval page.
///
/// The approver fills in C4C Customer ID, Installation Point Name and C4C
/// Installation Point ID, then approves. Everything else is shown read-only;
/// the customer's existing Linked ASC is sent back unchanged. Pops `true` after a successful approval.
class CustomerApprovalForm extends StatefulWidget {
  const CustomerApprovalForm({super.key, required this.customer});
  final ApprovalCustomer customer;

  @override
  State<CustomerApprovalForm> createState() => _CustomerApprovalFormState();
}

class _CustomerApprovalFormState extends State<CustomerApprovalForm> {
  late ApprovalCustomer _customer = widget.customer;
  late final _c4cId = TextEditingController(text: _customer.c4cId);
  late final _installationPoint =
      TextEditingController(text: _customer.installationPoint);
  late final _c4cIpId = TextEditingController(text: _customer.c4cIpId);
  bool _saving = false;

  /// Approving needs the `customersApproval` edit right (FormRights).
  final bool _canEditRight = AppRights.current().approveCustomer;

  bool get _readOnly => _customer.isApproved || !_canEditRight;

  bool get _canApprove =>
      !_readOnly &&
      !_saving &&
      _c4cId.text.trim().isNotEmpty &&
      _installationPoint.text.trim().isNotEmpty &&
      _c4cIpId.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    for (final c in [_c4cId, _installationPoint, _c4cIpId]) {
      c.addListener(() => setState(() {}));
    }
    _loadDetails();
  }

  @override
  void dispose() {
    _c4cId.dispose();
    _installationPoint.dispose();
    _c4cIpId.dispose();
    super.dispose();
  }

  /// Fetch the latest copy (picks up changes made on the web since the list
  /// loaded). Typed values are kept.
  Future<void> _loadDetails() async {
    final fresh =
        await CustomerApprovalRepository.getById(_customer.customerId);
    if (!mounted || fresh == null) return;
    setState(() {
      _customer = fresh;
      void fill(TextEditingController c, String v) {
        if (c.text.trim().isEmpty && v.isNotEmpty) c.text = v;
      }

      fill(_c4cId, fresh.c4cId);
      fill(_installationPoint, fresh.installationPoint);
      fill(_c4cIpId, fresh.c4cIpId);
    });
  }

  Future<void> _approve() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_canApprove) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Approve customer?'),
        content: Text(
            'Approve "${_customer.customerName}" with C4C ID ${_c4cId.text.trim()}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Approve')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);
    final result = await CustomerApprovalRepository.approve(
      _customer.approvalBody(
        c4cId: _c4cId.text.trim(),
        installationPoint: _installationPoint.text.trim(),
        c4cIpId: _c4cIpId.text.trim(),
        linkedAscUserName: _customer.linkedAscUserName,
        approvedByUserId: LocalDb.getString(AppConstants.userIdKey),
      ),
    );
    if (!mounted) return;
    setState(() => _saving = false);

    Fluttertoast.showToast(
      msg: result.message,
      backgroundColor: result.success ? Colors.green : Colors.red,
      textColor: Colors.white,
    );
    if (result.success) Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    final c = _customer;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Approve Customer')),
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _Header(customer: c),
            const SizedBox(height: 12),
            _Section(
              title: 'C4C details',
              icon: Icons.badge_outlined,
              children: [
                _ReadOnlyField(label: 'Customer Name', value: c.customerName),
                _InputField(
                  label: 'C4C Customer ID',
                  controller: _c4cId,
                  readOnly: _readOnly,
                  keyboardType: TextInputType.number,
                ),
                _InputField(
                  label: 'Installation Point Name',
                  controller: _installationPoint,
                  readOnly: _readOnly,
                  capitalization: TextCapitalization.words,
                ),
                _InputField(
                  label: 'C4C Installation Point ID',
                  controller: _c4cIpId,
                  readOnly: _readOnly,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            _Section(
              title: 'Address',
              icon: Icons.location_on_outlined,
              children: [
                _ReadOnlyField(label: 'Address', value: c.addressName),
                _Pair(
                  _ReadOnlyField(label: 'Street', value: c.street),
                  _ReadOnlyField(label: 'Postal Code', value: c.pincode),
                ),
                _Pair(
                  _ReadOnlyField(label: 'City', value: c.city),
                  _ReadOnlyField(label: 'District', value: c.district),
                ),
                _Pair(
                  _ReadOnlyField(label: 'State', value: c.state),
                  _ReadOnlyField(label: 'Country', value: c.country),
                ),
                _ReadOnlyField(label: 'Point Status', value: c.pointStatus),
              ],
            ),
            _Section(
              title: 'Business',
              icon: Icons.business_center_outlined,
              children: [
                _Pair(
                  _ReadOnlyField(label: 'Customer Type', value: c.customerType),
                  _ReadOnlyField(label: 'Company Type', value: c.companyType),
                ),
                _Pair(
                  _ReadOnlyField(label: 'Industry Type', value: c.industryType),
                  _ReadOnlyField(label: 'GST No.', value: c.gstNo),
                ),
              ],
            ),
            _Section(
              title: 'Contacts',
              icon: Icons.contact_phone_outlined,
              children: c.contacts.isEmpty
                  ? [
                      Text('No contacts added',
                          style: TextStyle(color: Colors.grey.shade600))
                    ]
                  : [for (final p in c.contacts) _ContactTile(contact: p)],
            ),
          ],
        ),
        bottomNavigationBar: _BottomBar(
          approved: c.isApproved,
          viewOnly: !c.isApproved && !_canEditRight,
          approvedOn: c.approvedOn,
          saving: _saving,
          canApprove: _canApprove,
          onCancel: () => Get.back(),
          onApprove: _approve,
        ),
      ),
    );
  }
}

// --------------------------------------------------------------- widgets

class _Header extends StatelessWidget {
  const _Header({required this.customer});
  final ApprovalCustomer customer;

  @override
  Widget build(BuildContext context) {
    final date = customer.insertedOn;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: context.primaryColor,
            child: const Icon(Icons.person_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.customerName,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(
                  [
                    if (customer.insertedBy.isNotEmpty)
                      'Added by ${customer.insertedBy}',
                    if (date != null) DateFormat('dd MMM yyyy').format(date),
                  ].join(' • '),
                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          ApprovalStatusChip(approved: customer.isApproved),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(
      {required this.title, required this.icon, required this.children});
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: context.primaryColor),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          for (final child in children)
            Padding(padding: const EdgeInsets.only(bottom: 12), child: child),
        ],
      ),
    );
  }
}

class _Pair extends StatelessWidget {
  const _Pair(this.left, this.right);
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 10),
        Expanded(child: right),
      ],
    );
  }
}

InputDecoration _decoration(BuildContext context, String label,
        {bool required = false, bool enabled = true, Widget? suffix}) =>
    InputDecoration(
      label: Text.rich(TextSpan(children: [
        if (required)
          const TextSpan(text: '* ', style: TextStyle(color: Colors.red)),
        TextSpan(text: label),
      ])),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      isDense: true,
      filled: true,
      fillColor: enabled ? Colors.white : Colors.grey.shade100,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: context.primaryColor, width: 1.5),
      ),
    );

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: _decoration(context, label, enabled: false),
      child: Text(
        value.isEmpty ? '—' : value,
        style: TextStyle(
            fontSize: 14.5,
            color: value.isEmpty ? Colors.grey.shade500 : Colors.black87),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.controller,
    required this.readOnly,
    this.keyboardType,
    this.capitalization = TextCapitalization.none,
  });
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextCapitalization capitalization;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textCapitalization: capitalization,
      textInputAction: TextInputAction.next,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration:
          _decoration(context, label, required: true, enabled: !readOnly),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact});
  final ApprovalContact contact;

  @override
  Widget build(BuildContext context) {
    Widget line(IconData icon, String text) => text.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(icon, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(text,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade800))),
              ],
            ),
          );

    final role = [contact.designation, contact.department]
        .where((e) => e.isNotEmpty)
        .join(' • ');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contact.name.isEmpty ? 'Contact' : contact.name,
              style:
                  const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
          line(Icons.work_outline_rounded, role),
          line(Icons.phone_outlined, contact.phone),
          line(Icons.email_outlined, contact.email),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.approved,
    required this.viewOnly,
    required this.approvedOn,
    required this.saving,
    required this.canApprove,
    required this.onCancel,
    required this.onApprove,
  });
  final bool approved;

  /// Pending, but the user has no right to approve.
  final bool viewOnly;
  final DateTime? approvedOn;
  final bool saving;
  final bool canApprove;
  final VoidCallback onCancel;
  final VoidCallback onApprove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, 10 + MediaQuery.paddingOf(context).bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: .06),
              blurRadius: 10,
              offset: const Offset(0, -2)),
        ],
      ),
      child: viewOnly
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility_outlined, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'View only - you don\'t have rights to approve customers',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700),
                  ),
                ),
              ],
            )
          : approved
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_rounded,
                        color: Color(0xFF16A34A)),
                    const SizedBox(width: 8),
                    Text(
                      approvedOn == null
                          ? 'This customer is approved'
                          : 'Approved on ${DateFormat('dd MMM yyyy').format(approvedOn!)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF16A34A)),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: saving ? null : onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.close_rounded),
                        label: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: canApprove ? onApprove : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.check_rounded),
                        label: Text(saving ? 'Approving…' : 'Approve'),
                      ),
                    ),
                  ],
                ),
    );
  }
}
