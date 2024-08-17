import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../dashboard/view_model/dashboard_controller.dart';
import '../model/dummy_user_data_model.dart';
class HomeRepository{
  static Future<bool> insertDataToServer(DummyUserDataModel userDataModel) async {
    try {
     /* final response =  http.post((Uri.parse(ApiUrl.loginUrl)),body: {
        'id':userDataModel.uid,
        'UserName':userDataModel.name,
        'Email':userDataModel.email,
        'Mobile':userDataModel.mobileNo
      });*/
      Get.find<DashboardController>().userModelsList.add(userDataModel);
      await Future.delayed(1.seconds);
   return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Opps something went wrong $e');
      print(e.toString());
    return false;
    }
  }

  static Future<List<DummyUserDataModel>> getRecordsList() async {
    try {
      // final response =  http.post((Uri.parse(ApiUrl.loginUrl)));
      await Future.delayed(1.seconds);
      //fetch dummy data we store in the dashboard controller list
      return Get.find<DashboardController>().userModelsList;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Opps something went wrong $e');
      print(e.toString());
      return [];
    }
  }
}
