// import 'package:flutter/material.dart';
// import 'package:pharmaciyti/features/pharmacie/dashboard/view/Dashboard.dart';
// import 'package:pharmaciyti/features/pharmacie/profil/view/Profile.dart';
// import 'package:pharmaciyti/features/pharmacie/orders/view/order_details_screen.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class OrderScreens extends StatefulWidget {
//   const OrderScreens({Key? key}) : super(key: key);

//   @override
//   State<OrderScreens> createState() => _OrderScreensState();
// }

// class _OrderScreensState extends State<OrderScreens>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final _supabase = Supabase.instance.client;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header with tabs
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   const Text(
//                     'My Orders',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: TabBar(
//                       controller: _tabController,
//                       indicator: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       labelColor: Colors.green,
//                       unselectedLabelColor: Colors.grey,
//                       tabs: const [
//                         Tab(text: 'Current Orders'),
//                         Tab(text: 'Past Orders'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Tab content
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: const [
//                   CurrentOrdersTab(),
//                   PastOrdersTab(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Current Orders Tab
// class CurrentOrdersTab extends StatefulWidget {
//   const CurrentOrdersTab({Key? key}) : super(key: key);

//   @override
//   State<CurrentOrdersTab> createState() => _CurrentOrdersTabState();
// }

// class _CurrentOrdersTabState extends State<CurrentOrdersTab> {
//   final _supabase = Supabase.instance.client;
//   List<Map<String, dynamic>> currentOrders = [];
//   bool isLoading = false;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentOrders();
//   }

//   Future<void> _loadCurrentOrders() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });
//     try {
//       final response = await _supabase
//           .from('orders')
//           .select('''
//             id, date, status, price_total, quantity, type_payment,
//             User:user_id(full_name),
//             delivery(localisation_delivery)
//           ''')
//           .inFilter('status', ['pending', 'processing'])
//           .order('date', ascending: false);

//       setState(() {
//         currentOrders = List<Map<String, dynamic>>.from(response);
//         isLoading = false;
//       });
//     } catch (error) {
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Failed to load orders: $error';
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(errorMessage ?? 'An error occurred')),
//       );
//     }
//   }

//   Future<void> _cancelOrder(int orderId) async {
//     try {
//       await _supabase
//           .from('orders')
//           .update({'status': 'canceled'})
//           .eq('id', orderId);

//       setState(() {
//         currentOrders.removeWhere((order) => order['id'] == orderId);
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Order canceled successfully')),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to cancel order: $error')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (errorMessage != null) {
//       return Center(child: Text(errorMessage!));
//     }
//     if (currentOrders.isEmpty) {
//       return const Center(child: Text('No current orders'));
//     }
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: currentOrders.length,
//       itemBuilder: (context, index) {
//         final order = currentOrders[index];
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 16),
//           child: _buildOrderCard(
//             context,
//             date: DateTime.parse(order['date']).toString().split(' ')[0],
//             orderId: order['id'].toString(),
//             client: order['User']?['full_name'] ?? 'Unknown Client',
//             address:
//                 order['delivery']?['localisation_delivery'] ?? 'No address provided',
//             paymentMethod: order['type_payment'] ?? 'Unknown',
//             amount: '\$${order['price_total']?.toStringAsFixed(2) ?? '0.00'}',
//             status: order['status'] ?? 'Unknown',
//             onCancel: () => _cancelOrder(order['id']),
//           ),
//         );
//       },
//     );
//   }
// }

// // Past Orders Tab
// class PastOrdersTab extends StatefulWidget {
//   const PastOrdersTab({Key? key}) : super(key: key);

//   @override
//   State<PastOrdersTab> createState() => _PastOrdersTabState();
// }

// class _PastOrdersTabState extends State<PastOrdersTab> {
//   final _supabase = Supabase.instance.client;
//   List<Map<String, dynamic>> pastOrders = [];
//   bool isLoading = false;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadPastOrders();
//   }

//   Future<void> _loadPastOrders() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });
//     try {
//       final response = await _supabase
//           .from('orders')
//           .select('''
//             id, date, status, price_total, quantity, type_payment,
//             User:user_id(full_name),
//             delivery(localisation_delivery)
//           ''')
//           .inFilter('status', ['shipped', 'delivered', 'canceled'])
//           .order('date', ascending: false);

