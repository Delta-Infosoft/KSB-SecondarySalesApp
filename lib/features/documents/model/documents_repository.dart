import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/constants/api_url.dart';
import 'policy_document.dart';

class DocumentsRepository {
  /// View-only, rights based: Policy/GetForUser returns only the documents
  /// whose "Show this document to" roles (set on the web when the document is
  /// added) match the logged-in user's role. Admins get every document.
  static Future<List<PolicyDocument>?> getDocumentsForUser(
      String userId) async {
    if (userId.isEmpty) return [];
    try {
      final response = await http
          .post(
            Uri.parse(ApiUrl.policyGetForUser),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'userId': userId}),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) return null;
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['isSuccessful'] == 200) {
        final list = decoded['data'];
        if (list is! List) return [];
        return list
            .whereType<Map>()
            .map((e) => PolicyDocument.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return null;
    } catch (e) {
      debugPrint('Policy documents error: $e');
      return null;
    }
  }
}
