import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/app_date_time_controller.dart';

class InitialBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AppDateTimeController(),);
  }
}