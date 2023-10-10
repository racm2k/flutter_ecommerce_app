part of 'cart_cubit.dart';

class CartInitialState extends ApplicationState {
  const CartInitialState();
}

class CartFetchSuccessState extends ApplicationState {
  final List<CartItemModel>? items;
  const CartFetchSuccessState({this.items});
}

class CartClearLoadingState extends ApplicationState {
  const CartClearLoadingState();
}

class CartClearSuccessState extends ApplicationState {
  const CartClearSuccessState();
}

class CartCreateOrderLoadingState extends ApplicationState {
  const CartCreateOrderLoadingState();
}

class CartCreateOrderSuccessState extends ApplicationState {
  const CartCreateOrderSuccessState();
}
