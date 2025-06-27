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
final String? prescriptionId; // Change to String? to match UUID
  CartItem(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity,
      required this.pharmacy,
      required this.distance,
      this.image,
      required this.isSelected,
      this.prescriptionId // Make it optional but storable
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
        prescriptionId: null // Not applicable for regular medicines    );
        );
  }
}

class CartViewModel extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(Medicine medicine) {
    final existingItemIndex =
        _cartItems.indexWhere((item) => item.id == medicine.id);
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
  void addPrescription(String imageUrl,
      {double price = 0.0, String? prescriptionId, String? pharmacyId}) {
    final uniqueId = prescriptionId ??
        DateTime.now()
            .millisecondsSinceEpoch.toString(); // Use prescription ID if available

    // Remove any existing prescription items
    _cartItems.removeWhere((item) => item.name == 'Uploaded Prescription');

    // Add the new prescription with the Supabase image URL
    final prescription = CartItem(
      id: int.tryParse(uniqueId)?? 0,
      name: 'Uploaded Prescription',
      price: price,
      quantity: 1,
      pharmacy: 'Pharmacy Al Baraka', // Adjust as needed
      distance: 'N/A', // Adjust as needed
      image: imageUrl, // Use the Supabase image URL
      isSelected: true, // Auto-select the prescription
      prescriptionId: prescriptionId, // Store the prescription ID
    );

    _cartItems.add(prescription);
    notifyListeners();
  }

  // Update prescription selection
  void updatePrescriptionSelection(bool value) {
    final prescriptionIndex =
        _cartItems.indexWhere((item) => item.name == 'Uploaded Prescription');
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
