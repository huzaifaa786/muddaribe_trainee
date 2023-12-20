
import 'package:mudarribe_trainee/enums/enums.dart';

class PlanFile {
  late String id;
  String? planId;
  String? fileUrl;
  String? fileName;
  FileType? fileType;
  String? FileId;

  PlanFile({
    required this.id,
    this.planId,
    this.fileType,
    this.fileName,
    this.fileUrl,
    this.FileId,
  });

  PlanFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planId = json['planId'];
    fileUrl = json['fileUrl'];
    fileName = json['fileName'];
    FileId = json['FileId'];

    fileType = _$enumDecode(_$FileTypeEnumMap, json['fileType']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['planId'] = planId;
    data['fileUrl'] = fileUrl;
    data['fileName'] = fileName;
    data['FileId']= FileId;

    data['fileType'] = _$FileTypeEnumMap[fileType];

    return data;
  }
}

const _$FileTypeEnumMap = {
  FileType.mp4: 'mp4',
  FileType.pdf: 'pdf',
};
_$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}
