import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final bool isCompleted;

  const OrderDetailsScreen({
    Key? key,
    required this.orderId,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _supabase = Supabase.instance.client;
  Map<String, dynamic>? orderDetails;
  List<Map<String, dynamic>> medicineItems = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    setState(() => isLoading = true);
    try {
      // Fetch order details
      final orderResponse = await _supabase
          .from('orders')
          .select('''
            id, date, statut, price_total, type_payment,
            user_id(full_name, address, role)
          ''')
          .eq('id', int.parse(widget.orderId))
          .single();

      // Fetch medicine items via order_medicine and medicines tables
      final medicineResponse = await _supabase
          .from('order_medicines')
          .select('''
            medicine!inner(name,price, quantity,description)
          ''')
          .eq('order_id', int.parse(widget.orderId));

      setState(() {
        orderDetails = orderResponse;
        // Extract medicine items from the response
        medicineItems = List<Map<String, dynamic>>.from(medicineResponse.map((item) => {
          'quantity': item['quantity'],
          'medicine': item['medicine'],
        }));
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load order details: $error';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'An error occurred')),
      );
    }
  }

  Future<void> _acceptOrder() async {
    try {
      await _supabase
          .from('orders')
          .update({'statut': 'completed'})
          .eq('id', int.parse(widget.orderId));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order accepted successfully!')),
      );
      Navigator.pop(context); // Return to previous screen
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept order: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Order ID: #${widget.orderId}'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SingleChildScrollView(
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
                            child: const Center(
                              child: Text(
                                'Rx',
                                style: TextStyle(fontSize: 40, color: Colors.grey),
                              ),
                            ),
                          ),
                          showTitle: true,
                        ),
                        const SizedBox(height: 16),

                        // Medicine Information Section
                        _buildSectionContainer(
                          context,
                          'Medicine Information',
                          Column(
                            children: medicineItems.map((item) {
                              final medicine = item['medicine'] as Map<String, dynamic>? ?? {};
                              return _buildMedicineItem(
                                medicine['name'] ?? 'Unknown',
                                medicine['description'] ?? 'N/A',
                                item['quantity']?.toString() ?? '1x',
                                '₹${medicine['price']?.toString() ?? '0'}',
                                '₹${medicine['discount']?.toString() ?? '0'}',
                              );
                            }).toList(),
                          ),
                          titleSuffix: Text(
                            'Total Item:  ${medicineItems.length}',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Payment Information
                        _buildSectionContainer(
                          context,
                          'Payment Information',
                          Column(
                            children: [
                              _buildInfoRow('Order ID:', '#${widget.orderId}'),
                              _buildInfoRow(
                                  'Status:',
                                  orderDetails?['statut'] ?? 'Unknown',
                                  isStatus: true),
                              _buildInfoRow(
                                  'Payment Method:',
                                  orderDetails?['type_payment'] ?? 'Unknown'),
                              _buildInfoRow(
                                  'Order Date:',
                                  DateTime.parse(orderDetails?['date'] ?? '')
                                      .toString()
                                      .split(' ')[0]),
                              _buildInfoRow(
                                  'Total:', '₹${orderDetails?['price_total'] ?? 0}'),
                              const Divider(color: Colors.grey),
                              _buildInfoRow(
                                  'Total Amount:',
                                  '₹${orderDetails?['price_total'] ?? 0}',
                                  isBold: true),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Customer Details
                        _buildSectionContainer(
                          context,
                          'Customer Details',
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.person_outline,
                                    color: Colors.grey),
                                const SizedBox(width: 12),
                                Text(
                                    orderDetails?['user_id']?['full_name'] ??
                                        'Unknown User'),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Replace with Completed section if isCompleted is true
                        if (widget.isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
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
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 12),
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
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
                                      '₹${orderDetails?['price_total'] ?? 0}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'Total Payment',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Container(
                                  width: 120,
                                  child: ElevatedButton(
                                    onPressed: _acceptOrder,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Accept'),
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

  Widget _buildSectionContainer(BuildContext context, String title, Widget content,
      {bool showTitle = true, Widget? titleSuffix}) {
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
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  if (titleSuffix != null) titleSuffix,
                ],
              ),
              const SizedBox(height: 12),
            ],
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineItem(String name, String description, String quantity,
      String price, String discount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
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
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(description,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(quantity,
                  style:
                      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(price, style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(discount,
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12)),
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
          Text(label, style: const TextStyle(color: Colors.grey)),
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