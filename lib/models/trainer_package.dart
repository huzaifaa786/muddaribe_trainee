class TrainerPackage {
  late String id;

  String? name;
  String? price;
  String? duration;
  String? discription;
  String? category;
  String? trainerId;
  String? image1;
  String? image2;

  TrainerPackage(
      {required this.id,
      this.name,
      this.price,
      this.duration,
      this.discription,
      this.category,
      this.trainerId,
      this.image1,
      this.image2});

  TrainerPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trainerId = json['trainerId'];
    name = json['name'];
    price = json['price'];
    duration = json['duration'] ?? '';
    discription = json['discription'] ?? '';
    category = json['category'];
    image1 = json['image1'] ?? '';
    image2 = json['image2'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['trainerId'] = trainerId;
    data['name'] = name;
    data['price'] = price;
    data['duration'] = duration;
    data['discription'] = discription;
    data['category'] = category;
    data['image1'] = image1;
    data['image2'] = image2;

    return data;
  }
}
