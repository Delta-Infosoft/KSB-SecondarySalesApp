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
import 'package:ksb_secondary_sales/core/utils/widgets/app_refresh.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/shimmer_loaders.dart';

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

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Products Invoiced to you after 1st Jan 2025 are available here, for older serial no's go to Search & Register section",
                        style: TextStyle(
                            fontSize: 14,
                            color: context.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
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
                        borderSide:
                            const BorderSide(color: Colors.transparent)),
                    prefixIcon: const FaIcon(FontAwesomeIcons.search,
                        size: 20, color: Colors.grey),
                    suffixIcon: IconButton(
                        onPressed: () async {
                          Get.bottomSheet(
                            const ProductFilterBottomSheet(),
                            isScrollControlled: true,
                          );
                        },
                        icon: const FaIcon(
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
                              RotateAnimatedText('PO Number'),
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

                Obx(() => Expanded(
                      child: () {
                        if (controller.isProductLoading.value) {
                          return const ShimmerCardList(
                              showAvatar: false,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15));
                        }
                        if (controller.searchProducts.isEmpty) {
                          return AppRefreshScrollView(
                            onRefresh: () async {
                              await controller.getProductList();
                            },
                            slivers: const [
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(child: Text('No Record Found')),
                              ),
                            ],
                          );
                        }

                        return AnimationLimiter(
                          child: Scrollbar(
                            child: AppRefreshScrollView(
                              onRefresh: () async {
                                await controller.getProductList();
                              },
                              slivers: [
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  sliver: SliverList.separated(
                                    itemCount: controller.searchProducts.length,
                                    itemBuilder: (context, index) {
                                      final product =
                                          controller.searchProducts[index];
                                      if (!controller.isProductListSeen &&
                                          index == 0) {
                                        return ProductCard(product, index);
                                      }
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 375),
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child: ProductCard(product, index),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: const SlideAnimation(
                                        verticalOffset: 50.0,
                                        child:
                                            FadeInAnimation(child: Divider()),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }(),
                    )),

                // Expanded(
                //   child: () {
                //     if (controller.isProductLoading.value) {
                //       return const Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }
                //     if (controller.searchProducts.isEmpty) {
                //       return Stack(
                //         children: [
                //           RefreshIndicator(
                //             onRefresh: () async {
                //               await controller.getProductList();
                //             },
                //             child: SingleChildScrollView(
                //                 child: SizedBox(
                //               height: context.screenHeight,
                //               width: context.screenWidth,
                //             )),
                //           ),
                //           const Center(
                //             child: Text('No Record Found'),
                //           ),
                //         ],
                //       );
                //     }
                //     return Column(
                //       children: [
                //         Expanded(
                //           child: RefreshIndicator(
                //             onRefresh: () async {
                //               await controller.getProductList();
                //             },
                //             child: AnimationLimiter(
                //               child: Scrollbar(
                //                 child: ListView.separated(
                //                     physics:
                //                         const AlwaysScrollableScrollPhysics(),
                //                     padding: const EdgeInsets.symmetric(
                //                         horizontal: 10, vertical: 15),
                //                     itemBuilder: (context, index) {
                //                       final product =
                //                           controller.searchProducts[index];
                //                       if (!controller.isProductListSeen &&
                //                           index == 0) {
                //                         return ProductCard(product, index);
                //                       }
                //
                //                       return AnimationConfiguration
                //                           .staggeredList(
                //                         position: index,
                //                         duration:
                //                             const Duration(milliseconds: 375),
                //                         child: SlideAnimation(
                //                             verticalOffset: 50.0,
                //                             child: FadeInAnimation(
                //                                 child: ProductCard(
                //                                     product, index))),
                //                       );
                //                     },
                //                     separatorBuilder: (context, index) =>
                //                         AnimationConfiguration.staggeredList(
                //                           position: index,
                //                           duration:
                //                               const Duration(milliseconds: 375),
                //                           child: const SlideAnimation(
                //                               verticalOffset: 50.0,
                //                               child: FadeInAnimation(
                //                                   child: Divider())),
                //                         ),
                //                     itemCount:
                //                         controller.searchProducts.length),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     );
                //   }(),
                // )
              ],
            ),
            floatingActionButton: () {
              if (controller.isProductLoading.value ||
                  controller.searchProducts.isEmpty ||
                  !(controller.isProductSelected
                      .any((element) => element.value))) {
                return null;
              }

              final selectedCount = controller.isProductSelected
                  .where((element) => element.value)
                  .length;

              return FloatingActionButton.extended(
                onPressed: () {
                  Get.toNamed(AppRoute.salesInsertRoute);
                },
                label: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                ),
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Selected Serial Item',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${selectedCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }());

        //
        // floatingActionButton: () {
        //   if (controller.isProductLoading.value ||
        //       controller.searchProducts.isEmpty ||
        //       !(controller.isProductSelected
        //           .any((element) => element.value))) {
        //     return null;
        //   }
        //
        //   final selectedCount = controller.isProductSelected
        //       .where((element) => element.value)
        //       .length;
        //
        //   return FloatingActionButton.extended(
        //     onPressed: () {
        //       Get.toNamed(AppRoute.salesInsertRoute);
        //     },
        //     label: const Icon(
        //       Icons.arrow_forward_ios_rounded,
        //       size: 15,
        //     ),
        //     icon: Text('Selected Customer $selectedCount'),
        //   );
        // }());

        // floatingActionButton: () {
        //   if (controller.isProductLoading.value ||
        //       controller.searchProducts.isEmpty ||
        //       !(controller.isProductSelected.any(
        //         (element) => element.value,
        //       ))) {
        //     return null;
        //   }
        //   return FloatingActionButton.extended(
        //     onPressed: () {
        //       Get.toNamed(AppRoute.salesInsertRoute);
        //     },
        //     label: const Icon(
        //       Icons.arrow_forward_ios_rounded,
        //       size: 15,
        //     ),
        //     icon:  Text('Select Customer'),
        //   );
        // }());
      }),
    );
  }

  Widget buildProductList() {
    if (controller.isProductLoading.value) {
      return const ShimmerCardList(
          showAvatar: false,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15));
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
              ),
            ),
          ),
          const Center(child: Text('No Record Found')),
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
              child: Scrollbar(
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  itemCount: controller.searchProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.searchProducts[index];
                    if (!controller.isProductListSeen && index == 0) {
                      return ProductCard(product, index);
                    }
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: ProductCard(product, index),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: const SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: Divider()),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
