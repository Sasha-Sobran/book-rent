class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
    id: json['id'],
    name: json['name'],
  );
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
  );
}

class ReaderCategory {
  final int id;
  final String name;
  final int discountPercentage;

  ReaderCategory({required this.id, required this.name, required this.discountPercentage});

  factory ReaderCategory.fromJson(Map<String, dynamic> json) => ReaderCategory(
    id: json['id'],
    name: json['name'],
    discountPercentage: json['discount_percentage'],
  );
}

class PenaltyType {
  final int id;
  final String name;

  PenaltyType({required this.id, required this.name});

  factory PenaltyType.fromJson(Map<String, dynamic> json) => PenaltyType(
    id: json['id'],
    name: json['name'],
  );
}

