class Category {
  final int? id;
  final String name;
  final String status;
  final String? image;

  Category({
    this.id,
    required this.name,
    required this.status,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'image': image,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int?,
      name: json['name'] as String,
      status: json['status'] as String,
      image: json['image'] as String?,
    );
  }

  @override
  String toString() => 'Category(id: $id, name: $name, status: $status, image: $image)';
}