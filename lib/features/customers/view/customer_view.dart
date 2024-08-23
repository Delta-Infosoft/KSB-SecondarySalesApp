import 'package:flutter/material.dart';

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
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ExpansionTile(
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              title: Text(
                customer.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              children: [
                _buildRichText('Pin Code', customer.pinCode),
                _buildRichText('Area', customer.area),
                _buildRichText('Lane', customer.lane),
                _buildRichText('Street', customer.street),
                _buildRichText('City', customer.city),
                _buildRichText('State', customer.state),
                _buildRichText('District', customer.district),
                _buildRichText('GST No', customer.gstNo),
                _buildRichText('Company Type', customer.companyType),
                _buildRichText('Customer Type', customer.customerType),
                _buildRichText('Industry Type', customer.industryType),
                ExpansionTile(
                  title: const Text(
                    'Contacts',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: customer.contacts.map((contact) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            contact.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildRichText('Phone', contact.phone),
                          _buildRichText('Department', contact.department),
                          _buildRichText('Email', contact.email),
                          Divider(),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              ],
            ),
          );
        },
      ),
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
