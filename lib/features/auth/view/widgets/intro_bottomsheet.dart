import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/auth/view_model/login_controller.dart';

import 'login_form.dart';

class OnboardContent extends StatefulWidget {
  const OnboardContent({super.key});

  @override
  State<OnboardContent> createState() => _OnboardContentState();
}

class _OnboardContentState extends State<OnboardContent> {
  late PageController _pageController;
  LoginController loginController = Get.find();
  // double _progress;
  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        _pageController.hasClients ? (_pageController.page ?? 0) : 0;

    return Obx(() {
      return SizedBox(
        height: 400 + progress * 100,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: const [
                      LandingContent(),
                      LoginForm(),
                    ],
                  ),
                ),


                8.heightGap,
              ],
            ),
            Positioned(
              height: 56,
              bottom: 30 + progress * 50,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  if (_pageController.page == 0) {
                    _pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease);
                  } else {
                    FocusScope.of(context).unfocus();
                    loginController.onSubmitPress(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2B5984), // Darker shade of primary color
                          Color(0xFF4090C2)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.centerRight,
                      )),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 92 + progress * 32,
                          child: Stack(
                            fit: StackFit.passthrough,
                            children: [
                              FadeTransition(
                                opacity: AlwaysStoppedAnimation(1 - progress),
                                child: const Text("Get Started"),
                              ),
                              FadeTransition(
                                opacity: AlwaysStoppedAnimation(progress),
                                child: const Text(
                                  "Login To App",
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (loginController.isLoading.value)
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        else
                          // if(false)
                          const Icon(
                            Icons.chevron_right,
                            size: 24,
                            color: Colors.white,
                          )
                      ],
                    ),

                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
