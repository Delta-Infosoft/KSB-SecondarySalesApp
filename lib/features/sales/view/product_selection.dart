import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/sales/view/widgets/product_card.dart';
import 'package:ksb_secondary_sales/features/sales/view_model/sales_insert_controller.dart';

class ProductSelection extends GetView<SalesInsertController> {
  const ProductSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Products'),
      ),
      body: Obx(
        () {
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
            onRefresh: () async{
              await controller.getProductList();
            },
            child: ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                itemBuilder: (context, index) {
                  final product = controller.products[index];
                  return ProductCard(product, index);
                },
                separatorBuilder: (context, index) => 10.heightGap,
                itemCount: controller.products.length),
          );
        },
      ),
      floatingActionButton: Obx(() {
        if (controller.isProductLoading.value || controller.products.isEmpty) {
         return const SizedBox();
        }
        return FloatingActionButton.extended(onPressed: (){},label: const Icon(Icons.arrow_forward_ios_rounded,size: 15,),icon: const Text('Next'),);
      },),
    );
  }
}
