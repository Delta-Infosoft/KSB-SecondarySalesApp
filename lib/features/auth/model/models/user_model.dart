import 'dart:convert';

import '../../../../core/utils/common_services/local_db.dart';

/// The logged-in user, as returned in `data[0]` of the Login API.
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final String mobileNo;
  final String emailId;
  final String customerName;
  final UserRoles roles;

  /// Per-screen rights from `FormRights`; null if the API didn't send them.
  final FormRights? formRights;

  UserModel({
    required this.id,
    this.firstName = '',
    this.lastName = '',
    this.userName = '',
    this.mobileNo = '',
    this.emailId = '',
    this.customerName = '',
    this.roles = const UserRoles(),
    this.formRights,
  });

  String get name => '$firstName $lastName'.trim();

  factory UserModel.fromJson(Map<String, dynamic> data) {
    String str(Object? v) => v?.toString() ?? '';
    return UserModel(
      id: str(data['UserId']),
      firstName: str(data['FirstName']),
      lastName: str(data['LastName']),
      userName: str(data['UserName']),
      mobileNo: str(data['MobileNo']),
      emailId: str(data['EmailId']),
      customerName: str(data['CustomerName']),
      roles: UserRoles.fromJson(data),
      formRights: data['FormRights'] is List
          ? FormRights.fromJson(data['FormRights'] as List)
          : null,
    );
  }
}

/// The user's role, most powerful first. A user can have several role flags
/// (e.g. Admin and ASC Coordinator); [UserRoles.primary] picks the top one.
enum UserRole {
  admin,
  businessOrHo,
  ascCoordinator,
  branchSales,
  dealerOrAsc,
  none
}

/// Role flags from the Login API (`IsAdmin`, `IsASCCoordinator`, ...).
/// Saved on login and read back anywhere with [UserRoles.load].
class UserRoles {
  final bool isAdmin;
  final bool isAscCoordinator;
  final bool isBusinessOrHo;
  final bool isBranchSales;
  final bool isDealerOrAsc;

  const UserRoles({
    this.isAdmin = false,
    this.isAscCoordinator = false,
    this.isBusinessOrHo = false,
    this.isBranchSales = false,
    this.isDealerOrAsc = false,
  });

  factory UserRoles.fromJson(Map<String, dynamic> data) => UserRoles(
        isAdmin: _toBool(data['IsAdmin']),
        isAscCoordinator: _toBool(data['IsASCCoordinator']),
        isBusinessOrHo: _toBool(data['IsBusinessOrHO']),
        isBranchSales: _toBool(data['IsBranchSales']),
        isDealerOrAsc: _toBool(data['IsDealerOrASC']),
      );

  /// Accepts true / "true" / 1 / "1" (null or anything else is false).
  static bool _toBool(Object? v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    final s = v?.toString().trim().toLowerCase();
    return s == 'true' || s == '1';
  }

  UserRole get primary {
    if (isAdmin) return UserRole.admin;
    if (isBusinessOrHo) return UserRole.businessOrHo;
    if (isAscCoordinator) return UserRole.ascCoordinator;
    if (isBranchSales) return UserRole.branchSales;
    if (isDealerOrAsc) return UserRole.dealerOrAsc;
    return UserRole.none;
  }

  // ---------------------------------------------------------------- storage
  static const _savedKey = 'roles_saved';
  static const _adminKey = 'role_isAdmin';
  static const _ascCoordinatorKey = 'role_isAscCoordinator';
  static const _businessOrHoKey = 'role_isBusinessOrHo';
  static const _branchSalesKey = 'role_isBranchSales';
  static const _dealerOrAscKey = 'role_isDealerOrAsc';

  Future<void> save() async {
    await LocalDb.setBool(_adminKey, isAdmin);
    await LocalDb.setBool(_ascCoordinatorKey, isAscCoordinator);
    await LocalDb.setBool(_businessOrHoKey, isBusinessOrHo);
    await LocalDb.setBool(_branchSalesKey, isBranchSales);
    await LocalDb.setBool(_dealerOrAscKey, isDealerOrAsc);
    await LocalDb.setBool(_savedKey, true);
  }

  /// The roles saved at the last login, or null if none were saved yet
  /// (e.g. logged in on an app version before roles were stored).
  static UserRoles? load() {
    if (!LocalDb.getBool(_savedKey)) return null;
    return UserRoles(
      isAdmin: LocalDb.getBool(_adminKey),
      isAscCoordinator: LocalDb.getBool(_ascCoordinatorKey),
      isBusinessOrHo: LocalDb.getBool(_businessOrHoKey),
      isBranchSales: LocalDb.getBool(_branchSalesKey),
      isDealerOrAsc: LocalDb.getBool(_dealerOrAscKey),
    );
  }

