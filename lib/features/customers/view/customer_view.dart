import 'package:flutter/material.dart';

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
          return ExpansionTile(
            title: Text(customer.name),
            subtitle: Text('Pin Code: ${customer.pinCode}'),
            children: [
              ListTile(
                title: Text('Area: ${customer.area}'),
                subtitle: Text('Lane: ${customer.lane}'),
              ),
              ListTile(
                title: Text('Street: ${customer.street}'),
                subtitle: Text('Landmark: ${customer.landmark}'),
              ),
              ListTile(
                title: Text('City: ${customer.city}'),
                subtitle: Text('State: ${customer.state}'),
              ),
              ListTile(
                title: Text('District: ${customer.district}'),
                subtitle: Text('GST No: ${customer.gstNo}'),
              ),
              ListTile(
                title: Text('Company Type: ${customer.companyType}'),
                subtitle: Text('Customer Type: ${customer.customerType}'),
              ),
              ListTile(
                title: Text('Industry Type: ${customer.industryType}'),
              ),
              ...customer.contacts.map((contact) => ExpansionTile(
                title: Text(contact.name),
                subtitle: Text('Phone: ${contact.phone}'),
                children: [
                  ListTile(
                    title: Text('Department: ${contact.department}'),
                    subtitle: Text('Email: ${contact.email}'),
                  ),
                ],
              )).toList(),
            ],
          );
        },
      ),
    );
  }
}
