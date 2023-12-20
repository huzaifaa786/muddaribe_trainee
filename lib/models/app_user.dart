// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class AppUser {
  late String id;
  late String userType;
  String? name;
  String? email;
  String? imageUrl;
  AppUser(
      {required this.id,
      this.name,
      this.email,
      required this.userType,
      this.imageUrl});

  AppUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    userType = json['userType'];
    imageUrl = json['profileImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['userType'] = this.userType;

    return data;
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      userType: map['userType'],
      name: map['name'],
      email: map['email'],
      imageUrl: map['profileImageUrl'],
    );
  }
}
