import 'dart:convert';

User userFromMap(String str) => User.fromMap(json.decode(str));

String userToMap(User data) => json.encode(data.toMap());

class User {
  User({
    this.name,
    this.email,
    this.photo,
    this.message,
    this.id,
  });

  String name;
  String email;
  String photo;
  String message;
  int id;

  factory User.fromMap(Map<String, dynamic> json) => User(
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    photo: json["photo"] == null ? null : json["photo"],
    message: json["message"] == null ? null : json["message"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "photo": photo == null ? null : photo,
    "message": message == null ? null : message,
    "id": id == null ? null : id,
  };
}
