class TrainerPackage {
  late String id;

  String? name;
  String? price;
  String? duration;
  String? discription;
  String? category;
  String? trainerId;

  TrainerPackage({
    required this.id,
    this.name,
    this.price,
    this.duration,
    this.discription,
    this.category,
    this.trainerId
  });

  TrainerPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trainerId = json['trainerId'];
    name = json['name'];
    price = json['price'];
    duration = json['duration'];
    discription = json['discription'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['trainerId'] =trainerId;
    data['name'] = name;
    data['price'] = price;
    data['duration'] = duration;
    data['discription'] = discription;
    data['category'] =category;

    return data;
  }
}
