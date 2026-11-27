import 'package:get/get.dart';

import '../../../core/utils/common_services/local_db.dart';
import '../../../core/utils/constants/app_constants.dart';
import '../../auth/model/models/user_model.dart';
import '../model/analytics_models.dart';
import '../model/dashboard_access.dart';
import '../model/analytics_repository.dart';

/// Mirrors the web dashboard (galaxy.ierp.in:58/#/dashboard/default):
/// same filters, same API payloads, same derived numbers.
class AnalyticsController extends GetxController {
  // ---------------- Role ----------------
  /// Role flags saved at login (null for a login from an older app version).
  final UserRoles? roles = UserRoles.load();

  /// Which cards and filters this user's role may see.
  final DashboardAccess access = DashboardAccess.current();

  // ---------------- Filters ----------------
  final zones = <ZoneItem>[].obs;
  final allBranches = <BranchItem>[].obs;
  final allUsers = <DashboardUser>[].obs;

  final selectedZone = ''.obs;
  final selectedBranch = ''.obs;
  final selectedUserId = ''.obs;
  final fromDate = Rxn<DateTime>();
  final toDate = Rxn<DateTime>();
  final periodType = 'DAY'.obs;

  // ---------------- State ----------------
  final isLoading = false.obs;
  final isTimelineLoading = false.obs;

  // Overall % linking
  final totalIssued = 0.obs;
  final linkedOfIssued = 0.obs;

  // Charts
  final topCustomers = <LabelValue>[].obs;
  final topProducts = <ProductStat>[].obs;
  final timeline = <TimePoint>[].obs;

  // Zonal
  final zoneLinking = <LabelValue>[].obs;
  final ascZoneLinking = <LabelValue>[].obs;
  final productZoneLinking = <LabelValue>[].obs;

  // Branch
  final ascBranchRows = <AscBranchRow>[].obs;
  final productBranchRows = <ProductBranchRow>[].obs;

  // ---------------- Derived ----------------
  int get totalLinked =>
      linkedOfIssued.value.clamp(0, totalIssued.value).toInt();
  int get totalPending =>
      (totalIssued.value - totalLinked).clamp(0, totalIssued.value).toInt();
  double get linkedPercent => totalIssued.value == 0
      ? 0
      : (totalLinked / totalIssued.value * 100).clamp(0, 100).toDouble();

  List<FilterOption> get zoneOptions => [
        const FilterOption('', 'All Zones'),
        ...zones.map((z) => FilterOption(z.id, z.name)),
      ];

  List<FilterOption> get branchOptions {
    final list = selectedZone.value.isEmpty
        ? allBranches
        : allBranches.where((b) => b.zoneId == selectedZone.value);
    return [
      const FilterOption('', 'All Branches'),
      ...list.map((b) => FilterOption(b.dpBranchId, b.name)),
    ];
  }

  List<FilterOption> get userOptions {
    Iterable<DashboardUser> list = allUsers;
    if (selectedBranch.value.isNotEmpty) {
      list = list.where((u) => u.branch == selectedBranch.value);
    } else if (selectedZone.value.isNotEmpty) {
      list = list.where((u) => u.zone == selectedZone.value);
    }
    return [
      const FilterOption('', 'All Users'),
      ...list.map((u) => FilterOption(u.userId, u.displayName)),
    ];
  }

