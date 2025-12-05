class User {
  final int? id;
  final String name;
  final String surname;
  final String email;
  final String role;
  final String? phoneNumber;

  get isAdmin => role == 'admin';
  get isLibrarian => role == 'librarian';
  get isReader => role == 'reader';
  get isRoot => role == 'root';

  User({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.role,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] != null ? json['id'] as int : null,
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      role: json['role'],
      phoneNumber:
          json['phone_number'] != null ? json['phone_number'] as String : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'role': role,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    };
  }
}

class Role {
  final int id;
  final String name;

  Role({required this.id, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(id: json['id'] as int, name: json['name'] as String);
  }
}
