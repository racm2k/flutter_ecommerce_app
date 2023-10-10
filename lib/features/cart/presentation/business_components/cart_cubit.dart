import 'package:app/core/blocs/application_state.dart';
import 'package:app/core/data/models/cart/cart_item_model.dart';
import 'package:app/features/cart/domain/use_cases/cart_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<ApplicationState> {
  final CartUseCase _cartUseCase;

  CartCubit({required CartUseCase cartUseCase})
      : _cartUseCase = cartUseCase,
        super(const CartInitialState());

  void fetchCart() async {
    try {
      emit(const ApplicationLoadingState());
      final items = await _cartUseCase.fetchCart();
      emit(CartFetchSuccessState(items: items));
    } catch (e) {
      emit(const ApplicationApiError(message: 'error fetching cart items'));
    }
  }

  void clearCart() async {
    try {
      emit(const CartClearLoadingState());
      await _cartUseCase.clearCart();
      emit(const CartClearSuccessState());
    } catch (e) {
      emit(
        ApplicationApiError(message: e.runtimeType.toString()),
      );
    }
  }

  void createOrder(List<CartItemModel> cartItems, double totalPrice) async {
    try {
      emit(const CartCreateOrderLoadingState());
      await _cartUseCase.createOrder(cartItems, totalPrice);
      emit(const CartCreateOrderSuccessState());
    } catch (e) {
      emit(
        ApplicationApiError(message: e.runtimeType.toString()),
      );
    }
  }
}
