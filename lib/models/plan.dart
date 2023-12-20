class Plan {
  late String id;
  String? name;
  String? file;
  String? category;
  String? trainerId;
  String? description;

  Plan(
      {required this.id,
      this.name,
      this.file,
      this.category,
      this.trainerId,
      this.description});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trainerId = json['trainerId'];
    name = json['name'];
    file = json['file'];
    category = json['category'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['trainerId'] = trainerId;
    data['name'] = name;
    data['file'] = file;
    data['category'] = category;
    data['description'] = description;

    return data;
  }
}
