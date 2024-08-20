import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/config/app_route.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/sales/view/widgets/product_card.dart';
import 'package:ksb_secondary_sales/features/sales/view_model/sales_insert_controller.dart';

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
    controller= Get.put(SalesInsertController());
  }
  @override
  void dispose() {
    Get.delete<SalesInsertController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
    () {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Select Products'),
          ),
          body:  () {
            if (controller.isProductLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (controller.products.isEmpty) {
              return const Center(
                child: Text('No Record Found'),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                await controller.getProductList();
              },
              child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return ProductCard(product, index);
                  },
                  separatorBuilder: (context, index) => 15.heightGap,
                  itemCount: controller.products.length),
            );
          }(),
          floatingActionButton: () {
            if (controller.isProductLoading.value ||
                controller.products.isEmpty ||
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
          }()
        );
      }
    );
  }
}
