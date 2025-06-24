class Pharmacy {
  final String id;
  final String name;
  final String? address;
  final String? phoneNumber;
  final double? rating;
  final bool? isOpen;

  Pharmacy({
    required this.id,
    required this.name,
    this.address,
    this.phoneNumber,
    this.rating,
    this.isOpen,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id']?.toString() ?? '',
      name: json['full_name']?.toString() ?? 'Unknown Pharmacy',
      address: json['address']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      rating: (json['rating'] as num?)?.toDouble(),
      isOpen: json['is_open'] as bool?,
    );
  }

  @override
  String toString() {
    return 'Pharmacy(id: $id, name: $name, address: $address, phoneNumber: $phoneNumber, rating: $rating, isOpen: $isOpen)';
  }
}