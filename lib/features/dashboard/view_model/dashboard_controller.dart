import 'package:get/get.dart';
import 'package:ksb_secondary_sales/features/home/model/dummy_user_data_model.dart';

import '../view/widgets/dashboard_bottombar.dart';

class DashboardController extends GetxController {
  /// The open tab. The app opens on Dashboard; users without the dashboard
  /// right land on Home instead (see Dashboard view).
  final Rx<DashboardTab> selectedTab = DashboardTab.dashboard.obs;
  List<DummyUserDataModel> userModelsList = [];
}
