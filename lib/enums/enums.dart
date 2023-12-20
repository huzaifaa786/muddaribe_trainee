import 'package:json_annotation/json_annotation.dart';
enum TrainerStatus {
  @JsonValue(0)
  rejected,
  @JsonValue(1)
  pending,
  @JsonValue(2)
  approved
}

enum MediaType {
  @JsonValue('image')
  image,
  @JsonValue('video')
  video
}

enum ReportType {
  @JsonValue('paid')
  paid,
  @JsonValue('free')
  free
}

enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('paid')
  paid
}

enum ReportStatus {
  @JsonValue('open')
  open,
  @JsonValue('closed')
  closed
}