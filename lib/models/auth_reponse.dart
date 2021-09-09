import 'dart:convert';

import 'package:qr_code_scanner_example/models/user.dart';

AuthResponse authResponseFromMap(String str) =>
    AuthResponse.fromMap(json.decode(str));

String authResponseToMap(AuthResponse data) => json.encode(data.toMap());

class AuthResponse {
  AuthResponse({
    this.user,
    this.token,
    this.message,
  });

  User user;
  String token;
  String message;

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        token: json["token"] == null ? null : json["token"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "user": user == null ? null : user.toMap(),
        "token": token == null ? null : token,
        "message": message == null ? null : message,
      };
}
