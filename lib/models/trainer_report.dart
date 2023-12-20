
import 'package:mudarribe_trainee/enums/enums.dart';

class TraineeReport {
  late String id;

  String? title;

  String? traineeId;
  String? imageFileName;
  String? imageUrl;
  

  TraineeReport({
    required this.id,
    this.title,
  
    this.imageUrl,
    this.traineeId,
    this.imageFileName,
  });

  TraineeReport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  
    traineeId = json['traineeId'];
   
    imageFileName = json['imageFileName'];
    imageUrl = json['imageUrl'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['traineeId'] = traineeId;
    data['title'] = title;
   
    data['imageFileName'] = imageFileName;
    data['imageUrl'] = imageUrl;
  
    return data;
  }
}

