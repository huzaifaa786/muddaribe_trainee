class TrainerOrder {
  late String id;
  String? trainerId;
  String? planId;
  String? userId;
  String? type;
  int? amount;

  TrainerOrder({
    required this.id,
    this.trainerId,
    this.planId,
    this.type,
    this.userId,
    required this.amount,
  });

  TrainerOrder.fromJson(Map<String, dynamic> json) {
    id = json['orderId'];
    trainerId = json['trainerId'];
    planId = json['planId'];
    type = json['type'];
    userId = json['userId'];
    amount= json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['orderId'] = id;
    data['trainerId'] = trainerId;
    data['planId'] = planId;
    data['type'] = type;
    data['userId'] = userId;
    data['amount'] = amount;
    return data;
  }
}
