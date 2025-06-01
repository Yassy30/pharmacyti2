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

  // Convert Category to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status.toLowerCase(), // Ensure it matches the enum in the database ('available' or 'out_of_stock')
      'image': image,
    };
  }

  // Create a Category from JSON (from Supabase response)
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      image: json['image'],
    );
  }
}