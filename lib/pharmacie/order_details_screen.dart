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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Order ID: #$orderId'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Uploaded Prescription Section
              _buildSectionContainer(
                context,
                'Uploaded Prescription',
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Rx',
                      style: TextStyle(fontSize: 40, color: Colors.grey),
                    ),
                  ),
                ),
                showTitle: true,
              ),
              SizedBox(height: 16),

              // Medicine Information Section
              _buildSectionContainer(
                context,
                'Medicine Information',
                Column(
                  children: [
                    _buildMedicineItem(
                      'AZITACT 500mg',
                      "Tablet 5's",
                      '1x',
                      '₹110',
                      '₹22',
                    ),
                    _buildMedicineItem(
                      'K-Flus Cream',
                      '15gm',
                      '1x',
                      '₹120',
                      '₹25',
                    ),
                  ],
                ),
                titleSuffix: Text(
                  'Total Item:  2',
                  style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 16),

              // Payment Information
              _buildSectionContainer(
                context,
                'Payment Information',
                Column(
                  children: [
                    _buildInfoRow('Order ID:', '#$orderId'),
                    _buildInfoRow('Status:', 'Pending', isStatus: true),
                    _buildInfoRow('Type:', 'Self', valueColor: Colors.green),
                    _buildInfoRow('Time slot:', '10:00 AM to 2:20 PM'),
                    _buildInfoRow('Payment Method:', 'Razorpay'),
                    _buildInfoRow('Transaction ID:', 'pay_QM7imwwRhBHBSo'),
                    _buildInfoRow('Order Date:', '2025-04-22'),
                    _buildInfoRow('Sub Total:', '₹230'),
                    _buildInfoRow('Tax:', '₹10'),
                    Divider(color: Colors.grey.shade300),
                    _buildInfoRow('Total Amount:', '₹240', isBold: true),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Customer Details
              _buildSectionContainer(
                context,
                'Customer details',
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, color: Colors.grey),
                      SizedBox(width: 12),
                      Text('Cartena'),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Replace the Total Payment and Accept Button with Completed section if isCompleted is true
              if (isCompleted)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 12),
                      Text(
                        'Completed',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              else
                // Total Payment and Accept Button
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹240',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Total Payment',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Container(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Order accepted!')),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Accept'),
                        ),
                      ),
                    ],
                  ),
                ),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

  Widget _buildMedicineItem(
      String name, String description, String quantity, String price, String discount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text(description, style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(quantity, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(price, style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text(discount, style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isStatus = false, bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? (isStatus ? Colors.orange : Colors.black),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
