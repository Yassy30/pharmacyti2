import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final bool isCompleted;

  const OrderDetailsScreen({
    Key? key,
    required this.orderId,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order ID:#$orderId',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Prescription Section
              _buildSectionContainer(
                context,
                'Uploaded Prescription',
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Rx',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Rx',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // Medicine Information
              _buildSectionContainer(
                context,
                'Medicine Information',
                Column(
                  children: [
                    _buildMedicineItem(
                      'A GEN Cream 15gm',
                      '3x',
                      '16\$',
                    ),
                    SizedBox(height: 8),
                    _buildMedicineItem(
                      'ECLO 8 Ointment 30gm',
                      '4x',
                      '82\$',
                    ),
                  ],
                ),
                titleSuffix: Text(
                  'Total Items 2',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.amber,
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Payment Information
              _buildSectionContainer(
                context,
                'Payment Information',
                Column(
                  children: [
                    _buildInfoRow('Order ID', '#$orderId'),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Type', style: TextStyle(color: Colors.grey[600])),
                        Text('Delivery', style: TextStyle(color: Colors.amber)),
                      ],
                    ),
                    SizedBox(height: 8),
                    _buildInfoRow('Payment Method', 'Cash On Delivery'),
                    SizedBox(height: 8),
                    _buildInfoRow('Order Date', '2023-04-27'),
                    SizedBox(height: 8),
                    _buildInfoRow("Sub total", "380\$"),
                    SizedBox(height: 8),
                    _buildInfoRow('Discount', '20\$'),
                    SizedBox(height: 8),
                    _buildInfoRow('Delivery Charge', '35\$'),
                    SizedBox(height: 8),
                    _buildInfoRow('Tax', '10\$'),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text('395\$', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // Delivery Address
              _buildSectionContainer(
                context,
                'Delivery Address',
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.home, color: Colors.amber, size: 20),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Home', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text('1005-Apple square', 
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // Customer details
              _buildSectionContainer(
                context,
                'Customer details',
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Text('C', style: TextStyle(color: Colors.amber)),
                        ),
                        SizedBox(width: 12),
                        Text('Cartena', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.amber),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // Bottom section - different for completed and current orders
              if (isCompleted) 
                _buildCompletedSection()
              else
                _buildCurrentOrderSection(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionContainer(BuildContext context, String title, Widget content, {
    bool showTitle = true,
    Widget? titleSuffix,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle) ...[              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (titleSuffix != null) titleSuffix,
                ],
              ),
              SizedBox(height: 12),
            ],
            content,
          ],
        ),
      ),
    );
  }
  
  Widget _buildMedicineItem(String name, String quantity, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            Text(
              quantity,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(width: 16),
            Text(
              price,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(value),
      ],
    );
  }
  
  Widget _buildCompletedSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text(
            'Delivered',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCurrentOrderSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.amber, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Processing',
                    style: TextStyle(color: Colors.amber),
                  ),
                ],
              ),
              Text(
                '\$395',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Accept'),
            ),
          ),
        ],
      ),
    );
  }
}