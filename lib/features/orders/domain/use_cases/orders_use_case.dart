import 'package:app/core/data/models/order/order_model.dart';

abstract class OrdersUseCase {
  Future<List<OrderModel>> fetchOrders();
}
