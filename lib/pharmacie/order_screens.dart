import 'package:flutter/material.dart';
import 'package:pharmaciyti/pharmacie/Dashboard.dart';
import 'package:pharmaciyti/pharmacie/Profile.dart';
import 'package:pharmaciyti/pharmacie/order_details_screen.dart';

class OrderScreens extends StatefulWidget {
  const OrderScreens({Key? key}) : super(key: key);

  @override
  State<OrderScreens> createState() => _OrderScreensState();
}

class _OrderScreensState extends State<OrderScreens>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
   int _selectedNavIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                    'My Orders',
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
                        Tab(text: 'Current Order'),
                        Tab(text: 'Past Orders'),
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
                  CurrentOrdersTab(),
                  PastOrdersTab(),
                ],
              ),
            ),

            
          ],
        ),
      ),
    );
  }

  
}

// Current Orders Tab
class CurrentOrdersTab extends StatelessWidget {
  const CurrentOrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildOrderCard(
          context,
          date: '2025-05-11',
          orderId: '215',
          pharmacy: 'Cartena',
          address: '1591 Bradley Park ...',
          paymentMethod: 'Pay At Store',
          amount: '\$135',
          status: 'Pending',
          isSelf: true,
        ),
        const SizedBox(height: 16),
        _buildOrderCard(
          context,
          date: '2025-04-22',
          orderId: '213',
          pharmacy: 'Cartena',
          address: '1591 Bradley Park ...',
          paymentMethod: 'Razorpay',
          amount: '\$240',
          status: 'Pending',
          isSelf: true,
        ),
      ],
    );
  }
}

// Past Orders Tab
class PastOrdersTab extends StatelessWidget {
  const PastOrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildOrderCard(
          context,
          date: '2023-04-27',
          orderId: '11',
          pharmacy: 'Cartena',
          address: '1591 Bradley Park ...',
          paymentMethod: 'Pay At Store',
          amount: '\$151',
          status: 'Completed',
          isSelf: true,
        ),
        const SizedBox(height: 16),
        _buildOrderCard(
          context,
          date: '2023-04-27',
          orderId: '10',
          pharmacy: 'Cartena',
          address: '1591 Bradley Park ...',
          paymentMethod: 'Razorpay',
          amount: '\$120',
          status: 'Completed',
          isSelf: true,
        ),
      ],
    );
  }
}

// Shared order card widget
Widget _buildOrderCard(
  BuildContext context, {
  required String date,
  required String orderId,
  required String pharmacy,
  required String address,
  required String paymentMethod,
  required String amount,
  required String status,
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
                'Order ID: $orderId',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (isSelf)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Self',
                    style: TextStyle(color: Colors.green),
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
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    paymentMethod,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(
                          orderId: orderId,
                          isCompleted: status.toLowerCase() == 'completed',
                        ),
                      ),
                    );
                  },
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
