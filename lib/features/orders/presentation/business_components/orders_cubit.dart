import 'package:app/core/blocs/application_state.dart';
import 'package:app/core/data/models/order/order_model.dart';
import 'package:app/features/orders/domain/use_cases/orders_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<ApplicationState> {
  final OrdersUseCase _ordersUseCase;
  OrdersCubit({required OrdersUseCase ordersUseCase})
      : _ordersUseCase = ordersUseCase,
        super(const OrdersInitialState());

  void fetchOrders() async {
    try {
      emit(const OrdersFetchLoadingState());
      final orders = await _ordersUseCase.fetchOrders();
      emit(OrdersFetchSuccessState(orders: orders));
    } catch (e) {
      print(e);
      emit(ApplicationApiError(message: e.toString()));
    }
  }
}
