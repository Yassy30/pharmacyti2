import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/delivery/orders/view/OrderDetailsScreen.dart';
import 'package:pharmaciyti/features/pharmacie/orders/view/order_screens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LivreurOrderScreen extends StatefulWidget {
  const LivreurOrderScreen({Key? key}) : super(key: key);

  @override
  LivreurOrderScreenState createState() => LivreurOrderScreenState();
}

class LivreurOrderScreenState extends State<LivreurOrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> currentOrders = [];
  List<Map<String, dynamic>> pastOrders = [];
  bool isLoading = false;
  String? errorMessage;
  void setTabIndex(int index) {
    if (index >= 0 && index < _tabController.length) {
      _tabController.index = index;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            id, date, statut, price_total, type_payment,
            user_id(full_name, address, role),
            delivery(localisation_delivery)
          ''')
          .neq('statut', 'canceled') // Exclude canceled orders
          .order('date', ascending: false);

      final allOrders = List<Map<String, dynamic>>.from(response);

      setState(() {
        currentOrders = allOrders.where((order) {
          final status = order['statut']?.toLowerCase() ?? '';
          return status == 'pending' ||
              status == 'processing' ||
              status == 'en attente';
        }).toList();
        pastOrders = allOrders.where((order) {
          final status = order['statut']?.toLowerCase() ?? '';
          return status == 'completed' || status == 'delivered';
        }).toList();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load orders: $error';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'An error occurred')),
      );
    }
  }

  Future<void> _cancelOrder(int orderId) async {
    try {
      await _supabase
          .from('orders')
          .update({'statut': 'canceled'})
          .eq('id', orderId);
      _loadOrders(); // Refresh the order lists
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order canceled successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel order: $error')),
      );
    }
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
                      labelColor: Colors.orange,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: 'Current Orders'),
                        Tab(text: 'Past Orders'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrderList(currentOrders, true),
                  _buildOrderList(pastOrders, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders, bool isCurrent) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage != null) return Center(child: Text(errorMessage!));
    if (orders.isEmpty) return const Center(child: Text('No orders'));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final userData = order['user_id'] as Map<String, dynamic>? ?? {};
        final deliveryData = order['delivery'] as Map<String, dynamic>? ?? {};
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildOrderCard(
            context,
            date: DateTime.parse(order['date']).toString().split(' ')[0],
            orderId: order['id'].toString(),
            pharmacy: userData['full_name'] ?? 'Unknown User',
            address: userData['address'] ?? 'No Address Provided',
            paymentMethod: order['type_payment'] ?? 'Unknown',
            amount: '\$${order['price_total']?.toInt() ?? 0}',
            status: _mapStatus(order['statut'] ?? 'Unknown'),
            deliveryAddress: deliveryData['localisation_delivery'] ?? 'No Delivery Address',
            onCancel: isCurrent ? () => _cancelOrder(order['id']) : null,
          ),
        );
      },
    );
  }

  String _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'processing':
      case 'en attente':
        return 'Pending';
      case 'delivered':
      case 'completed':
        return 'Delivered';
      default:
        return status.capitalize;
    }
  }

  Widget _buildOrderCard(
    BuildContext context, {
    required String date,
    required String orderId,
    required String pharmacy,
    required String address,
    required String paymentMethod,
    required String amount,
    required String status,
    required String deliveryAddress,
    VoidCallback? onCancel,
  }) {
    final bool isPending = status == 'Pending';
    final Color statusColor = isPending ? Colors.orange : Colors.green;
    final IconData statusIcon = isPending ? Icons.access_time : Icons.local_shipping;

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
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
                if (isPending && onCancel != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                if (isPending && onCancel != null) const SizedBox(width: 12),
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
                      ).then((_) => _loadOrders()); // Refresh after returning
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
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
}