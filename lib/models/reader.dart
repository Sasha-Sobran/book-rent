class Reader {
  final int id;
  final String name;
  final String surname;
  final String? phoneNumber;
  final String? address;
  final int? readerCategoryId;
  final String? readerCategoryName;
  final int? userId;
  final String? userEmail;

  Reader({
    required this.id,
    required this.name,
    required this.surname,
    this.phoneNumber,
    this.address,
    this.readerCategoryId,
    this.readerCategoryName,
    this.userId,
    this.userEmail,
  });

  String get fullName => '$surname $name';

  bool get isLinkedToUser => userId != null;

  factory Reader.fromJson(Map<String, dynamic> json) => Reader(
    id: json['id'],
    name: json['name'],
    surname: json['surname'],
    phoneNumber: json['phone_number'],
    address: json['address'],
    readerCategoryId: json['reader_category_id'],
    readerCategoryName: json['reader_category_name'],
    userId: json['user_id'],
    userEmail: json['user_email'],
  );
}