  /// Forget the saved roles (on logout).
  static Future<void> clear() =>
      const UserRoles().save().then((_) => LocalDb.setBool(_savedKey, false));

  @override
  String toString() => 'UserRoles(admin: $isAdmin, ascCoordinator: '
      '$isAscCoordinator, businessOrHo: $isBusinessOrHo, branchSales: '
      '$isBranchSales, dealerOrAsc: $isDealerOrAsc)';
}

/// One entry of the Login API's `FormRights` list.
class FormRight {
  final String formKey;
  final bool canView;
  final bool canAdd;
  final bool canEdit;
  final bool canDelete;

  const FormRight({
    required this.formKey,
    this.canView = false,
    this.canAdd = false,
    this.canEdit = false,
    this.canDelete = false,
  });

  factory FormRight.fromJson(Map<String, dynamic> json) => FormRight(
        formKey: json['formKey']?.toString() ?? '',
        canView: UserRoles._toBool(json['canView']),
        canAdd: UserRoles._toBool(json['canAdd']),
        canEdit: UserRoles._toBool(json['canEdit']),
        canDelete: UserRoles._toBool(json['canDelete']),
      );

  Map<String, dynamic> toJson() => {
        'formKey': formKey,
        'canView': canView,
        'canAdd': canAdd,
        'canEdit': canEdit,
        'canDelete': canDelete,
      };
}

/// The user's per-screen rights (`FormRights` from the Login API), saved at
/// login. A form that isn't in the list has no rights.
///
/// Form keys used by the app: `dashboard`, `customers`, `registerproduct`,
/// `salesentry`, `privacypolicy` (View Documents), `customersApproval`.
class FormRights {
  final Map<String, FormRight> _byKey;

  FormRights(Iterable<FormRight> rights)
      : _byKey = {for (final r in rights) r.formKey.toLowerCase(): r};

  factory FormRights.fromJson(List list) => FormRights(list
      .whereType<Map>()
      .map((e) => FormRight.fromJson(Map<String, dynamic>.from(e)))
      .where((r) => r.formKey.isNotEmpty));

  /// Rights for [formKey] (case-insensitive); all false if not listed.
  FormRight of(String formKey) =>
      _byKey[formKey.toLowerCase()] ?? FormRight(formKey: formKey);

  bool canView(String formKey) => of(formKey).canView;
  bool canAdd(String formKey) => of(formKey).canAdd;
  bool canEdit(String formKey) => of(formKey).canEdit;
  bool canDelete(String formKey) => of(formKey).canDelete;

  // ---------------------------------------------------------------- storage
  static const _key = 'form_rights';

  Future<void> save() => LocalDb.setString(
      _key, jsonEncode(_byKey.values.map((r) => r.toJson()).toList()));

  /// Rights saved at the last login, or null if none were saved (an older
  /// login, or the API didn't send FormRights).
  static FormRights? load() {
    final raw = LocalDb.getString(_key);
    if (raw.isEmpty) return null;
    try {
      final list = jsonDecode(raw);
      return list is List ? FormRights.fromJson(list) : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() => LocalDb.setString(_key, '');
}

/// What the logged-in user may open, from their saved [FormRights].
///
/// When no rights were saved (older login, or an API without FormRights),
/// everything stays available as before.
class AppRights {
  AppRights._(this._rights);

  final FormRights? _rights;

  static AppRights current() => AppRights._(FormRights.load());

  bool _view(String key) => _rights?.canView(key) ?? true;
  bool _add(String key) => _rights?.canAdd(key) ?? true;
  bool _edit(String key) => _rights?.canEdit(key) ?? true;

  /// Dashboard tab in the bottom bar.
  bool get dashboard => _view('dashboard');

  /// "Register my customer".
  bool get addCustomer => _add('customers');

  /// "View my customer".
  bool get viewCustomers => _view('customers');

  /// "Register my product".
  bool get registerProduct => _view('registerproduct');

  /// "Search & Register" (new sales entry).
  bool get addSalesEntry => _add('salesentry');

  /// "View my products" (sales entries).
  bool get viewSalesEntries => _view('salesentry');

  /// "View Documents" (web: Privacy Policy).
  bool get viewDocuments => _view('privacypolicy');

  /// "Customer Approval" list.
  bool get viewCustomerApproval => _view('customersApproval');

  /// Approve button on the customer approval form.
  bool get approveCustomer => _edit('customersApproval');
}
