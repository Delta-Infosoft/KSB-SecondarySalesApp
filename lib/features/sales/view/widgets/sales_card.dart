
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          _buildListTile(FontAwesomeIcons.user, 'Customer Name', data.customerName),
          _divider(),
          _buildListTile(FontAwesomeIcons.calendarAlt, 'Sales Date', data.salesDate.toIso8601String()),
          _divider(),
          _buildListTile(FontAwesomeIcons.qrcode, 'GST No', data.gstNo),
          _divider(),
          _buildListTile(FontAwesomeIcons.phone, 'Customer Mobile No', data.customerMobileNo),
          _divider(),
          _buildListTile(FontAwesomeIcons.envelope, 'Customer Email ID', data.customerEmailId),
          _divider(),
          // _buildListTile(FontAwesomeIcons.mapMarkerAlt, 'Customer Address', data.customerAddress),
          // _divider(),
          _buildListTile(FontAwesomeIcons.mapPin, 'Pincode', data.pincode),
          _divider(),
          _buildListTile(FontAwesomeIcons.landmark, 'Landmark', data.landMark),
          _divider(),
          _buildListTile(FontAwesomeIcons.road, 'Street', data.street),
          _divider(),
          _buildListTile(FontAwesomeIcons.city, 'City', data.city),
          _divider(),
          _buildListTile(FontAwesomeIcons.map, 'State', data.state),
          _divider(),
          _buildListTile(FontAwesomeIcons.locationArrow, 'District', data.district),
          _divider(),
          _buildListTile(FontAwesomeIcons.globe, 'Country', data.country),
          const SizedBox(height: 30),
          Text(
            '    Products Detail',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 30),
          ...data.products.map((product) => _buildProductExpansionTile(product)).toList(),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF336699),size: 20), // Use your primary color for icons
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  Widget _buildProductExpansionTile(Product product) {
    return Column(
      children: [
        ExpansionTile(
          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
          collapsedShape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
          leading: const Icon(FontAwesomeIcons.boxOpen,size: 20,),
          title: const Text(
            'Material Number',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(
            product.materialNumber,
            style: const TextStyle(color: Colors.black54),
          ),
          children: [
            _buildListTile(FontAwesomeIcons.clipboard, 'Material Description', product.materialDescription),
            _buildListTile(FontAwesomeIcons.tag, 'Serial Number', product.serialNumber),
          ],
        ),
        _divider(),
      ],
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(),
    );
  }
}
