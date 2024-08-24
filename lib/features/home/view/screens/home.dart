import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/customers/view/add_customers.dart';
import 'package:ksb_secondary_sales/features/sales/view/product_selection.dart';

import '../../../customers/view/customer_view.dart';
import '../../../sales/view/sales_view.dart';
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
                 Get.to(const AddCustomer());
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
                 Get.to(CustomerListScreen(customers: dummyCustomers,));
               },title: 'Customer View',icon: const Icon(Icons.groups,size: 35,)),
              10.widthGap,
               CommonCard(onTap: (){
                 Get.to(SalesListView());
               },title: 'Sales View',icon: const Stack(
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


List<Customer> dummyCustomers = [
  Customer(
    name: 'Customer A',
    pinCode: '123456',
    area: 'Area A',
    lane: 'Lane A',
    street: 'Street A',
    landmark: 'Landmark A',
    city: 'City A',
    state: 'State A',
    district: 'District A',
    gstNo: 'GST123456789012',
    companyType: 'Company Type A',
    customerType: 'Customer Type A',
    industryType: 'Industry Type A',
    contacts: [
      Contact(
        name: 'Contact A',
        department: 'Department A',
        designation: 'Flutter Devloper',
        phone: '123-456-7890',
        email: 'mailto:contacta@example.com',
      ),   Contact(
        name: 'Contact A',
        department: 'Department A',
        designation: 'Flutter Devloper',
        phone: '123-456-7890',
        email: 'mailto:contacta@example.com',
      ),
      Contact(
        name: 'Contact B',
        department: 'Department B',
        phone: '098-765-4321',
        designation: 'Back',

        email: 'mailto:contactb@example.com',
      ),
    ],
  ),
  Customer(
    name: 'Customer B',
    pinCode: '654321',
    area: 'Area B',
    lane: 'Lane B',
    street: 'Street B',
    landmark: 'Landmark B',
    city: 'City B',
    state: 'State B',
    district: 'District B',
    gstNo: 'GST987654321098',
    companyType: 'Company Type B',
    customerType: 'Customer Type B',
    industryType: 'Industry Type B',
    contacts: [
      Contact(
        name: 'Contact B',
        department: 'Department B',
        phone: '098-765-4321',
        designation: 'Back',

        email: 'mailto:contactb@example.com',
      ),
    ],
  ),
  Customer(
    name: 'Customer C',
    pinCode: '112233',
    area: 'Area C',
    lane: 'Lane C',
    street: 'Street C',
    landmark: 'Landmark C',
    city: 'City C',
    state: 'State C',
    district: 'District C',
    gstNo: 'GST112233445566',
    companyType: 'Company Type C',
    customerType: 'Customer Type C',
    industryType: 'Industry Type C',
    contacts: [
      Contact(
        name: 'Contact C',
        department: 'Department C',designation: 'Full stack devloper',
        phone: '321-654-9870',
        email: 'mailto:contactc@example.com',
      ),
    ],
  ),
];


class Customer {
  final String name;
  final String pinCode;
  final String area;
  final String lane;
  final String street;
  final String landmark;
  final String city;
  final String state;
  final String district;
  final String gstNo;
  final String companyType;
  final String customerType;
  final String industryType;
  final List<Contact> contacts;

  Customer({
    required this.name,
    required this.pinCode,
    required this.area,
    required this.lane,
    required this.street,
    required this.landmark,
    required this.city,
    required this.state,
    required this.district,
    required this.gstNo,
    required this.companyType,
    required this.customerType,
    required this.industryType,
    required this.contacts,
  });
}

class Contact {
  final String name;
  final String department;
  final String designation;
  final String phone;
  final String email;

  Contact({
    required this.name,
    required this.department,
    required this.designation,
    required this.phone,
    required this.email,
  });
}

