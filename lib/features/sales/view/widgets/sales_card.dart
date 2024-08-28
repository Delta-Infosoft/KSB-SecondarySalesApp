
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/date_time_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/sales/model/sales_data_model.dart';

class SalesCard extends StatelessWidget {
  final SalesData data;

  const SalesCard({super.key, required this.data});

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
          backgroundColor: context.primaryColor,
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.customerName),
            Text('Product Qty : ${data.ksbSalesInvoiceId.split(',').length}')
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
        ),
        subtitle: Text(data.insertedOn.format('dd-MMM-yyyy hh:mm a')),
      ),
      openBuilder: (context, closeContainer) =>
          SalesEntryDetailsScreen(data: data),
    );
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.salesMaterialNumbers,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              data.customerName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              data.insertedOn.format('dd-MMM-yyyy hh:mm a'),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRichText('KSB Sales Product ID: ', data.ksbSalesInvoiceId),
                _buildRichText('Sales Date: ', data.salesDate.toIso8601String()),
                _buildRichText('Customer ID: ', data.customerId),
                _buildRichText('GST No: ', data.gstNo),
                _buildRichText('Customer Mobile No: ', data.customerMobileNo),
                _buildRichText('Customer Email ID: ', data.customerEmailId),
                _buildRichText('Customer Address: ', data.customerAddress),
                _buildRichText('Pincode: ', data.pincode),
                _buildRichText('Landmark: ', data.landMark),
                _buildRichText('Street: ', data.street),
                _buildRichText('City: ', data.city),
                _buildRichText('State: ', data.state),
                _buildRichText('Country: ', data.country),
                _buildRichText('District: ', data.district),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
      ),
    );
  }
}



class SalesEntryDetailsScreen extends StatelessWidget {
  final SalesData data;

  SalesEntryDetailsScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Entry Details'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Customer Name'),
            subtitle: Text(data.customerName),
          ),
          divider(),
          ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Sales Date'),
            subtitle: Text(data.salesDate.toIso8601String()),
          ),

          divider(),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('GST No'),
            subtitle: Text(data.gstNo),
          ),
          divider(),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Customer Mobile No'),
            subtitle: Text(data.customerMobileNo),
          ),
          divider(),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Customer Email ID'),
            subtitle: Text(data.customerEmailId),
          ),
          divider(),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Customer Address'),
            subtitle: Text(data.customerAddress),
          ),
          divider(),
          ListTile(
            leading: const Icon(Icons.pin_drop),
            title: const Text('Pincode'),
            subtitle: Text(data.pincode),
          ),
          divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Landmark'),
            subtitle: Text(data.landMark),
          ),
          divider(),
          ListTile(
            leading: const Icon(Icons.streetview),
            title: const Text('Street'),
            subtitle: Text(data.street),
          ),
          divider(),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text('City'),
            subtitle: Text(data.city),
          ),
          divider(),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('State'),
            subtitle: Text(data.state),
          ),
          divider(),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Country'),
            subtitle: Text(data.country),
          ),
          divider(),
          ListTile(
            leading: const Icon(Icons.location_city_outlined),
            title: const Text('District'),
            subtitle: Text(data.district),
          ),
          30.heightGap,
          Text(
            '    Products Detail',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: context.primaryColor),
          ),
          30.heightGap,
    ...data.products
        .map((contact) {
          return Column(
            children: [
              ExpansionTile(
                shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent)),
                collapsedShape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent)),

                leading: const Icon(Icons.numbers),
                title: const Text('Material Number',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                subtitle: Text(
                  contact.materialNumber,
                  style: const TextStyle(color: Colors.black54),
                ),
                // children
                // Padding: EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _buildListTile(Icons.note_alt, 'Material Descreption', contact.materialDescription),

                ],
              ),
              divider(),

            ],
          );
    }),

        ],
      ),
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
  divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(),
    );
  }

}
