import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/shimmer_loaders.dart';

/// In-app PDF viewer (native rendering, pinch to zoom) for a downloaded file.
class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen(
      {super.key, required this.title, required this.filePath});
  final String title;
  final String filePath;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late final PdfControllerPinch _controller =
      PdfControllerPinch(document: PdfDocument.openFile(widget.filePath));
  int _page = 1;
  int _pages = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E7EB),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_pages > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text('$_page / $_pages',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
      body: PdfViewPinch(
        controller: _controller,
        onDocumentLoaded: (doc) => setState(() => _pages = doc.pagesCount),
        onPageChanged: (page) => setState(() => _page = page),
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) => const ShimmerPage(),
          pageLoaderBuilder: (_) => const ShimmerPage(),
          errorBuilder: (_, error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Unable to open PDF\n$error',
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}
