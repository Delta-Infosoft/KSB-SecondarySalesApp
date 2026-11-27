int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

String _toStr(dynamic v) => v?.toString() ?? '';

/// Generic option used by the filter pickers. An empty [value] means "All".
class FilterOption {
  final String value;
  final String label;
  const FilterOption(this.value, this.label);
}

class ZoneItem {
  final String id;
  final String name;
  ZoneItem({required this.id, required this.name});

  factory ZoneItem.fromJson(Map<String, dynamic> json) =>
      ZoneItem(id: _toStr(json['Id']), name: _toStr(json['Name']));
}

class BranchItem {
  /// Web dashboard uses DPBranchId as the branch filter value.
  final String dpBranchId;
  final String name;
  final String zoneId;
  BranchItem(
      {required this.dpBranchId, required this.name, required this.zoneId});

  factory BranchItem.fromJson(Map<String, dynamic> json) => BranchItem(
        dpBranchId: _toStr(json['DPBranchId']),
        name: _toStr(json['Name']),
        zoneId: _toStr(json['ZoneId']),
      );
}

class DashboardUser {
  final String userId;
  final String displayName;
  final String zone;
  final String branch;
  DashboardUser({
    required this.userId,
    required this.displayName,
    required this.zone,
    required this.branch,
  });

  /// Only the fields the dashboard needs are kept.
  factory DashboardUser.fromJson(Map<String, dynamic> json) {
    final name = '${json['FirstName'] ?? ''} ${json['LastName'] ?? ''}'.trim();
    return DashboardUser(
      userId: _toStr(json['UserId']),
      displayName: '$name (${json['UserName'] ?? ''})',
      zone: _toStr(json['Zone']),
      branch: _toStr(json['Branch']),
    );
  }
}

class LabelValue {
  final String label;
  final int value;
  LabelValue(this.label, this.value);
}

class ProductStat {
  final String name;
  final int issued;
  final int linked;
  ProductStat({required this.name, required this.issued, required this.linked});

  factory ProductStat.fromJson(Map<String, dynamic> json) => ProductStat(
        name: _toStr(json['ProductName']),
        issued: _toInt(json['ProductIssued']),
        linked: _toInt(json['ProductLinked']),
      );
}

class TimePoint {
  final String date;
  int issued;
  int linked;
  TimePoint({required this.date, this.issued = 0, this.linked = 0});
}

class AscBranchRow {
  final String branch;
  final String name;
  final int linked;
  AscBranchRow(
      {required this.branch, required this.name, required this.linked});

  factory AscBranchRow.fromJson(Map<String, dynamic> json) => AscBranchRow(
        branch: _toStr(json['BranchName']),
        name: _toStr(json['Name']),
        linked: _toInt(json['Linked']),
      );
}

class ProductBranchRow {
  final String product;
  final String branch;
  final int issued;
  final int linked;
  ProductBranchRow(
      {required this.product,
      required this.branch,
      required this.issued,
      required this.linked});

  factory ProductBranchRow.fromJson(Map<String, dynamic> json) =>
      ProductBranchRow(
        product: _toStr(json['ProductName']),
        branch: _toStr(json['BranchName']),
        issued: _toInt(json['ProductIssued']),
        linked: _toInt(json['ProductLinked']),
      );
}

int parseInt(dynamic v) => _toInt(v);
String parseStr(dynamic v) => _toStr(v);
