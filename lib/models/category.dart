// lib/models/category.dart
class Category {
  final String? id;
  final String name;
  final String icon;
  final String color; // Stored as hex color string

  Category({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      color: map['color'],
    );
  }
}
