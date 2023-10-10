import 'package:json_annotation/json_annotation.dart';

part 'item_model.g.dart';

@JsonSerializable()
class Item {
  final String id;
  final String name;
  final String image;
  final double price;
  Item(
      {required this.id,
      required this.name,
      required this.image,
      required this.price});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
