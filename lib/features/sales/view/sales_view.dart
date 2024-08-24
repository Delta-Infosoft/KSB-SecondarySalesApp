import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';


class SalesListView extends StatelessWidget {


  const SalesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Data'),
      ),
      body: ListView.builder(
        itemCount: salesData.length,
        itemBuilder: (context, index) {
          final data = salesData[index];
          return SalesCard(salesData: data);
        },
      ),
    );
  }
}


class SalesData {
  final String salesDate;
  final String customerName;
  final String mobileNo;
  final String email;
  final String address;
  final String pinCode;
  final String area;
  final String state;
  final String taluka;
  final String district;
  final String productName;
  final String productDetail;
  final double productPrice;
  final String productImageUrl; // New field

  SalesData({
    required this.salesDate,
    required this.customerName,
    required this.mobileNo,
    required this.email,
    required this.address,
    required this.pinCode,
    required this.area,
    required this.state,
    required this.taluka,
    required this.district,
    required this.productName,
    required this.productDetail,
    required this.productPrice,
    required this.productImageUrl, // Initialize new field
  });

  @override
  String toString() {
    return 'SalesData(salesDate: $salesDate, customerName: $customerName, mobileNo: $mobileNo, email: $email, address: $address, pinCode: $pinCode, area: $area, state: $state, taluka: $taluka, district: $district, productName: $productName, productDetail: $productDetail, productPrice: $productPrice, productImageUrl: $productImageUrl)';
  }
}


List<SalesData> salesData = [
  SalesData(
    salesDate: '2024-08-21',
    customerName: 'John Doe',
    mobileNo: '1234567890',
    email: 'john.doe@example.com',
    address: '123 Elm Street, Springfield',
    pinCode: '62704',
    area: 'Central Area',
    state: 'Illinois',
    taluka: 'Springfield',
    district: 'Sangamon',
    productName: 'Widget A',
    productDetail: 'A high-quality widget for various applications.',
    productPrice: 29.99,
    productImageUrl: 'https://t3.ftcdn.net/jpg/00/77/77/16/360_F_77771611_BCUZR6NW73NVdiLgmOeIzzSh4RP2U3aV.jpg',
  ),
  SalesData(
    salesDate: '2024-08-20',
    customerName: 'Jane Smith',
    mobileNo: '0987654321',
    email: 'jane.smith@example.com',
    address: '456 Oak Avenue, Springfield',
    pinCode: '62705',
    area: 'North Area',
    state: 'Illinois',
    taluka: 'Springfield',
    district: 'Sangamon',
    productName: 'Gadget B',
    productDetail: 'An advanced gadget with multiple features.',
    productPrice: 49.99,
    productImageUrl: 'https://t3.ftcdn.net/jpg/00/77/77/16/360_F_77771611_BCUZR6NW73NVdiLgmOeIzzSh4RP2U3aV.jpg',
  ),
  SalesData(
    salesDate: '2024-08-19',
    customerName: 'Alice Johnson',
    mobileNo: '5678901234',
    email: 'alice.johnson@example.com',
    address: '789 Pine Road, Springfield',
    pinCode: '62706',
    area: 'South Area',
    state: 'Illinois',
    taluka: 'Springfield',
    district: 'Sangamon',
    productName: 'Device C',
    productDetail: 'A compact device with enhanced capabilities.',
    productPrice: 39.99,
    productImageUrl: 'https://t3.ftcdn.net/jpg/00/77/77/16/360_F_77771611_BCUZR6NW73NVdiLgmOeIzzSh4RP2U3aV.jpg',
  ),
];


class SalesCard extends StatelessWidget {
  final SalesData salesData;

  const SalesCard({Key? key, required this.salesData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: salesData.productImageUrl,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        salesData.productName,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        salesData.productDetail,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$${salesData.productPrice.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text('Sales Date: ${salesData.salesDate}'),
            const SizedBox(height: 5),
            Text('Customer Name: ${salesData.customerName}'),
            const SizedBox(height: 5),
            Text('Mobile No: ${salesData.mobileNo}'),
            const SizedBox(height: 5),
            Text('Email: ${salesData.email}'),
            const SizedBox(height: 5),
            Text('Address: ${salesData.address}'),
            const SizedBox(height: 5),
            Text('Pin Code: ${salesData.pinCode}'),
            const SizedBox(height: 5),
            Text('Area: ${salesData.area}'),
            const SizedBox(height: 5),
            Text('State: ${salesData.state}'),
            const SizedBox(height: 5),
            Text('Taluka: ${salesData.taluka}'),
            const SizedBox(height: 5),
            Text('District: ${salesData.district}'),
          ],
        ),
      ),
    );
  }
}