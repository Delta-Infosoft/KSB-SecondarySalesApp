import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/constants/api_url.dart';

/// Calls the same Dashboard APIs the web dashboard uses.
/// Each method returns the `data` field of a successful response, or null.
class AnalyticsRepository {
  static Future<dynamic> _post(String url, Object? body) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) return null;
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['isSuccessful'] == 200) {
        return decoded['data'];
      }
      return null;
    } catch (e) {
      debugPrint('Dashboard API error ($url): $e');
      return null;
    }
  }

  static Future<dynamic> getAllZones() => _post(ApiUrl.getAllZone, '');

  static Future<dynamic> getAllBranches() =>
      _post(ApiUrl.getAllBranch, {'zoneId': ''});

  static Future<dynamic> getUsers({String? userId}) =>
      _post(ApiUrl.getUserByID, {'userId': userId, 'zone': '', 'branch': ''});

  static Future<dynamic> getTotalPumpIssued(Map<String, dynamic> body) =>
      _post(ApiUrl.dashTotalPumpIssued, body);

  static Future<dynamic> getTotalPumpsLinked(Map<String, dynamic> body) =>
      _post(ApiUrl.dashTotalPumpsLinked, body);

  static Future<dynamic> getTop10Customers(Map<String, dynamic> body) =>
      _post(ApiUrl.dashTop10Customers, body);

  static Future<dynamic> getTop10Products(Map<String, dynamic> body) =>
      _post(ApiUrl.dashTop10Products, body);

  static Future<dynamic> getPumpLinkedOverTime(Map<String, dynamic> body) =>
      _post(ApiUrl.dashPumpLinkedOverTime, body);

  static Future<dynamic> getZoneWiseData(Map<String, dynamic> body) =>
      _post(ApiUrl.dashZoneWiseData, body);

  static Future<dynamic> getBranchWiseData(Map<String, dynamic> body) =>
      _post(ApiUrl.dashBranchWiseData, body);
}
