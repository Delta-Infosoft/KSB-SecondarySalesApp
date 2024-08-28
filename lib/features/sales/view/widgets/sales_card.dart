
import 'package:flutter/material.dart';
import 'package:ksb_secondary_sales/features/sales/model/sales_data_model.dart';

class SalesCard extends StatelessWidget {
  final SalesData data;

  const SalesCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                data.materialNo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              data.customerContactName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              '${data.insertedOn.day}/${data.insertedOn.month}/${data.insertedOn.year}',
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