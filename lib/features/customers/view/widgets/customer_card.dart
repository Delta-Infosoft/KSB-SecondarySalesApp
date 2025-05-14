import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
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
          child: const Icon(
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
          _buildListTile(FontAwesomeIcons.userCircle, 'Customer Name',
              customer.customerName),
          divider(),
          _buildListTile(FontAwesomeIcons.mapPin, 'Pin Code', customer.pinCode),
          // divider(),
          // _buildListTile(
          //     FontAwesomeIcons.landmark, 'Landmark', customer.landMark),
          divider(),
          _buildListTile(FontAwesomeIcons.road, 'Street', customer.street),
          divider(),
          _buildListTile(FontAwesomeIcons.city, 'City', customer.city),
          divider(),
          _buildListTile(
              FontAwesomeIcons.locationArrow, 'District', customer.district),
          divider(),
          _buildListTile(FontAwesomeIcons.map, 'State', customer.state),
          divider(),
          _buildListTile(FontAwesomeIcons.globe, 'Country', customer.country),
          divider(),
          _buildListTile(
              FontAwesomeIcons.fileInvoiceDollar, 'GST No', customer.gstNo),
          divider(),
          _buildListTile(
              FontAwesomeIcons.building, 'Company Type', customer.companyType),
          divider(),
          _buildListTile(
              FontAwesomeIcons.userTie, 'Customer Type', customer.customerType),
          divider(),
          _buildListTile(FontAwesomeIcons.industry, 'Industry Type',
              customer.industryType),
          10.heightGap,
          Container(
              color: context.colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              child: Text(
                ' Contact Persons List',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: context.colorScheme.onPrimaryContainer),
              )),
          10.heightGap,
          ...customer.contacts
              .where((contact) => contact.name.isNotEmpty)
              .toList()
              .asMap()
              .entries
              .map((entry) {
            int index = entry.key;
            Contact contact = entry.value;

            return Column(
              children: [
                ExpansionTile(
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent)),
                  collapsedShape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent)),
                  leading: const Icon(FontAwesomeIcons.user),
                  title: Text(contact.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text(
                    contact.designation,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  children: [
                    _buildListTile(
                        FontAwesomeIcons.phone, 'Phone', contact.phone),
                    _buildListTile(FontAwesomeIcons.briefcase, 'Department',
                        contact.department),
                    _buildListTile(
                        FontAwesomeIcons.envelope, 'Email', contact.email),
                  ],
                ),
                // Show divider only if it's not the last contact
                if (index < customer.contacts.length - 1) divider(),
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
      leading: Icon(
        icon,
        color: const Color(0xFF336699),
        size: 20,
      ), // Use your primary color for icons
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}
