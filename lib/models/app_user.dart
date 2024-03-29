// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class AppUser {
  late String id;
  late String userType;
  String? name;
  String? email;
  String? imageUrl;
  String? imageName;
  String? firebaseToken;
  AppUser(
      {required this.id,
      this.name,
      this.email,
      this.imageName,
      required this.userType,
      this.imageUrl,this.firebaseToken,
      });

  AppUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    userType = json['userType'];
    imageUrl = json['profileImageUrl'] ?? '';
    imageName= json['profileImageFileName'] ?? '';
    firebaseToken = json['firebaseToken'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['userType'] = this.userType;
    data['firebaseToken'] = this.firebaseToken;

    return data;
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      userType: map['userType'],
      name: map['name'],
      email: map['email'],
      imageUrl: map['profileImageUrl'] ?? '',
      imageName: map['profileImageFileName']??'',
      firebaseToken: map['firebaseToken'] ?? '',
    );
  }
}
