import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/features/auth/view_model/login_controller.dart';

import '../../../../core/config/app_route.dart';
import '../../../../core/utils/common_services/local_db.dart';
import '../../../../core/utils/constants/app_constants.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hi there...',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 18),),
            Text('Are you sure to logout this user ?',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600,color: context.primaryColor),),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              TextButton(onPressed: (){
                Get.back();
              }, child: const Text('Cancel')),
              ElevatedButton(onPressed: (){
                LocalDb.setBool(AppConstants.isLoggedInKey,false);
                LocalDb.setBool(AppConstants.isProductListSeenKey,false);
                LocalDb.setString(AppConstants.userIdKey,'');
                Get.delete<LoginController>();
                Get.offAllNamed(AppRoute.login);
              }, child: const Text('Confirm')),
            ],)
          ],
        ),
      ),
    );
  }
}