  String labelFor(List<FilterOption> options, String value) =>
      options.firstWhereOrNull((o) => o.value == value)?.label ??
      (value.isEmpty ? options.first.label : value);

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    isLoading.value = true;
    await Future.wait([
      _loadCurrentUserDefaults(),
      _loadZones(),
      _loadBranches(),
      _loadUsers(),
    ]);
    await loadAll();
  }

  /// Like the web, default the filters to the logged-in user's zone/branch/user.
  Future<void> _loadCurrentUserDefaults() async {
    final userId = LocalDb.getString(AppConstants.userIdKey);
    if (userId.isEmpty) return;
    final data = await AnalyticsRepository.getUsers(userId: userId);
    if (data is List && data.isNotEmpty && data.first is Map) {
      final me = DashboardUser.fromJson(Map<String, dynamic>.from(data.first));
      selectedZone.value = me.zone;
      selectedBranch.value = me.branch;
      selectedUserId.value = me.userId;
    }
  }

  Future<void> _loadZones() async {
    final data = await AnalyticsRepository.getAllZones();
    if (data is List) {
      zones.assignAll(data
          .whereType<Map>()
          .map((e) => ZoneItem.fromJson(Map<String, dynamic>.from(e))));
    }
  }

  Future<void> _loadBranches() async {
    final data = await AnalyticsRepository.getAllBranches();
    if (data is List) {
      allBranches.assignAll(data
          .whereType<Map>()
          .map((e) => BranchItem.fromJson(Map<String, dynamic>.from(e))));
    }
  }

  Future<void> _loadUsers() async {
    final data = await AnalyticsRepository.getUsers();
    if (data is List) {
      allUsers.assignAll(data
          .whereType<Map>()
          .map((e) => DashboardUser.fromJson(Map<String, dynamic>.from(e))));
    }
  }

  // ---------------- Filter handlers ----------------
  void onZoneChange(String value) {
    if (!access.filters) return;
    selectedZone.value = value;
    selectedBranch.value = '';
    selectedUserId.value = '';
  }

  void onBranchChange(String value) {
    if (!access.filters) return;
    selectedBranch.value = value;
    selectedUserId.value = '';
  }

  void onUserChange(String value) {
    if (!access.filters) return;
    selectedUserId.value = value;
  }

  void switchPeriod(String type) {
    if (periodType.value == type) return;
    periodType.value = type;
    _loadPumpLinkedOverTime();
  }

  Future<void> onFilter() => loadAll();

  // ---------------- Data loading ----------------
  String? _fmt(DateTime? d) => d == null
      ? null
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String? _orNull(String v) => v.isEmpty ? null : v;

  Future<void> loadAll() async {
    isLoading.value = true;
    // Only call the APIs for the sections this role can see.
    await Future.wait([
      if (access.summary) ...[
        _loadTotalPumpIssued(),
        _loadTopCustomers(),
        _loadTopProducts(),
        _loadPumpLinkedOverTime(),
      ],
      if (access.zonal) _loadZoneWiseData(),
      if (access.branch) _loadBranchWiseData(),
    ]);
    isLoading.value = false;
  }

  Future<void> _loadTotalPumpIssued() async {
    final data = await AnalyticsRepository.getTotalPumpIssued({
      'fromDate': _fmt(fromDate.value),
      'toDate': _fmt(toDate.value),
    });
    if (data is Map) {
      totalIssued.value = parseInt(data['totalPumpIssued']);
      linkedOfIssued.value = parseInt(data['totalLinkedOfIssued']);
    } else {
      totalIssued.value = 0;
      linkedOfIssued.value = 0;
    }
  }

  Map<String, dynamic> get _nullableFilterBody => {
        'fromDate': _fmt(fromDate.value),
        'toDate': _fmt(toDate.value),
        'zone': _orNull(selectedZone.value),
        'branch': _orNull(selectedBranch.value),
        'userId': _orNull(selectedUserId.value),
      };

  Future<void> _loadTopCustomers() async {
    final data =
        await AnalyticsRepository.getTop10Customers(_nullableFilterBody);
    topCustomers.assignAll(data is List
        ? data.whereType<Map>().map((e) => LabelValue(
            parseStr(e['CustomerName']), parseInt(e['TotalInvoices'])))
        : const <LabelValue>[]);
  }

  Future<void> _loadTopProducts() async {
    final data =
        await AnalyticsRepository.getTop10Products(_nullableFilterBody);
    topProducts.assignAll(data is List
        ? data
            .whereType<Map>()
            .map((e) => ProductStat.fromJson(Map<String, dynamic>.from(e)))
        : const <ProductStat>[]);
  }

  Future<void> _loadPumpLinkedOverTime() async {
    isTimelineLoading.value = true;
    final data = await AnalyticsRepository.getPumpLinkedOverTime({
      'fromDate': _fmt(fromDate.value),
      'toDate': _fmt(toDate.value),
      'periodType': periodType.value,
      'userId': _orNull(selectedUserId.value),
      'zone': selectedZone.value,
      'branch': selectedBranch.value,
    });
    final map = <String, TimePoint>{};
    if (data is Map) {
      for (final e in (data['issued'] as List? ?? const []).whereType<Map>()) {
        final d = parseStr(e['Date']).split('T').first;
        map[d] = TimePoint(date: d, issued: parseInt(e['TotalPumpIssued']));
      }
      for (final e in (data['linked'] as List? ?? const []).whereType<Map>()) {
        final d = parseStr(e['Date']).split('T').first;
        map.putIfAbsent(d, () => TimePoint(date: d)).linked =
            parseInt(e['TotalPumpsLinked']);
      }
    }
    // Latest 10 periods, oldest first (same as web).
    final points = map.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    timeline.assignAll(points.take(10).toList().reversed);
    isTimelineLoading.value = false;
  }

  List<LabelValue> _sorted(Iterable<LabelValue> list) =>
      list.toList()..sort((a, b) => b.value.compareTo(a.value));

  Future<void> _loadZoneWiseData() async {
    final data = await AnalyticsRepository.getZoneWiseData({
      'zone': selectedZone.value,
      'fromDate': _fmt(fromDate.value),
      'toDate': _fmt(toDate.value),
    });
    if (data is! Map) {
      zoneLinking.clear();
      ascZoneLinking.clear();
      productZoneLinking.clear();
      return;
    }
    zoneLinking.assignAll(_sorted((data['ksbZoneWise'] as List? ?? const [])
        .whereType<Map>()
        .map((e) =>
            LabelValue(parseStr(e['ZoneName']), parseInt(e['Linked'])))));
    ascZoneLinking.assignAll(_sorted((data['ascZoneWise'] as List? ?? const [])
        .whereType<Map>()
        .map((e) => LabelValue(parseStr(e['Name']), parseInt(e['Linked'])))));
    productZoneLinking.assignAll(_sorted(
        (data['productSummary'] as List? ?? const []).whereType<Map>().map(
            (e) => LabelValue(
                parseStr(e['ProductName']), parseInt(e['ProductLinked'])))));
  }

  Future<void> _loadBranchWiseData() async {
    final data = await AnalyticsRepository.getBranchWiseData({
      'fromDate': _fmt(fromDate.value),
      'toDate': _fmt(toDate.value),
      'branch': selectedBranch.value,
    });
    if (data is! Map) {
      ascBranchRows.clear();
      productBranchRows.clear();
      return;
    }
    ascBranchRows.assignAll((data['ascBranchWise'] as List? ?? const [])
        .whereType<Map>()
        .map((e) => AscBranchRow.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.linked.compareTo(a.linked)));
    productBranchRows.assignAll(
        (data['productBranchSummary'] as List? ?? const [])
            .whereType<Map>()
            .map((e) => ProductBranchRow.fromJson(Map<String, dynamic>.from(e)))
            .toList()
          ..sort((a, b) => b.linked.compareTo(a.linked)));
  }

  List<LabelValue> get ascBranchLinking =>
      ascBranchRows.map((e) => LabelValue(e.name, e.linked)).toList();

  List<LabelValue> get productBranchLinking =>
      productBranchRows.map((e) => LabelValue(e.product, e.linked)).toList();
}
