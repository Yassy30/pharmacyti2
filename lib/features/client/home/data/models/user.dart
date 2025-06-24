// user.dart
class User {
  final String id;
  final String fullName;
  final String? address;
  final String? imageProfile;

  User({
    required this.id,
    required this.fullName,
    this.address,
    this.imageProfile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? 'Unknown User',
      address: json['address']?.toString(),
      imageProfile: json['image_profile']?.toString(),
    );
  }

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, address: $address, imageProfile: $imageProfile)';
  }
}