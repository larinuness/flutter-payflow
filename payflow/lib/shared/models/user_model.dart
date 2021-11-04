import 'dart:convert';

class UserModel {
  final String? name;
  final String? photoURL;

  UserModel({required this.name, this.photoURL});

  //transforma a classe em um map
  Map<String, dynamic> toMap() => {
        'name': name,
        'photoURL': photoURL,
      };
  //transforma o map em uma string
  //um objeto json
  String toJson() => jsonEncode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      photoURL: map['photoURL'],
    );
  }

  factory UserModel.fromJson(String json) =>
      UserModel.fromMap(jsonDecode(json));
}
