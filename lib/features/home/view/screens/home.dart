import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/config/app_route.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_assets.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/customers/view/add_customers.dart';
import 'package:ksb_secondary_sales/features/sales/view/product_selection.dart';
import 'package:ksb_secondary_sales/features/sales/view/sales_insert.dart';

import '../../../customers/view/customer_view.dart';
import '../../../sales/view/sales_view.dart';
import '../../../sales/view_model/sales_insert_controller.dart';
import '../../view_model/home_controller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
                child: Text(
              'KSB Sanchay',
              softWrap: true,
            )),
            SvgPicture.asset(
              AppAssets.ksbLogo,
              height: 30,
            ),
          ],
        ),
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
                    title: 'Register my customer',
                    icon: const Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person, size: 35),
                        ),
                        Positioned(
                            top: 0, right: 0, child: Icon(Icons.add, size: 20))
                      ],
                    )),
                10.widthGap,
                CommonCard(
                    onTap: () {
                      Get.to(const ProductSelection());
                    },
                    title: 'Register my product',
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
                    title: 'View my customer',
                    icon: const Icon(
                      Icons.groups,
                      size: 35,
                    )),
                10.widthGap,
                CommonCard(
                    onTap: () {
                      Get.toNamed(AppRoute.salesView);
                    },
                    title: 'View my products',
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
            ),
            10.heightGap,
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 180,
                child: Row(
                  children: [
                    CommonCard(
                        onTap: () {
                          final controller = Get.put(SalesInsertController());
                          controller.enableSerialDropdown();
                          Get.to(() => const SalesInsert(), arguments: {'showSerialDropdown': true});
                        },
                        title: 'Search & Register',
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
              ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                Flexible(
                  flex: 2,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                )
              ],
            )),
      ),
    ));
  }
}

// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);


// Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));
//
// String customerToJson(Customer data) => json.encode(data.toJson());
//
// class Customer {
//   int? isSuccessful;
//   String? message;
//   List<Map<String, String?>>? data;
//
//   Customer({
//     this.isSuccessful,
//     this.message,
//     this.data,
//   });
//
//   factory Customer.fromJson(Map<String, dynamic> json) => Customer(
//     isSuccessful: json["isSuccessful"],
//     message: json["message"],
//     data: json["data"] == null ? [] : List<Map<String, String?>>.from(json["data"]!.map((x) => Map.from(x).map((k, v) => MapEntry<String, String?>(k, v)))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "isSuccessful": isSuccessful,
//     "message": message,
//     "data": data == null ? [] : List<dynamic>.from(data!.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
//   };
// }


class Customer {
  final String customerId;
  final String customerName;
  final String gstNo;
  final String addressName;
  final String street;
  final String landMark;
  final String pincode;
  final String city;
  final String state;
  final String country;
  final String district;
  final String customerType;
  final String companyType;
  final String industryType;
  final DateTime insertedOn;
  final String c4cId;
  final String approvalStatus;
  final List<Contact> contacts;

  Customer({
    required this.approvalStatus,
    required this.customerId,
    required this.customerName,
    required this.gstNo,
    required this.addressName,
    required this.street,
    required this.landMark,
    required this.pincode,
    required this.city,
    required this.state,
    required this.country,
    required this.district,
    required this.customerType,
    required this.companyType,
    required this.industryType,
    required this.insertedOn,
    required this.c4cId,
    required this.contacts,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    // Build contact list (max 5)
    List<Contact> contactList = [];
    for (int i = 1; i <= 5; i++) {
      final name = json['ContactName$i'];
      final department = json['ContactDepartment$i'];
      final designation = json['ContactDesignation$i'];
      final phone = json['ContactPhone$i'];
      final email = json['ContactEmail$i'];

      // Only add contact if name or phone exists (you can adjust this condition)
      if (name != null || phone != null) {
        contactList.add(Contact(
          name: name ?? '',
          department: department ?? '',
          designation: designation ?? '',
          phone: phone ?? '',
          email: email ?? '',
        ));
      }
    }

    return Customer(
      approvalStatus: json['C4CId'] != null && json['C4CId'].toString().isNotEmpty
          ? 'Approved'
          : 'Pending',
      customerId: json['CustomerId'] ?? '',
      customerName: json['CustomerName'] ?? 'N/A',
      gstNo: json['GSTNo'] ?? 'N/A',
      addressName: json['AddressName'] ?? 'N/A',
      street: json['Street'] ?? '',
      landMark: json['LandMark'] ?? '',
      pincode: json['Pincode'] ?? '',
      city: json['City'] ?? 'N/A',
      state: json['State'] ?? 'N/A',
      country: json['Country'] ?? 'N/A',
      district: json['District'] ?? '',
      customerType: json['CustomerType'] ?? '',
      companyType: json['CompanyType'] ?? '',
      industryType: json['IndustryType'] ?? '',
      insertedOn: DateTime.parse(json['InsertedOn']),
      c4cId: json['C4CId'] ?? '',
      contacts: contactList,
    );
  }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'CustomerId': customerId,
      'approvalStatus':approvalStatus,
      'CustomerName': customerName,
      'GSTNo': gstNo,
      'AddressName': addressName,
      'Street': street,
      'LandMark': landMark,
      'Pincode': pincode,
      'City': city,
      'State': state,
      'Country': country,
      'District': district,
      'CustomerType': customerType,
      'CompanyType': companyType,
      'IndustryType': industryType,
      'InsertedOn': insertedOn.toIso8601String(),
      'C4CId': c4cId,
    };

