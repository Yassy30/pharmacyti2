import 'package:flutter/material.dart';
import 'checkout.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Sample data for cart items
  List<CartItem> cartItems = [
    CartItem(
      id: 1,
      name: 'Doliprane 500mg',
      price: 22.00,
      quantity: 1,
      pharmacy: 'Pharmacy Al Baraka',
      distance: '1.2 km',
      image: 'assets/images/a_gen_cream.jpeg',
      isSelected: true,
    ),
    CartItem(
      id: 2,
      name: 'Vitamin C',
      price: 85.00,
      quantity: 1,
      pharmacy: 'Pharmacy Al Baraka',
      distance: '1.2 km',
      image: 'assets/images/a_gen_cream.jpeg',
      isSelected: true,
    ),
    CartItem(
      id: 3,
      name: 'Doliprane 500mg',
      price: 22.00,
      quantity: 1,
      pharmacy: 'Pharmacy Al Baraka',
      distance: '1.2 km',
      image: 'assets/images/a_gen_cream.jpeg',
      isSelected: false,
    ),
  ];

  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    _updateSelectAll();
  }

  void _updateSelectAll() {
    selectAll = cartItems.every((item) => item.isSelected);
  }

  double get subtotal {
    return cartItems
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get deliveryFee {
    return 10.0; // Fixed delivery fee
  }

  double get total {
    return subtotal + deliveryFee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Your cart',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  'All',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                Checkbox(
                  value: selectAll,
                  onChanged: (value) {
                    setState(() {
                      selectAll = value ?? false;
                      for (var item in cartItems) {
                        item.isSelected = selectAll;
                      }
                    });
                  },
                  activeColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                // Prescription section
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Uploaded perscription',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Checkbox(
                            value: false,
                            onChanged: (value) {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
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
                                'assets/images/eclo_ointment.jpeg',
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
                              child: Image.asset(
                                'assets/images/eclo_ointment.jpeg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Cart items
                ...cartItems.map((item) => _buildCartItem(item)).toList(),
              ],
            ),
          ),
          
          // Bottom total and checkout section
          Container(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${total.toStringAsFixed(0)} MAD',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Livraison: ${deliveryFee.toStringAsFixed(0)} MAD',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                          subtotal: subtotal,
                          deliveryFee: deliveryFee,
                          selectedItems: cartItems.where((item) => item.isSelected).toList(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Checkbox(
              value: item.isSelected,
              onChanged: (value) {
                setState(() {
                  item.isSelected = value ?? false;
                  _updateSelectAll();
                });
              },
              activeColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          
          // Product image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Image.asset(
              item.image,
              fit: BoxFit.contain,
            ),
          ),
          
          SizedBox(width: 12),
          
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Available at: ${item.pharmacy} - ${item.distance}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.price.toStringAsFixed(0)} MAD',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        _buildQuantityButton(
                          icon: Icons.remove,
                          onPressed: () {
                            if (item.quantity > 1) {
                              setState(() {
                                item.quantity--;
                              });
                            }
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '${item.quantity}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildQuantityButton(
                          icon: Icons.add,
                          onPressed: () {
                            setState(() {
                              item.quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 16),
        onPressed: onPressed,
      ),
    );
  }
}


class CartItem {
  final int id;
  final String name;
  final double price;
  int quantity;
  final String pharmacy;
  final String distance;
  final String image;
  bool isSelected;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.pharmacy,
    required this.distance,
    required this.image,
    required this.isSelected,
  });
}
