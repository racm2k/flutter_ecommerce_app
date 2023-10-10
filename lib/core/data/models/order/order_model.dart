import 'package:app/core/data/models/cart/cart_item_model.dart';
import 'package:app/core/utils/timestamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
   String? orderId; // Unique ID for the order
  @DateConverter()
  late final DateTime orderDate; // Date and time when the order was placed
  final List<CartItemModel> items; // List of items in the order
  final double totalPrice; // Total price of the order

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.items,
    required this.totalPrice,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
