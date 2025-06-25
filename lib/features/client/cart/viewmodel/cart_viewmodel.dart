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

  // Add prescription as a CartItem
  void addPrescription(String imagePath, {double price = 0.0}) {
    final prescriptionId = DateTime.now().millisecondsSinceEpoch; // Unique ID
    if (!_cartItems.any((item) => item.name == 'Uploaded Prescription')) {
      final prescription = CartItem(
        id: prescriptionId,
        name: 'Uploaded Prescription',
        price: price,
        quantity: 1,
        pharmacy: 'Pharmacy Al Baraka', // Adjust as needed
        distance: 'N/A', // Adjust as needed
        image: imagePath,
        isSelected: false,
      );
      _cartItems.add(prescription);
      notifyListeners();
    }
  }

  // Update prescription selection
  void updatePrescriptionSelection(bool value) {
    final prescriptionIndex = _cartItems.indexWhere((item) => item.name == 'Uploaded Prescription');
    if (prescriptionIndex != -1) {
      _cartItems[prescriptionIndex].isSelected = value;
      notifyListeners();
    }
  }

  double get subtotal {
    return _cartItems
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get deliveryFee => 10.0;

  double get total => subtotal + deliveryFee;
}