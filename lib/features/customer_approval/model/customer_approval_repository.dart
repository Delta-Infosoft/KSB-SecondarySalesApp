import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/constants/api_url.dart';
import 'customer_approval_model.dart';

/// Customer approval APIs (same ones the web "Add Edit Customer" page uses).
class CustomerApprovalRepository {
  static Future<Map<String, dynamic>?> _post(
      String url, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 45));
      if (response.statusCode != 200) {
        debugPrint('Customer approval API $url -> ${response.statusCode}');
        return null;
      }
      final decoded = jsonDecode(response.body);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } catch (e) {
      debugPrint('Customer approval API error ($url): $e');
      return null;
    }
  }

  static List<Map<String, dynamic>> _rows(Map<String, dynamic>? decoded) {
    final data = decoded?['data'];
    if (data is! List) return const [];
    return data.whereType<Map>().map(Map<String, dynamic>.from).toList();
  }

  /// [status] is `Pending`, `Approved` or `All`. Returns null on failure.
  static Future<List<ApprovalCustomer>?> getByStatus(String status,
      {String? zone}) async {
    final decoded = await _post(
        ApiUrl.getCustomerApprovalByStatus, {'status': status, 'zone': zone});
    if (decoded == null || decoded['isSuccessful'] != 200) return null;
    return _rows(decoded).map(ApprovalCustomer.fromJson).toList();
  }

  /// Latest copy of one customer, or null if it couldn't be loaded.
  static Future<ApprovalCustomer?> getById(String customerId) async {
    final decoded =
        await _post(ApiUrl.getCustomerDetailsById, {'customerId': customerId});
    if (decoded == null || decoded['isSuccessful'] != 200) return null;
    final rows = _rows(decoded);
    return rows.isEmpty ? null : ApprovalCustomer.fromJson(rows.first);
  }

  static Future<ApprovalResult> approve(Map<String, dynamic> body) async {
    final decoded = await _post(ApiUrl.updateCustomerApproval, body);
    if (decoded == null) {
      return const ApprovalResult(
          false, 'Could not reach the server. Please try again.');
    }
    final message = decoded['message']?.toString() ?? '';
    if (decoded['isSuccessful'] == 200) {
      return ApprovalResult(
          true, message.isEmpty ? 'Customer approved successfully.' : message);
    }
    return ApprovalResult(false,
        message.isEmpty ? 'Approval failed. Please try again.' : message);
  }
}