//       setState(() {
//         pastOrders = List<Map<String, dynamic>>.from(response);
//         isLoading = false;
//       });
//     } catch (error) {
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Failed to load past orders: $error';
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(errorMessage ?? 'An error occurred')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (errorMessage != null) {
//       return Center(child: Text(errorMessage!));
//     }
//     if (pastOrders.isEmpty) {
//       return const Center(child: Text('No past orders'));
//     }
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: pastOrders.length,
//       itemBuilder: (context, index) {
//         final order = pastOrders[index];
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 16),
//           child: _buildOrderCard(
//             context,
//             date: DateTime.parse(order['date']).toString().split(' ')[0],
//             orderId: order['id'].toString(),
//             client: order['User']?['full_name'] ?? 'Unknown Client',
//             address:
//                 order['delivery']?['localisation_delivery'] ?? 'No address provided',
//             paymentMethod: order['type_payment'] ?? 'Unknown',
//             amount: '\$${order['price_total']?.toStringAsFixed(2) ?? '0.00'}',
//             status: order['status'] ?? 'Unknown',
//           ),
//         );
//       },
//     );
//   }
// }

// // Modified _buildOrderCard widget
// Widget _buildOrderCard(
//   BuildContext context, {
//   required String date,
//   required String orderId,
//   required String client,
//   required String address,
//   required String paymentMethod,
//   required String amount,
//   required String status,
//   VoidCallback? onCancel,
// }) {
//   final bool isPending = status.toLowerCase() == 'pending';
//   final Color statusColor = isPending ? Colors.orange : Colors.green;
//   final IconData statusIcon =
//       isPending ? Icons.access_time : Icons.check_circle;

//   return Card(
//     elevation: 2,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 date,
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//               Row(
//                 children: [
//                   Icon(statusIcon, color: statusColor, size: 16),
//                   const SizedBox(width: 4),
//                   Text(
//                     status,
//                     style: TextStyle(color: statusColor),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Order ID: $orderId',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   client.isNotEmpty ? client[0].toUpperCase() : 'C',
//                   style: const TextStyle(
//                       color: Colors.green, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       client,
//                       style: const TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       address,
//                       style: TextStyle(color: Colors.grey[600], fontSize: 13),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     paymentMethod,
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     amount,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               if (isPending)
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: onCancel,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red[400],
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: const Text('Cancel'),
//                   ),
//                 ),
//               if (isPending) const SizedBox(width: 12),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => OrderDetailsScreen(
//                           orderId: orderId,
//                           isCompleted: status.toLowerCase() == 'delivered',
//                         ),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: const Text('Info'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/pharmacie/dashboard/view/Dashboard.dart';
import 'package:pharmaciyti/features/pharmacie/profil/view/Profile.dart';
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
    // Check authentication and show snackbar after widget is initialized
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Profile()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
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
            id, date, status, price_total, type_payment,
            User:user_id(full_name, status)
            delivery(localisation_delivery)
          ''')
          .inFilter('status', ['pending', 'processing'])
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
          .update({'status': 'canceled'})
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
        final isSelf = order['User']?['role'] != 'self';
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildOrderCard(
            context,
            date: DateTime.parse(order['date']).toString().split(' ')[0],
            orderId: order['id'].toString(),
            pharmacy: order['User']?['full_name'] ?? 'Unknown',
            address: order['delivery']?['localisation_delivery'] ?? 'No address provided',
            paymentMethod: _mapPaymentMethod(order['type_payment'] ?? 'Unknown'),
            amount: '\$${order['price_total']?.toInt() ?? 0}',
            status: _mapStatus(order['status'] ?? 'Unknown'),
            isSelf: isSelf,
            onCancel: isSelf ? null : () => _cancelOrder(order['id']),
          ),
        );
      },
    );
  }

  String _mapPaymentMethod(String typePayment) {
    switch (typePayment.toLowerCase()) {
      case 'cash':
        return 'Pay At Store';
      case 'card':
      case 'online':
        return 'Razorpay';
      default:
        return 'Unknown';
    }
  }

  String _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'processing':
        return 'Pending';
      case 'delivered':
        return 'Completed';
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
            id, date, status, price_total, type_payment,
            User:user_id(full_name, role),
            delivery(localisation_delivery)
          ''')
          .inFilter('status', ['shipped', 'delivered', 'canceled'])
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
        final isSelf = order['User']?['role'] != 'pharmacy';
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildOrderCard(
            context,
            date: DateTime.parse(order['date']).toString().split(' ')[0],
            orderId: order['id'].toString(),
            pharmacy: order['User']?['full_name'] ?? 'Unknown',
            address: order['delivery']?['localisation_delivery'] ?? 'No address provided',
            paymentMethod: _mapPaymentMethod(order['type_payment'] ?? 'Unknown'),
            amount: '\$${order['price_total']?.toInt() ?? 0}',
            status: _mapStatus(order['status'] ?? 'Unknown'),
            isSelf: isSelf,
          ),
        );
      },
    );
  }

  String _mapPaymentMethod(String typePayment) {
    switch (typePayment.toLowerCase()) {
      case 'cash':
        return 'Pay At Store';
      case 'card':
      case 'online':
        return 'Razorpay';
      default:
        return 'Unknown';
    }
  }

  String _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'processing':
        return 'Pending';
      case 'delivered':
        return 'Completed';
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
  required bool isSelf,
  VoidCallback? onCancel,
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