import '../../../core/utils/constants/api_url.dart';

class PolicyDocument {
  final String policyId;
  final String title;
  final String fileName;
  final String filePath;
  final String fileType; // image | video | pdf | excel | ppt | word | ...
  final String remarks;
  final DateTime? insertedOn;
  final bool forAdmin;
  final bool forBusinessHO;
  final bool forASCCoordinator;
  final bool forBranchSales;
  final bool forDealerASC;

  PolicyDocument({
    required this.policyId,
    required this.title,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.remarks,
    required this.insertedOn,
    required this.forAdmin,
    required this.forBusinessHO,
    required this.forASCCoordinator,
    required this.forBranchSales,
    required this.forDealerASC,
  });

  factory PolicyDocument.fromJson(Map<String, dynamic> json) => PolicyDocument(
        policyId: json['policyId']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        fileName: json['fileName']?.toString() ?? '',
        filePath: json['filePath']?.toString() ?? '',
        fileType: (json['fileType']?.toString() ?? '').toLowerCase(),
        remarks: json['remarks']?.toString() ?? '',
        insertedOn: DateTime.tryParse(json['insertedOn']?.toString() ?? ''),
        forAdmin: json['forAdmin'] == true,
        forBusinessHO: json['forBusinessHO'] == true,
        forASCCoordinator: json['forASCCoordinator'] == true,
        forBranchSales: json['forBranchSales'] == true,
        forDealerASC: json['forDealerASC'] == true,
      );

  String get displayTitle => title.isNotEmpty ? title : fileName;

  /// Direct file URL (used for viewing images, videos and PDFs, like the web).
  String get fileUrl => ApiUrl.policyFile(filePath);

  /// Download endpoint (used for Excel / Word / PPT, like the web).
  String get downloadUrl => ApiUrl.policyDownload(policyId);

  bool get isImage =>
      fileType == 'image' ||
      const ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp']
          .contains(extension.toLowerCase());

  bool get isPdf => fileType == 'pdf' || extension.toLowerCase() == 'pdf';

  String get extension {
    final dot = fileName.lastIndexOf('.');
    if (dot != -1 && dot < fileName.length - 1)
      return fileName.substring(dot + 1);
    final pDot = filePath.lastIndexOf('.');
    return pDot != -1 ? filePath.substring(pDot + 1) : '';
  }

  String get rolesText => [
        if (forAdmin) 'Admin',
        if (forBusinessHO) 'Business/HO',
        if (forASCCoordinator) 'ASC Coordinator',
        if (forBranchSales) 'Branch Sales',
        if (forDealerASC) 'Dealer/ASC',
      ].join(', ');
}
