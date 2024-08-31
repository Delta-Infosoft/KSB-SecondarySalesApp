import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/config/app_route.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/common_text_input.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/tap_to_remove_keyboard_widget.dart';
import 'package:ksb_secondary_sales/features/sales/view/widgets/product_card.dart';
import 'package:ksb_secondary_sales/features/sales/view/widgets/product_filter_bottomsheet.dart';
import 'package:ksb_secondary_sales/features/sales/view_model/sales_insert_controller.dart';

import '../../../core/utils/constants/app_assets.dart';

class ProductSelection extends StatefulWidget {
  const ProductSelection({super.key});

  @override
  State<ProductSelection> createState() => _ProductSelectionState();
}

class _ProductSelectionState extends State<ProductSelection> {
  late SalesInsertController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SalesInsertController());
  }

  @override
  void dispose() {
    Get.delete<SalesInsertController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TapToRemoveKeyboardWidget(
      child: Obx(() {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Row(
                children: [
                  const Expanded(child: Text('Select Products')),
                  SvgPicture.asset(
                    AppAssets.ksbLogo,
                    height: 30,
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: CommonTextInput(
                    filled: true,
                    focusNode: controller.searchFocus,
                    filledColor: context.primaryColor.withOpacity(.1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    customBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Colors.transparent)
                    ),
                    prefixIcon: const Icon(
                      FontAwesomeIcons.search,
                      size: 20,
                      color: Colors.grey
                    ),
                    suffixIcon: IconButton(
                        onPressed: () async {
                          Get.bottomSheet(
                            const ProductFilterBottomSheet(),
                            isScrollControlled: true,
                          );
                        },
                        icon: const Icon(
                          FontAwesomeIcons.filter,
                          size: 20,
                        )),
                    controller: controller.searchCtrl,
                    onChange: (p0) {
                      controller.onQuerySearch(p0 ?? '');
                    },
                    lableWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // const SizedBox(width: 0.0, height: 100.0),
                        Text(
                          'Search by ',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: context.primaryColor,
                          ),
                        ),
                        // const SizedBox( height: 100.0),
                        DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 15.0,
                            color: context.primaryColor,
                          ),
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: [
                              RotateAnimatedText('Material Number'),
                              RotateAnimatedText('Serial Number'),
                              RotateAnimatedText('Material Description'),
                            ],
                            onTap: () {
                              print("Tap Event");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //   Container(
                //       padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                //       margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                //
                //       width: context.screenWidth,
                //       color: context.primaryColor.withOpacity(.1),
                //
                //       child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: <Widget>[
                //       const Text(
                //         'Search',
                //         style: TextStyle(fontSize: 20.0),
                //       ),
                //       DefaultTextStyle(
                //         style: const TextStyle(
                //           fontSize: 20.0,
                //         ),
                //         child: AnimatedTextKit(
                //           animatedTexts: [
                //             RotateAnimatedText('AWESOME'),
                //             RotateAnimatedText('OPTIMISTIC'),
                //             RotateAnimatedText('DIFFERENT'),
                //           ],
                //           onTap: () {
                //             print("Tap Event");
                //           },
                //         ),
                //       ),
                //     ],
                //   )),

                Expanded(
                  child: () {
                    if (controller.isProductLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (controller.searchProducts.isEmpty) {
                      return Stack(
                        children: [
                          RefreshIndicator(
                            onRefresh: () async {
                              await controller.getProductList();
                            },
                            child: SingleChildScrollView(
                                child: SizedBox(
                              height: context.screenHeight,
                              width: context.screenWidth,
                            )),
                          ),
                          const Center(
                            child: Text('No Record Found'),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await controller.getProductList();
                            },
                            child: AnimationLimiter(
                              child: ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  itemBuilder: (context, index) {
                                    final product =
                                    controller.searchProducts[index];
                                    if(!controller.isProductListSeen && index==0){
                                      return ProductCard(product, index);
                                    }

                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                              child:
                                                  ProductCard(product, index))),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 375),
                                        child: const SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                                child: Divider())),
                                      ),
                                  itemCount: controller.searchProducts.length),
                            ),
                          ),
                        ),
                      ],
                    );
                  }(),
                )
              ],
            ),
            floatingActionButton: () {
              if (controller.isProductLoading.value ||
                  controller.searchProducts.isEmpty ||
                  !(controller.isProductSelected.any(
                    (element) => element.value,
                  ))) {
                return null;
              }
              return FloatingActionButton.extended(
                onPressed: () {
                  Get.toNamed(AppRoute.salesInsertRoute);
                },
                label: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                ),
                icon: const Text('Next'),
              );
            }());
      }),
    );
  }
}
