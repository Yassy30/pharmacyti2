import 'package:flutter/material.dart';

class PayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Earnings Section
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$668.9',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Your total earning',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  ],
                ),
                Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/0/04/Mastercard-logo.png',
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.credit_card,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // History Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'History',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildHistoryItem(
                  context,
                  date: '2023-04-27',
                  type: 'UPI completed',
                  amount: '50\$',
                  status: 'completed',
                ),
                _buildHistoryItem(
                  context,
                  date: '2023-04-27',
                  type: 'BANK Transfer pending',
                  amount: '50\$',
                  status: 'pending',
                ),
                _buildHistoryItem(
                  context,
                  date: '2023-04-27',
                  type: 'Paypal pending',
                  amount: '50\$',
                  status: 'pending',
                ),
                _buildHistoryItem(
                  context,
                  date: '2023-04-27',
                  type: 'UPI pending',
                  amount: '10\$',
                  status: 'pending',
                ),
              ],
            ),
          ),
          // Request Button
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showRequestDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text('Request', style: TextStyle(fontSize: 16.0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context, {
    required String date,
    required String type,
    required String amount,
    required String status,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon
            Icon(
              Icons.description,
              color: Colors.green,
              size: 40.0,
            ),
            SizedBox(width: 16.0),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    type,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              amount,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: status == 'completed' ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestDialog(BuildContext context) {
    String? selectedType;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pay Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Minimum amount: 50\$',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Type',
                  border: OutlineInputBorder(),
                ),
                items: ['UPI', 'BANK Transfer', 'Paypal']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedType = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Proceed'),
            ),
          ],
        );
      },
    );
  }
}