    for (int i = 0; i < contacts.length; i++) {
      map['ContactName${i + 1}'] = contacts[i].name;
      map['ContactDepartment${i + 1}'] = contacts[i].department;
      map['ContactDesignation${i + 1}'] = contacts[i].designation;
      map['ContactPhone${i + 1}'] = contacts[i].phone;
      map['ContactEmail${i + 1}'] = contacts[i].email;
    }

    return map;
  }
}



// class Customer {
//   final String customerId;
//   final String customerName;
//   final String gstNo;
//   final String customerTypeId;
//   final String companyTypeId;
//   final String industryTypeId;
//   final String customerType;
//   final String companyType;
//   final String industryType;
//   final String addressName;
//   final String street;
//   final String landMark;
//   final String pinCode;
//   final String city;
//   final String state;
//   final String district;
//   final String country;
//   final List<Contact> contacts;
//   final DateTime insertedOn;
//
//   Customer({
//     required this.customerId,
//     required this.customerName,
//     required this.gstNo,
//     required this.customerTypeId,
//     required this.companyTypeId,
//     required this.industryTypeId,
//     required this.addressName,
//     required this.street,
//     required this.landMark,
//     required this.pinCode,
//     required this.district,
//     required this.city,
//     required this.state,
//     required this.country,
//     required this.contacts,
//     required this.insertedOn,
//     required this.customerType,
//     required this.companyType,
//     required this.industryType,
//   });
//
//   factory Customer.fromJson(Map<String, dynamic> json) {
//     return Customer(
//       customerId: json['CustomerId'] ?? '',
//       customerName: json['CustomerName'] ?? '',
//       gstNo: json['GSTNo'] ?? '',
//       customerTypeId: json['CustomerTypeId'] ?? '',
//       companyTypeId: json['CompanyTypeId'] ?? '',
//       industryTypeId: json['IndustryTypeId'] ?? '',
//       addressName: json['AddressName'] ?? '',
//       street: json['Street'] ?? '',
//       district: json['District'] ?? '' ?? '',
//       landMark: json['LandMark'] ?? '',
//       pinCode: json['Pincode'] ?? '',
//       city: json['City'] ?? '',
//       state: json['State'] ?? '',
//       country: json['Country'] ?? '',
//       contacts: List.generate(5, (index) {
//         return Contact(
//           name: json['ContactName${index + 1}'] ?? '',
//           department: json['ContactDepartment${index + 1}'] ?? '',
//           designation: json['ContactDesignation${index + 1}'] ?? '',
//           phone: json['ContactPhone${index + 1}'] ?? '',
//           email: json['ContactEmail${index + 1}'] ?? '',
//         );
//       }),
//       insertedOn: DateTime.parse(json['InsertedOn']),
//       customerType: json['CustomerType'] ?? '',
//       companyType: json['CompanyType'] ?? '',
//       industryType: json['IndustryType'] ?? '',
//     );
//   }
// }

class CustomerEntry {
  final String? id;
  final String? name;
  final String? status; // e.g., 'Approved', 'Pending'

  CustomerEntry({
    this.id,
    this.name,
    this.status,
  });

  factory CustomerEntry.fromMap(Map<String, String?> map) {
    return CustomerEntry(
      id: map['CustomerId'],
      name: map['CustomerName'],
      status: map['Status'],
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
