import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardViewModel with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  // Dashboard data
  int _totalOrders = 0;
  int _completedOrders = 0;
  int _pendingOrders = 0;
  int _inProgressOrders = 0;

  // Loading states
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  int get totalOrders => _totalOrders;
  int get completedOrders => _completedOrders;
  int get pendingOrders => _pendingOrders;
  int get inProgressOrders => _inProgressOrders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Check if user is authenticated
  bool get isAuthenticated => _client.auth.currentUser != null;
  String? get currentUserId => _client.auth.currentUser?.id;

  Future<void> fetchDashboardData() async {
    if (!isAuthenticated) {
      _errorMessage = 'No authenticated user found';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Get all order IDs that have deliveries (all delivery orders)
      final deliveryResponse =
          await _client.from('delivery').select('order_id');

      if (deliveryResponse.isEmpty) {
        _totalOrders = 0;
        _completedOrders = 0;
        _pendingOrders = 0;
        _inProgressOrders = 0;
      } else {
        // Extract all order IDs from delivery table
        final orderIds =
            deliveryResponse.map((d) => d['order_id'] as int).toList();

        //     // Fetch orders data for all delivery order IDs using .in_()
        //     final ordersResponse = await _client
        //         .from('orders')
        //         .select('id, statut')
        //         .in_('id', orderIds);

        //     // Calculate statistics for all delivery orders
        //     _totalOrders = ordersResponse.length;
        //     _completedOrders = ordersResponse.where((order) =>
        //         order['statut'] == 'delivered' || order['statut'] == 'completed').length;
        //     _pendingOrders = ordersResponse.where((order) =>
        //         order['statut'] == 'pending').length;
        //     _inProgressOrders = ordersResponse.where((order) =>
        //         order['statut'] == 'in_progress' || order['statut'] == 'out_for_delivery').length;
        //   }

        //   if (kDebugMode) {
        //     print('Dashboard data fetched successfully (All deliveries)');
        //     print('Total delivery orders: $_totalOrders');
        //     print('Completed orders: $_completedOrders');
        //     print('Pending orders: $_pendingOrders');
        //     print('In progress orders: $_inProgressOrders');
        //   }
        // } on PostgrestException catch (e) {
        //   _errorMessage = 'Database error: ${e.message}';
        //   if (kDebugMode) print('PostgrestException: ${e.message}');
        // } catch (e) {
        //   _errorMessage = 'Failed to fetch dashboard data: ${e.toString()}';
        //   if (kDebugMode) print('Dashboard fetch error: $e');
        // } finally {
        //   _isLoading = false;
        //   notifyListeners();
        // }
      }
    } catch (e) {
      print(e);
    }
  }

  // Refresh dashboard data
  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }

  // Reset dashboard data
  void resetDashboardData() {
    _totalOrders = 0;
    _completedOrders = 0;
    _pendingOrders = 0;
    _inProgressOrders = 0;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
