import 'package:flutter/material.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/customers/view/widgets/customer_card.dart';

import '../../home/view/screens/home.dart';

class CustomerListScreen extends StatelessWidget {
  final List<Customer> customers;

  CustomerListScreen({required this.customers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => 10.heightGap,
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return CustomerCard(customer: customer);
        },
      ),
    );
  }

}
