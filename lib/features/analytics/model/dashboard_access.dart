import '../../auth/model/models/user_model.dart';

/// What the logged-in user may see on the analytics dashboard, decided by
/// their role from the Login API (IsAdmin, IsASCCoordinator, ...).
class DashboardAccess {
  /// Overall % linking, Top 10 Customers, Top products, Pump Linked Over Time.
  final bool summary;

  /// Top Zone, Top ASC (zone), Top Products by Linked.
  final bool zonal;

  /// Top ASC by Linking, Top ASC by Product Linking.
  final bool branch;

  /// Zone / Branch / User pickers in the filter sheet. Without them the
  /// dashboard stays on the user's own zone, branch and user (dates still
  /// work).
  final bool filters;

  const DashboardAccess({
    this.summary = true,
    this.zonal = true,
    this.branch = true,
    this.filters = true,
  });

  static const full = DashboardAccess();

  /// The access for each role. To limit a role, change its entry, e.g.
  /// `UserRole.dealerOrAsc => const DashboardAccess(zonal: false,
  /// branch: false, filters: false)`.
  static DashboardAccess forRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
      case UserRole.businessOrHo: // treated like Admin
        return full;
      case UserRole.ascCoordinator:
      case UserRole.branchSales: // treated like ASC Coordinator
        return full;
      case UserRole.dealerOrAsc:
        return full;
      case UserRole.none:
        return full;
    }
  }

  /// Access for the user saved at login. Users who logged in before roles
  /// were stored keep the full dashboard until they log in again.
  static DashboardAccess current() {
    final roles = UserRoles.load();
    return roles == null ? full : forRole(roles.primary);
  }
}
