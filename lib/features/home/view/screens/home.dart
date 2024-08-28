import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/config/app_route.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                CommonCard(
                    onTap: () {
                      Get.to(const AddCustomer());
                    },
                    title: 'Customer Entry',
                    icon: const Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person, size: 35),
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Icon(
                              Icons.add,
                              size: 20
                            ))
                      ],
                    )),
                10.widthGap,
                CommonCard(
                    onTap: () {
                      Get.to(const ProductSelection());
                    },
                    title: 'Sales Entry',
                    icon: const Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.store, size: 35),
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Icon(
                              Icons.add,
                              size: 20,
                            )),
                      ],
                    )),
              ],
            ),
            10.heightGap,
            Row(
              children: [
                CommonCard(
                    onTap: () {
                      Get.toNamed(AppRoute.customerView);
                    },
                    title: 'Customer View',
                    icon: const Icon(
                      Icons.groups,
                      size: 35,
                    )),
                10.widthGap,
                CommonCard(
                    onTap: () {

                    },
                    title: 'Sales View',
                    icon: const Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.assignment, size: 35),
                        ),
                        if (false)
                          const Positioned(
                              top: 0,
                              right: 0,
                              child: Icon(
                                Icons.list_alt_rounded,
                                size: 20,
                              )),
                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CommonCard extends StatelessWidget {
  const CommonCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});
  final String title;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
      color: context.primaryColor.withOpacity(.1),
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          onTap.call();
        },
        child: SizedBox(
            height: context.screenHeight * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                icon,
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                )
              ],
            )),
      ),
    ));
  }
}

class Customer {
  final String customerId;
  final String customerName;
  final String gstNo;
  final String customerTypeId;
  final String companyTypeId;
  final String industryTypeId;
  final String addressName;
  final String street;
  final String landMark;
  final String pinCode;
  final String city;
  final String state;
  final String district;
  final String country;
  final List<Contact> contacts;
  final DateTime insertedOn;
  final DateTime lastUpdatedOn;
  final String insertedByUserId;
  final String lastUpdatedByUserId;

  Customer({
    required this.customerId,
    required this.customerName,
    required this.gstNo,
    required this.customerTypeId,
    required this.companyTypeId,
    required this.industryTypeId,
    required this.addressName,
    required this.street,
    required this.landMark,
    required this.pinCode,
    required this.district,
    required this.city,
    required this.state,
    required this.country,
    required this.contacts,
    required this.insertedOn,
    required this.lastUpdatedOn,
    required this.insertedByUserId,
    required this.lastUpdatedByUserId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      gstNo: json['gstNo'] ?? '',
      customerTypeId: json['customerTypeId'] ?? '',
      companyTypeId: json['companyTypeId'] ?? '',
      industryTypeId: json['industryTypeId'] ?? '',
      addressName: json['addressName'] ?? '',
      street: json['street'] ?? '',
      district: json['street'] ?? '' ?? '',
      landMark: json['landMark'] ?? '',
      pinCode: json['pincode'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      contacts: List.generate(5, (index) {
        return Contact(
          name: json['contactName${index + 1}'] ?? '',
          department: json['contactDepartment${index + 1}'] ?? '',
          designation: json['contactDesignation${index + 1}'] ?? '',
          phone: json['contactPhone${index + 1}'] ?? '',
          email: json['contactEmail${index + 1}'] ?? '',
        );
      }),
      insertedOn: DateTime.parse(json['insertedOn']),
      lastUpdatedOn: DateTime.parse(json['lastUpdatedOn']),
      insertedByUserId: json['insertedByUserId'],
      lastUpdatedByUserId: json['lastUpdatedByUserId'],
    );
  }
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
