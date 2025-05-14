import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/customers/view/widgets/customer_card.dart';
import 'package:ksb_secondary_sales/features/customers/view_model/customer_view_controller.dart';

import '../../../core/utils/constants/app_assets.dart';

class CustomerListScreen extends GetView<CustomerViewController> {

  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: const Text('Customer List')),
            SvgPicture.asset(AppAssets.ksbLogo,height: 30,),

          ],
        ),
      ),
      body: Obx(() {
        if(controller.isLoading.value){
          return const Center(child: CircularProgressIndicator(),);
        }
        else if(controller.customersList.isEmpty){
          return const Center(child: Text('No Record Found'),);
        }
        return RefreshIndicator(
          onRefresh: () async {
            await controller.getCustomerList();
          },
          child: AnimationLimiter(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) => 15.heightGap,
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              itemCount: controller.customersList.length,
              itemBuilder: (context, index) {
                final customer = controller.customersList[index];
                return AnimationConfiguration
                    .staggeredList(
                  position: index,
                  duration:
                  const Duration(milliseconds: 375),
                  child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: CustomerCard(customer: customer))),
                );
              },
            ),
          ),
        );

      },),
    );
  }

}
