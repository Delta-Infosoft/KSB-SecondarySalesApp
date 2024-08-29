import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/sales/view/widgets/sales_card.dart';
import 'package:ksb_secondary_sales/features/sales/view_model/sales_view_controller.dart';

import '../../../core/utils/constants/app_assets.dart';

class SalesListView extends GetView<SalesViewController> {
  const SalesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(child: Text('Sales Data')),
            SvgPicture.asset(AppAssets.ksbLogo,height: 30,),

          ],
        ),
      ),
      body: Obx(() {
        if(controller.isLoading.value){
          return const Center(child: CircularProgressIndicator(),);
        }else if(controller.salesList.isEmpty){
          return const Center(child: Text('No Record Found'),);
        }
        return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => 15.heightGap,
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
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
