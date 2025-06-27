class Medicine {
  final int? id;
  final String name;
  final int? categoryId;
  final double price;
  final int quantity;
  final String status;
  final String? image;
  final String? description;
  final bool statusPrescription;
  // final double? rating;

  Medicine({
     this.id,
    required this.name,
    this.categoryId,
    required this.price,
    required this.quantity,
    required this.status,
    this.image,
    this.description,
    required this.statusPrescription,
    // this.rating,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      status: json['status'],
      image: json['image'],
      description: json['description'],
      statusPrescription: json['status_prescription'] ?? false,
      // rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'category_id': categoryId,
      'price': price,
      'quantity': quantity,
      'status': status,
      'image': image,
      'description': description,
      'status_prescription': statusPrescription,
      // 'rating': rating,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}