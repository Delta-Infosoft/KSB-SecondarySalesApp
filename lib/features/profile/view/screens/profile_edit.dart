import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../../core/utils/widgets/tap_to_remove_keyboard_widget.dart';
import '../../../auth/view_model/login_controller.dart';

class ProfileEdit extends GetView<LoginController> {
  const ProfileEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'),),
    );
  }
}
