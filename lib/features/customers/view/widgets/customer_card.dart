import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/features/customers/view_model/customer_view_controller.dart';
import 'package:ksb_secondary_sales/features/home/view/screens/home.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key, required this.customer});
  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openColor: context.colorScheme.primaryContainer,
      closedColor: context.primaryColor.withOpacity(.1),
      closedElevation: 0,
      openElevation: 0,
      closedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      middleColor: Colors.transparent,
      closedBuilder: (context, openContainer) => ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        leading: CircleAvatar(
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
          backgroundColor: context.primaryColor,
        ),
        title: Text(customer.customerName),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
        ),
        subtitle: Text(customer.customerType),
      ),
      openBuilder: (context, closeContainer) =>
          CustomerDetailsScreen(customer: customer),
    );
  }

  Widget _buildRichText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerDetailsScreen extends GetView<CustomerViewController> {
  const CustomerDetailsScreen({super.key, required this.customer});
  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(customer.customerName)),
      body: ListView(
        children: [
          _buildListTile(Icons.person_pin_outlined, 'Customer Name',
              customer.customerName),
          divider(),
          _buildListTile(Icons.pin, 'Pin Code', customer.pinCode),
          divider(),
          _buildListTile(Icons.location_on, 'Area', customer.landMark),
          divider(),
          _buildListTile(Icons.streetview, 'Street', customer.street),
          divider(),
          _buildListTile(Icons.location_city, 'City', customer.city),
          divider(),
          _buildListTile(Icons.location_city, 'State', customer.state),
          divider(),
          _buildListTile(Icons.location_city, 'District', customer.district),
          divider(),
          _buildListTile(Icons.business, 'GST No', customer.gstNo),
          divider(),
          _buildListTile(
              Icons.business,
              'Company Type',
customer.companyType),
          divider(),
          _buildListTile(
              Icons.person,
              'Customer Type',
              customer.customerType),
          divider(),
          _buildListTile(
              Icons.category,
              'Industry Type',
              customer.industryType),
          divider(),
          ...customer.contacts
              .where(
            (element) => element.name.isNotEmpty,
          )
              .map((contact) {
            return Column(
              children: [
                ExpansionTile(
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent)),
                  collapsedShape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent)),

                  leading: const Icon(Icons.account_circle),
                  title: Text(contact.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text(
                    contact.designation,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  // children
                  // Padding: EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    _buildListTile(Icons.phone, 'Phone', contact.phone),
                    _buildListTile(
                        Icons.work, 'Department', contact.department),
                    _buildListTile(
                        Icons.work, 'Department', contact.department),
                    _buildListTile(Icons.email, 'Email', contact.email),
                  ],
                ),
                divider(),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(),
    );
  }

  Widget _buildListTile(IconData icon, String title, String value) {
    return ListTile(
      // contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
      leading: Icon(icon,
          color: const Color(0xFF336699)), // Use your primary color for icons
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}
