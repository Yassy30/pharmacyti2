import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/pharmacie/dashboard/view/Dashboard.dart';
import 'package:pharmaciyti/features/pharmacie/profil/view/Profile_pharmacy.dart';
import 'package:pharmaciyti/features/pharmacie/orders/view/order_details_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderScreens extends StatefulWidget {
  const OrderScreens({Key? key}) : super(key: key);

  @override
  State<OrderScreens> createState() => _OrderScreensState();
}

class _OrderScreensState extends State<OrderScreens>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedNavIndex = 1;
  final _supabase = Supabase.instance.client;
  bool _hasCheckedAuth = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_supabase.auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to view orders')),
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

class CurrentOrdersTab extends StatefulWidget {
  const CurrentOrdersTab({Key? key}) : super(key: key);

  @override
  State<CurrentOrdersTab> createState() => _CurrentOrdersTabState();
}

class _CurrentOrdersTabState extends State<CurrentOrdersTab> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> currentOrders = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrentOrders();
  }

  Future<void> _loadCurrentOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            id, date, statut, price_total, type_payment,
            user_id(full_name, address, role)
          ''')
          .inFilter('statut', ['pending', 'En attente'])
          .order('date', ascending: false);

      setState(() {
        currentOrders = List<Map<String, dynamic>>.from(response);
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

      setState(() {
        currentOrders.removeWhere((order) => order['id'] == orderId);
      });
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
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }
    if (currentOrders.isEmpty) {
      return const Center(child: Text('No current orders'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: currentOrders.length,
      itemBuilder: (context, index) {
        final order = currentOrders[index];
        final userData = order['user_id'] as Map<String, dynamic>? ?? {};
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
            onCancel: () => _cancelOrder(order['id']),
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
        return 'Completed';
      case 'canceled':
        return 'Canceled';
      default:
        return status.capitalize;
    }
  }
}

class PastOrdersTab extends StatefulWidget {
  const PastOrdersTab({Key? key}) : super(key: key);

  @override
  State<PastOrdersTab> createState() => _PastOrdersTabState();
}

class _PastOrdersTabState extends State<PastOrdersTab> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> pastOrders = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPastOrders();
  }

  Future<void> _loadPastOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            id, date, statut, price_total, type_payment,
            user_id(full_name, address, role)
          ''')
          .inFilter('statut', ['shipped', 'delivered', 'canceled', 'completed'])
          .order('date', ascending: false);

      setState(() {
        pastOrders = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load past orders: $error';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }
    if (pastOrders.isEmpty) {
      return const Center(child: Text('No past orders'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pastOrders.length,
      itemBuilder: (context, index) {
        final order = pastOrders[index];
        final userData = order['user_id'] as Map<String, dynamic>? ?? {};
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
        return 'Completed';
      case 'canceled':
        return 'Canceled';
      default:
        return status.capitalize;
    }
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
  VoidCallback? onCancel,
}) {
  final bool isPending = status == 'Pending';
  final bool isCanceled = status == 'Canceled';
  final Color statusColor = isCanceled
      ? Colors.red
      : (isPending ? Colors.orange : Colors.green);
  final IconData statusIcon = isCanceled
      ? Icons.cancel
      : (isPending ? Icons.access_time : Icons.check_circle);

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
              if (isPending && onCancel != null)
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCancel,
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
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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

extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}