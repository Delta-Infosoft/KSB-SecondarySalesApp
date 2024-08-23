import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/customers/view/add_customers.dart';
import 'package:ksb_secondary_sales/features/sales/view/product_selection.dart';

import '../../view_model/home_controller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KSB Sales'),
      ),
      body:  SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          children: [
            Row(children: [
               CommonCard(onTap: (){
                 Get.to(const CustomerFormScreen());
               },title: 'Customer Entry',icon: const Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.group,size: 35),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(Icons.add,size: 20,)),

                ],
              )),
              10.widthGap,
               CommonCard(onTap: (){
                 Get.to(const ProductSelection());
               },title: 'Sales Entry',icon: const Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.store,size: 35),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(Icons.add,size: 20,)),

                ],
              )),
            ],),
            10.heightGap,
            Row(children: [
               CommonCard(onTap: (){
                 Get.to()\
               },title: 'Customer View',icon: const Icon(Icons.groups,size: 35,)),
              10.widthGap,
               CommonCard(onTap: (){},title: 'Sales View',icon: const Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.list_alt_rounded,size: 35),
                  ),
if(false)
                  const Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(Icons.list_alt_rounded,size: 20,)),

                ],
              )),
            ],)
          ],
        ),
      ),
    );
  }

}


class CommonCard extends StatelessWidget {
  const CommonCard({super.key, required this.title, required this.icon, required this.onTap});
  final String title;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Card(
      color: context.primaryColor.withOpacity(.1),
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
         onTap: (){
           onTap.call();
         },

        child: SizedBox(
            height: context.screenHeight*0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
          icon,
              Text(title,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700),)
        ],)),
      ),
    ));
  }
}

