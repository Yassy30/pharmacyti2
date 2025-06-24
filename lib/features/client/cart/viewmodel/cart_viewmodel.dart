import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/medicine.dart';

class CartItem {
  final int? id;
  final String name;
  final double price;
  int quantity;
  final String pharmacy;
  final String distance;
  final String? image;
  bool isSelected;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.pharmacy,
    required this.distance,
    this.image,
    required this.isSelected,
  });

  factory CartItem.fromMedicine(Medicine medicine) {
    return CartItem(
      id: medicine.id,
      name: medicine.name,
      price: medicine.price,
      quantity: 1,
      pharmacy: 'Pharmacy Al Baraka', // Default pharmacy, adjust as needed
      distance: '1.2 km', // Default distance, adjust as needed
      image: medicine.image,
      isSelected: true,
    );
  }
}

class CartViewModel extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(Medicine medicine) {
    final existingItemIndex = _cartItems.indexWhere((item) => item.id == medicine.id);
    if (existingItemIndex != -1) {
      // Item already exists, increase quantity
      _cartItems[existingItemIndex].quantity++;
    } else {
      // Add new item
      _cartItems.add(CartItem.fromMedicine(medicine));
    }
    notifyListeners();
  }

  void updateQuantity(int id, int newQuantity) {
    final itemIndex = _cartItems.indexWhere((item) => item.id == id);
    if (itemIndex != -1 && newQuantity > 0) {
      _cartItems[itemIndex].quantity = newQuantity;
      notifyListeners();
    }
  }

  void toggleItemSelection(int id) {
    final itemIndex = _cartItems.indexWhere((item) => item.id == id);
    if (itemIndex != -1) {
      _cartItems[itemIndex].isSelected = !_cartItems[itemIndex].isSelected;
      notifyListeners();
    }
  }

  void toggleSelectAll(bool selectAll) {
    for (var item in _cartItems) {
      item.isSelected = selectAll;
    }
    notifyListeners();
  }

  double get subtotal {
    return _cartItems
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get deliveryFee => 10.0;

  double get total => subtotal + deliveryFee;
}