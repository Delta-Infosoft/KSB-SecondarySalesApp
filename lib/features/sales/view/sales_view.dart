import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/sales/view/widgets/sales_card.dart';
import 'package:ksb_secondary_sales/features/sales/view_model/sales_view_controller.dart';

class SalesListView extends GetView<SalesViewController> {
  const SalesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Data'),
      ),
      body: Obx(() {
        if(controller.isLoading.value){
          return const Center(child: CircularProgressIndicator(),);
        }else if(controller.salesList.isEmpty){
          return const Center(child: Text('No Record Found'),);
        }
        return ListView.separated(
            separatorBuilder: (context, index) => 10.heightGap,
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            itemCount: controller.salesList.length,
            itemBuilder: (context, index) {
              final data = controller.salesList[index];
              return SalesCard(data: data);
            }
        );

      },),
    );
  }
}
