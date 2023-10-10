import 'package:app/core/data/models/order/order_model.dart';

abstract class OrdersRepository {
  Future<List<OrderModel>> getOrders();
}
