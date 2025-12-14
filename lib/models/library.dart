class Library {
  final int id;
  final String name;
  final int cityId;
  final String? cityName;
  final String address;
  final String phoneNumber;

  Library({
    required this.id,
    required this.name,
    required this.cityId,
    this.cityName,
    required this.address,
    required this.phoneNumber,
  });

  factory Library.fromJson(Map<String, dynamic> json) {
    return Library(
      id: json['id'],
      name: json['name'],
      cityId: json['city_id'],
      cityName: json['city_name'],
      address: json['address'],
      phoneNumber: json['phone_number'],
    );
  }
}

