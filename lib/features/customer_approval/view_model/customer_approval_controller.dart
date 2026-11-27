import 'package:get/get.dart';

import '../model/customer_approval_model.dart';
import '../model/customer_approval_repository.dart';

/// List of customers by approval status (Pending / Approved / All).
class CustomerApprovalController extends GetxController {
  static const statuses = ['Pending', 'Approved', 'All'];

  final status = 'Pending'.obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final customers = <ApprovalCustomer>[].obs;
  final query = ''.obs;

  /// Customers matching the search (name, GST, linked ASC, types).
  List<ApprovalCustomer> get filtered {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return customers;
    return customers
        .where((c) => [
              c.customerName,
              c.gstNo,
              c.linkedAscUserName,
              c.customerType,
              c.industryType,
              c.c4cId,
            ].any((v) => v.toLowerCase().contains(q)))
        .toList();
  }

  int _request = 0;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void changeStatus(String value) {
    if (status.value == value) return;
    status.value = value;
    load();
  }

  Future<void> load() async {
    // Ignore a slow response from a status the user already switched away from.
    final request = ++_request;
    isLoading.value = true;
    hasError.value = false;
    final result = await CustomerApprovalRepository.getByStatus(status.value);
    if (request != _request) return;
    if (result == null) {
      hasError.value = true;
      customers.clear();
    } else {
      result.sort((a, b) =>
          (b.insertedOn ?? DateTime(0)).compareTo(a.insertedOn ?? DateTime(0)));
      customers.assignAll(result);
    }
    isLoading.value = false;
  }

  /// Called after a customer was approved on the form screen.
  void onApproved(String customerId) => load();
}
