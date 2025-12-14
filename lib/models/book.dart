class Book {
  final int id;
  final String title;
  final String author;
  final double price;
  final String publishYear;
  final int quantity;
  final int libraryId;
  final String? libraryName;
  final String? libraryCityName;
  final String? imageUrl;
  final List<String> categories;
  final List<String> genres;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.publishYear,
    required this.quantity,
    required this.libraryId,
    this.libraryName,
    this.libraryCityName,
    this.imageUrl,
    this.categories = const [],
    this.genres = const [],
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      price: (json['price'] as num).toDouble(),
      publishYear: json['publish_year'],
      quantity: json['quantity'],
      libraryId: json['library_id'],
      libraryName: json['library_name'],
      libraryCityName: json['library_city_name'],
      imageUrl: json['image_url'],
      categories: (json['categories'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      genres: (json['genres'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'price': price,
      'publish_year': publishYear,
      'quantity': quantity,
      'library_id': libraryId,
      if (libraryName != null) 'library_name': libraryName,
      if (libraryCityName != null) 'library_city_name': libraryCityName,
      if (imageUrl != null) 'image_url': imageUrl,
      'categories': categories,
      'genres': genres,
    };
  }
}