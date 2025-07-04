import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pharmaciyti/features/auth/viewmodel/user_viewmodel.dart';
import 'package:pharmaciyti/features/client/cart/viewmodel/cart_viewmodel.dart';
import 'package:pharmaciyti/features/client/order/order_confirmation.dart';
import 'package:pharmaciyti/features/client/order/order_repository.dart';
import 'package:pharmaciyti/features/client/payment/view/AddCard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class CheckoutPage extends StatefulWidget {
  final double subtotal;
  final double deliveryFee;
  final List<CartItem> selectedItems;

  const CheckoutPage({
    Key? key,
    required this.subtotal,
    required this.deliveryFee,
    required this.selectedItems,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _paymentMethod = 1; // 0 for Cash on Delivery, 1 for Online Payment
  final _orderRepository = OrderRepository();

  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.fetchUserDetails();
  }
Future<void> _finalizeOrder(CartViewModel cartViewModel) async {
  try {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    // Find the prescription item
    final prescriptionItem = cartViewModel.cartItems.firstWhere(
      (item) => item.name == 'Uploaded Prescription',
      orElse: () => CartItem(
        id: null,
        name: 'No Prescription',
        price: 0.0,
        quantity: 0,
        pharmacy: 'Unknown',
        distance: 'N/A',
        isSelected: false,
        prescriptionId: null,
      ),
    );

    if (prescriptionItem != null ) {
      // Fetch a pharmacy (e.g., nearest or default)
      final pharmacies = await supabase
          .from('User')
          .select('id')
          .eq('role', 'pharmacy')
          .limit(1);
      if (pharmacies.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No pharmacies available')),
        );
        return;
      }
      final pharmacyId = pharmacies[0]['id'] as String;

      // Update prescription_images with pharmacy_id
      await supabase.from('prescription_images').update({
        'pharmacy_user_id': pharmacyId,
      }).eq('id', prescriptionItem.prescriptionId!);

      // Create order
      final orderResponse = await supabase.from('orders').insert({
        'user_id': userId,
        'prescription_image_id': prescriptionItem.prescriptionId,
        'pharmacy_user_id': pharmacyId,
        'total_amount': cartViewModel.total,
        'delivery_fee': cartViewModel.deliveryFee,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
        'payment_method': _paymentMethod == 0 ? 'Cash on Delivery' : 'Online Payment',
      }).select().single();

      print('Order created: ${orderResponse['id']}');

      // Clear cart or selected items after order
      cartViewModel.cartItems.removeWhere((item) => item.isSelected);
      cartViewModel.notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order sent to pharmacy!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationPage(
            orderId: orderResponse['id'] ?? 0,
            estimatedDelivery: '30-45 min',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No valid prescription in cart')),
      );
    }
  } catch (e) {
    print('Error finalizing order: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error processing order')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    final total = widget.subtotal + widget.deliveryFee;
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoSection(userViewModel),
            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
            _buildItemDetailsSection(),
            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
            _buildDeliveryDetailsSection(),
            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
            _buildPaymentMethodsSection(),
            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
            _buildSubtotalSection(total),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () async {
            final userViewModel = Provider.of<UserViewModel>(context, listen: false);
            await userViewModel.fetchUserDetails(); // Force refresh if needed

            final order = Order(
              userName: userViewModel.fullName ?? 'Unknown User',
              userPhone: userViewModel.phoneNumber ?? '+212 695 30 41 87',
              userAddress: userViewModel.address ?? '123 Mohammed V Avenue, Agadir',
              items: widget.selectedItems,
              subtotal: widget.subtotal,
              deliveryFee: widget.deliveryFee,
              total: total,
              paymentMethod: _paymentMethod == 0 ? 'Cash on Delivery' : 'Online Payment',
              pharmacy: widget.selectedItems.isNotEmpty ? widget.selectedItems.first.pharmacy : 'Unknown',
              estimatedDelivery: '30-45 min',
              orderDate: DateTime.now(),
            );

            try {
              // Save the order and get the ID
              final orderId = await _orderRepository.saveOrder(order);
              // Navigate to Order Confirmation with the actual orderId
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderConfirmationPage(
                    orderId: orderId, // Use the actual ID returned from saveOrder
                    estimatedDelivery: order.estimatedDelivery,
                  ),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to save order: $e')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Confirm',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(UserViewModel userViewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person, color: Colors.grey),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userViewModel.fullName ?? 'Unknown User',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      userViewModel.phoneNumber ?? '+212 695 30 41 87',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      userViewModel.address ?? '123 Mohammed V Avenue, Agadir',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.edit, color: Colors.grey, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Item Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'View details',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...widget.selectedItems.map((item) {
            if (item.name == 'Uploaded Prescription') {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uploaded Prescription',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Image.asset(
                              item.image ?? 'assets/images/eclo_ointment.jpeg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            // Inside the Container for Uploaded prescription in checkout.dart
                            child: Image.network(
                              item.image ?? 'assets/images/eclo_ointment.jpeg',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                'assets/images/eclo_ointment.jpeg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: item.image != null
                        ? Image.network(
                            item.image!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/a_gen_cream.jpeg',
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image.asset(
                            'assets/images/a_gen_cream.jpeg',
                            fit: BoxFit.contain,
                          ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${item.price.toStringAsFixed(0)} MAD x ${item.quantity}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDeliveryDetailsSection() {
    final pharmacy = widget.selectedItems.isNotEmpty ? widget.selectedItems.first.pharmacy : 'Unknown';
    final distance = widget.selectedItems.isNotEmpty ? widget.selectedItems.first.distance : 'N/A';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pharmacy:', style: TextStyle(color: Colors.grey)),
              Text(pharmacy, style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Distance:', style: TextStyle(color: Colors.grey)),
              Text(distance, style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Estimated Delivery:', style: TextStyle(color: Colors.grey)),
              Text('30-45 min', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Fee:', style: TextStyle(color: Colors.grey)),
              Text('${widget.deliveryFee.toStringAsFixed(0)} MAD', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Methods',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          RadioListTile<int>(
            title: Text('Cash on Delivery'),
            value: 0,
            groupValue: _paymentMethod,
            onChanged: (value) => setState(() => _paymentMethod = value!),
            contentPadding: EdgeInsets.zero,
            activeColor: Colors.blue,
          ),
          RadioListTile<int>(
            title: Row(
              children: [
                Text('Online Payment'),
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCardPage()),
                    );
                  },
                  child: Text('+ Add a new card'),
                ),
              ],
            ),
            value: 1,
            groupValue: _paymentMethod,
            onChanged: (value) => setState(() => _paymentMethod = value!),
            contentPadding: EdgeInsets.zero,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildSubtotalSection(double total) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal:', style: TextStyle(color: Colors.grey)),
              Text('${widget.subtotal.toStringAsFixed(0)} MAD', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Fee:', style: TextStyle(color: Colors.grey)),
              Text('${widget.deliveryFee.toStringAsFixed(0)} MAD', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${total.toStringAsFixed(0)} MAD',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}