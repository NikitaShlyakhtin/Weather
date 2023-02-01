import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Location {
  final double lat;
  final double lon;

  Location({required this.lat, required this.lon});
}
