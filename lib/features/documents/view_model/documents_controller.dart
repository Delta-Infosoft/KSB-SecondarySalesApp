import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/common_services/local_db.dart';
import '../../../core/utils/constants/app_constants.dart';
import '../model/documents_repository.dart';
import '../model/policy_document.dart';
import '../view/pdf_viewer_screen.dart';

class DocumentsController extends GetxController {
  final isLoading = true.obs;
  final hasError = false.obs;
  final documents = <PolicyDocument>[].obs;
  final query = ''.obs;

  /// policyId -> download progress (0..1). Present while a file is being fetched.
  final downloading = <String, double>{}.obs;

  List<PolicyDocument> get filtered {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return documents;
    return documents
        .where((d) => [d.title, d.fileName, d.remarks, d.fileType]
            .any((v) => v.toLowerCase().contains(q)))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    hasError.value = false;
    final result = await DocumentsRepository.getDocumentsForUser(
        LocalDb.getString(AppConstants.userIdKey));
    if (result == null) {
      hasError.value = true;
      documents.clear();
    } else {
      result.sort((a, b) =>
          (b.insertedOn ?? DateTime(0)).compareTo(a.insertedOn ?? DateTime(0)));
      documents.assignAll(result);
    }
    isLoading.value = false;
  }

  /// Downloads the file from its full http URL (built from `filePath`) into the
  /// app cache. Falls back to the Policy/Download endpoint if the direct URL fails.
  Future<File> _fetch(PolicyDocument doc) async {
    final dir = await getTemporaryDirectory();
    final ext = doc.extension.isNotEmpty ? '.${doc.extension}' : '';
    final safeName = doc.policyId.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '');
    final file = File('${dir.path}/policy_$safeName$ext');
    if (await file.exists() && await file.length() > 0) return file;

    void progress(int received, int total) {
      if (total > 0) downloading[doc.policyId] = received / total;
    }

    try {
      await Dio().download(doc.fileUrl, file.path, onReceiveProgress: progress);
    } on DioException catch (e) {
      debugPrint('Direct file URL failed (${doc.fileUrl}): $e');
      await Dio()
          .download(doc.downloadUrl, file.path, onReceiveProgress: progress);
    }
    return file;
  }

  /// PDFs open in the in-app viewer; Excel / Word / PPT / video open in the
  /// device app for that type (they can't be rendered inside Flutter).
  Future<void> openDocument(PolicyDocument doc) async {
    if (downloading.containsKey(doc.policyId)) return;
    downloading[doc.policyId] = 0;
    try {
      final file = await _fetch(doc);
      downloading.remove(doc.policyId);

      if (doc.isPdf) {
        Get.to(() =>
            PdfViewerScreen(title: doc.displayTitle, filePath: file.path));
        return;
      }

      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) {
        Fluttertoast.showToast(
            msg: result.type == ResultType.noAppToOpen
                ? 'No app found to open this ${doc.fileType} file'
                : 'Unable to open file: ${result.message}');
      }
    } on DioException catch (e) {
      debugPrint('Document download error: $e');
      Fluttertoast.showToast(
          msg: e.response?.statusCode == 404
              ? 'File not found on server'
              : 'Unable to download file. Please try again.');
    } catch (e) {
      debugPrint('Document open error: $e');
      Fluttertoast.showToast(msg: 'Unable to open file. Please try again.');
    } finally {
      downloading.remove(doc.policyId);
    }
  }

  /// Opens the Download endpoint in the browser so the file is saved to the device.
  Future<void> downloadDocument(PolicyDocument doc) async {
    final ok = await launchUrl(Uri.parse(doc.downloadUrl),
        mode: LaunchMode.externalApplication);
    if (!ok) Fluttertoast.showToast(msg: 'Unable to start download');
  }
}
