import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String id;
  String username;
  String name;
  String role;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        username: json["username"],
        name: json["name"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "name": name,
        "role": role,
      };
}
