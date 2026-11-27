/// A customer waiting for (or past) approval, from
/// `Customer/GetCustomerApprovalByStatus` and `Customer/GetCustomerById`.
///
/// [raw] keeps the API record as-is, so the approve request can send back the
/// fields the web sends without this class having to name every one.
class ApprovalCustomer {
  final Map<String, dynamic> raw;

  ApprovalCustomer(this.raw);

  factory ApprovalCustomer.fromJson(Map<String, dynamic> json) =>
      ApprovalCustomer(Map<String, dynamic>.from(json));

  String _s(String key) => raw[key]?.toString().trim() ?? '';

  String get customerId => _s('CustomerId');
  String get customerName => _s('CustomerName');
  String get gstNo => _s('GSTNo');

  String get customerType => _s('CustomerType');
  String get companyType => _s('CompanyType');
  String get industryType => _s('IndustryType');
  String get customerTypeId => _s('CustomerTypeId');
  String get companyTypeId => _s('CompanyTypeId');
  String get industryTypeId => _s('IndustryTypeId');

  String get addressName => _s('AddressName');
  String get street => _s('Street');
  String get landMark => _s('LandMark');
  String get pincode => _s('Pincode');
  String get city => _s('City');
  String get district => _s('District');
  String get state => _s('State');
  String get country => _s('Country');
  String get pointStatus => _s('PointStatus');

  String get c4cId => _s('C4CId');
  String get c4cIpId => _s('C4CIPId');
  String get installationPoint => _s('InstallationPoint');

  String get linkedAscUserName => _s('LinkedAscUserName');

  String get insertedBy => _s('InsertedBy');
  DateTime? get insertedOn => DateTime.tryParse(_s('InsertedOn'));
  DateTime? get approvedOn => DateTime.tryParse(_s('ApprovedOn'));

  /// `Pending` / `Approved`. GetCustomerById doesn't send ApprovalStatus, so
  /// fall back to ApprovedOn.
  String get approvalStatus {
    final s = _s('ApprovalStatus');
    if (s.isNotEmpty) return s;
    return approvedOn != null ? 'Approved' : 'Pending';
  }

  bool get isApproved => approvalStatus.toLowerCase() == 'approved';

  /// Up to 5 contacts (ContactName1..5 etc.); empty slots are skipped.
  List<ApprovalContact> get contacts => [
        for (var i = 1; i <= 5; i++)
          if (_s('ContactName$i').isNotEmpty || _s('ContactPhone$i').isNotEmpty)
            ApprovalContact(
              name: _s('ContactName$i'),
              department: _s('ContactDepartment$i'),
              phone: _s('ContactPhone$i'),
              designation: _s('ContactDesignation$i'),
              email: _s('ContactEmail$i'),
            ),
      ];

  /// Body for `Customer/UpdateCustomerApproval`, matching what the web sends.
  Map<String, dynamic> approvalBody({
    required String c4cId,
    required String installationPoint,
    required String c4cIpId,
    required String linkedAscUserName,
    required String approvedByUserId,
  }) {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'c4cId': c4cId,
      'c4CId': c4cId,
      'installationPoint': installationPoint,
      'c4CIPId': c4cIpId,
      'customerType': customerTypeId,
      'companyType': companyTypeId,
      'industryType': industryTypeId,
      'address1': _s('AddressLine1'),
      'address2': _s('AddressLine2'),
      'address3': _s('AddressLine3'),
      'address4': _s('AddressLine4'),
      'addressName': addressName,
      'street': street,
      'houseNumber': landMark,
      'pincode': pincode,
      'city': city,
      'district': district,
      'state': state,
      'country': country,
      'pointStatus': pointStatus.isEmpty ? 'Active' : pointStatus,
      'gstNo': gstNo,
      'linkedAscUserName': linkedAscUserName,
      'insertedBy': raw['InsertedBy'],
      'lastUpdatedBy': raw['LastUpdatedBy'],
      'insertedOn': raw['InsertedOn'],
      'lastUpdatedOn': raw['LastUpdatedOn'],
      'approvedOn': raw['ApprovedOn'],
      'approvedBy': raw['ApprovedBy'] ?? ' ',
      'approvedByUserId': approvedByUserId,
    };
  }
}

class ApprovalContact {
  final String name;
  final String department;
  final String phone;
  final String designation;
  final String email;

  const ApprovalContact({
    required this.name,
    required this.department,
    required this.phone,
    required this.designation,
    required this.email,
  });
}

/// Result of the approve call.
class ApprovalResult {
  final bool success;
  final String message;
  const ApprovalResult(this.success, this.message);
}
