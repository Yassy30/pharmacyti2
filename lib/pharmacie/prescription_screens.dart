import 'package:flutter/material.dart';
import 'package:pharmaciyti/pharmacie/Dashboard.dart';
import 'package:pharmaciyti/pharmacie/Profile.dart';
import 'package:pharmaciyti/pharmacie/order_screens.dart';

class PrescriptionScreens extends StatefulWidget {
  const PrescriptionScreens({Key? key}) : super(key: key);

  @override
  State<PrescriptionScreens> createState() => _PrescriptionScreensState();
}

class _PrescriptionScreensState extends State<PrescriptionScreens>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedNavIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    ;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with tabs
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Prescription Order',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: 'Active'),
                        Tab(text: 'Completed'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ActivePrescriptionsTab(),
                  CompletedPrescriptionsTab(),
                ],
              ),
            ),

            
          ],
        ),
      ),
    );
  }

  
}

// Active Prescriptions Tab
class ActivePrescriptionsTab extends StatelessWidget {
  const ActivePrescriptionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPrescriptionCard(
          context,
          date: '2024-07-27',
          orderId: '195',
          pharmacy: 'Cartena',
          address: '',
          paymentMethod: '',
          amount: '',
          status: 'Pending',
          type: '',
          isSelf: false,
        ),
        const SizedBox(height: 16),
        _buildPrescriptionCard(
          context,
          date: '2024-06-30',
          orderId: '190',
          pharmacy: 'Cartena',
          address: '',
          paymentMethod: '',
          amount: '',
          status: 'Pending',
          type: '',
          isSelf: false,
        ),
      ],
    );
  }
}

// Completed Prescriptions Tab
class CompletedPrescriptionsTab extends StatelessWidget {
  const CompletedPrescriptionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPrescriptionCard(
          context,
          date: '2023-04-27',
          orderId: '8',
          pharmacy: 'Cartena',
          address: '1005-Apple square',
          paymentMethod: 'Razorpay',
          amount: '\$103',
          status: 'Completed',
          type: 'Delivery',
          isSelf: false,
        ),
        const SizedBox(height: 16),
        _buildPrescriptionCard(
          context,
          date: '2023-04-27',
          orderId: '1',
          pharmacy: 'Cartena',
          address: '1591 Bradley Park ...',
          paymentMethod: 'Razorpay',
          amount: '\$46',
          status: 'Completed',
          type: 'Self',
          isSelf: true,
        ),
      ],
    );
  }
}

// Shared prescription card widget
Widget _buildPrescriptionCard(
  BuildContext context, {
  required String date,
  required String orderId,
  required String pharmacy,
  required String address,
  required String paymentMethod,
  required String amount,
  required String status,
  required String type,
  required bool isSelf,
}) {
  final bool isPending = status == 'Pending';
  final Color statusColor = isPending ? Colors.orange : Colors.green;
  final IconData statusIcon =
      isPending ? Icons.access_time : Icons.check_circle;

  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(color: Colors.grey[600]),
              ),
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    status,
                    style: TextStyle(color: statusColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID:$orderId',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (type.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'C',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (address.isNotEmpty) const SizedBox(height: 4),
                    if (address.isNotEmpty)
                      Text(
                        address,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (paymentMethod.isNotEmpty || amount.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (paymentMethod.isNotEmpty)
                      Text(
                        paymentMethod,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    if (paymentMethod.isNotEmpty && amount.isNotEmpty)
                      const SizedBox(height: 4),
                    if (amount.isNotEmpty)
                      Text(
                        amount,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (isPending)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              if (isPending) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Info'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
