part of 'orders_cubit.dart';

class OrdersInitialState extends ApplicationState {
  const OrdersInitialState();
}

class OrdersFetchLoadingState extends ApplicationState {
  const OrdersFetchLoadingState();
}

class OrdersFetchSuccessState extends ApplicationState {
  final List<OrderModel> orders;
  const OrdersFetchSuccessState({required this.orders});
}
