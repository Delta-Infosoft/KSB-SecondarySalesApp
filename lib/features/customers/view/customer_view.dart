import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/customers/view/widgets/customer_card.dart';
import 'package:ksb_secondary_sales/features/customers/view_model/customer_view_controller.dart';

class CustomerListScreen extends GetView<CustomerViewController> {

  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
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
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => 15.heightGap,
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
            itemCount: controller.customersList.length,
            itemBuilder: (context, index) {
              final customer = controller.customersList[index];
              return CustomerCard(customer: customer);
            },
          ),
        );

      },),
    );
  }

}
