import 'package:library_kursach/models/user.dart';

class AppState {
  final bool isLoggedIn;
  final String? token;
  final String? refreshToken;
  final User? user;
  
  AppState({
    required this.isLoggedIn,
    this.token,
    this.refreshToken,
    this.user,
  });

  copyWith({
    bool? isLoggedIn,
    String? token,
    String? refreshToken,
    User? user,
  }) {
    return AppState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }

  factory AppState.fromJson(Map<String, dynamic> json) {
    return AppState(
      isLoggedIn: json['isLoggedIn'] ?? false,
      token: json['token'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isLoggedIn': isLoggedIn,
      'token': token,
      'refreshToken': refreshToken,
    };
  }
}
