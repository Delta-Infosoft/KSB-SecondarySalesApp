import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/extentions/context_extention.dart';
import '../model/policy_document.dart';
import '../view_model/documents_controller.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/app_refresh.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/shimmer_loaders.dart';

class ViewDocuments extends GetView<DocumentsController> {
  const ViewDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Documents')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => controller.query.value = v,
              decoration: InputDecoration(
                hintText: 'Search by title, file name or remarks',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                fillColor: context.primaryColor.withOpacity(.06),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const ShimmerDocumentList();
              }
              final docs = controller.filtered;
              return AppRefreshScrollView(
                onRefresh: controller.load,
                slivers: docs.isEmpty
                    ? [
                        SliverToBoxAdapter(
                          child: SizedBox(height: context.screenHeight * 0.2),
                        ),
                        SliverToBoxAdapter(
                          child: _EmptyState(
                            error: controller.hasError.value,
                            searching: controller.query.value.isNotEmpty,
                          ),
                        ),
                      ]
                    : [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          sliver: SliverList.separated(
                            itemCount: docs.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) => _DocumentCard(doc: docs[i]),
                          ),
                        ),
                      ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends GetView<DocumentsController> {
  const _DocumentCard({required this.doc});
  final PolicyDocument doc;

  @override
  Widget build(BuildContext context) {
    final style = _FileStyle.of(doc.fileType);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: context.primaryColor.withOpacity(.06),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _view(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: style.color.withOpacity(.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child:
                            FaIcon(style.icon, color: style.color, size: 22)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc.displayTitle,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(doc.fileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12.5, color: Colors.grey.shade700)),
                        if (doc.remarks.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(doc.remarks,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _Chip(
                      label: doc.fileType.isEmpty
                          ? 'file'
                          : doc.fileType.toUpperCase(),
                      color: style.color),
                  const SizedBox(width: 8),
                  if (doc.insertedOn != null)
                    Expanded(
                      child: Text(
                        DateFormat('dd MMM yyyy').format(doc.insertedOn!),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    )
                  else
                    const Spacer(),
                  Obx(() {
                    final progress = controller.downloading[doc.policyId];
                    if (progress != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            value: progress > 0 ? progress : null,
                          ),
                        ),
                      );
                    }
                    return TextButton.icon(
                      onPressed: () => _view(context),
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('View'),
                    );
                  }),
                  IconButton(
                    tooltip: 'Download',
                    onPressed: () => controller.downloadDocument(doc),
                    icon: const Icon(Icons.download_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _view(BuildContext context) {
    if (doc.isImage) {
      Get.to(() => _ImagePreview(doc: doc));
    } else {
      controller.openDocument(doc);
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.error, required this.searching});
  final bool error;
  final bool searching;

  @override
  Widget build(BuildContext context) {
    final message = error
        ? 'Unable to load documents.\nPull down to try again.'
        : searching
            ? 'No documents match your search.'
            : 'No documents available.';
    return Column(
      children: [
        Icon(error ? Icons.cloud_off_rounded : Icons.folder_open_rounded,
            size: 56, color: Colors.grey.shade400),
        const SizedBox(height: 12),
        Text(message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      ],
    );
  }
}

class _ImagePreview extends GetView<DocumentsController> {
  const _ImagePreview({required this.doc});
  final PolicyDocument doc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(doc.displayTitle),
        actions: [
          IconButton(
            tooltip: 'Download',
            onPressed: () => controller.downloadDocument(doc),
            icon: const Icon(Icons.download_rounded),
          ),
        ],
      ),
      body: InteractiveViewer(
        maxScale: 5,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: doc.fileUrl,
            placeholder: (_, __) =>
                const CircularProgressIndicator(color: Colors.white),
            errorWidget: (_, __, ___) => const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.broken_image_outlined,
                    color: Colors.white54, size: 56),
                SizedBox(height: 8),
                Text('Unable to load image',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FileStyle {
  final FaIconData icon;
  final Color color;
  const _FileStyle(this.icon, this.color);

  static _FileStyle of(String type) {
    switch (type) {
      case 'image':
        return const _FileStyle(FontAwesomeIcons.fileImage, Color(0xFF7C3AED));
      case 'video':
        return const _FileStyle(FontAwesomeIcons.fileVideo, Color(0xFFDB2777));
      case 'pdf':
        return const _FileStyle(FontAwesomeIcons.filePdf, Color(0xFFDC2626));
      case 'excel':
        return const _FileStyle(FontAwesomeIcons.fileExcel, Color(0xFF16A34A));
      case 'ppt':
        return const _FileStyle(
            FontAwesomeIcons.filePowerpoint, Color(0xFFEA580C));
      case 'word':
        return const _FileStyle(FontAwesomeIcons.fileWord, Color(0xFF2563EB));
      default:
        return const _FileStyle(FontAwesomeIcons.file, Color(0xFF6B7280));
    }
  }
}
