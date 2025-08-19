import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';

import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/widgets/tap_to_remove_keyboard_widget.dart';
import '../../view_model/profile_controller.dart';
import '../widgets/logout_dialog.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.getProfileDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Expanded(child: Text('Profile')),
              SvgPicture.asset(AppAssets.ksbLogo,height: 30,),
              
            ],
          ),
        ),
        body: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (controller.userData == null) {
              return const Center(
                child: Text('No Record Found'),
              );
            }
            return Column(
              children: [
                // 15.heightGap,
                // const Center(
                //   child: CircleAvatar(
                //     radius: 50,
                //     backgroundImage: NetworkImage(AppAssets.personImage),
                //   ),
                // ),
                // 30.heightGap,

                ListTile(
                    onTap: () {},
                    title: const Text('Customer Code'),
                    subtitle: Text('${controller.userData!['FirstName']+controller.userData!['LastName']}'),
                    trailing: const Icon(Icons.person)),
                ListTile(
                  onTap: () {},
                  title: Text(
                    'Registered Mobile : ${controller.userData?['MobileNo']?.toString().isNotEmpty == true ? controller.userData!['MobileNo'] : 'N/A'}',
                  ),
                ),
                ListTile(
                  onTap: () {},
                  title: Text(
                    'Customer Name: ${controller.userData?['CustomerName']?.toString().isNotEmpty == true ? controller.userData!['CustomerName'] : 'N/A'}',
                  ),
                ),

                ListTile(
                  onTap: () {},
                  title: Text(
                    'Email Id: ${controller.userData?['EmailId']?.toString().isNotEmpty == true ? controller.userData!['EmailId'] : 'N/A'}',
                  ),
                ),

                ListTile(
                    onTap: () {
                      Get.dialog(const LogoutDialog());
                    },
                    title: const Text('Log out'),
                    trailing: const Icon(Icons.logout)),
              ],
            );
          },
        ));
  }
}
