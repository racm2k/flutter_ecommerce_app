import 'package:app/core/data/models/order/order_model.dart';
import 'package:app/core/data/repositories/orders/orders_repository.dart';

import 'orders_use_case.dart';

class OrdersUseCaseImpl implements OrdersUseCase {
  final OrdersRepository _ordersRepository;

  const OrdersUseCaseImpl({required OrdersRepository ordersRepository})
      : _ordersRepository = ordersRepository,
        super();

  @override
  Future<List<OrderModel>> fetchOrders() async =>
      await _ordersRepository.getOrders();
}
