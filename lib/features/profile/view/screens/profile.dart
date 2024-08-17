import 'package:flutter/material.dart';
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
          title: const Text('Profile'),
        ),
        body: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (controller.userModel == null) {
              return const Center(
                child: Text('No Record Found'),
              );
            }
            return Column(
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(AppAssets.personImage),
                  ),
                ),
                30.heightGap,
                ListTile(
                    onTap: () {},
                    title: const Text('User ID'),
                    subtitle: Text(controller.userModel?.id ?? ''),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded)),
                ListTile(
                    onTap: () {},
                    title: const Text('User Name'),
                    subtitle: Text(controller.userModel?.name ?? ''),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded)),
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
