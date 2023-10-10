import 'package:app/core/data/models/cart/cart_item_model.dart';
import 'package:app/core/data/repositories/cart/cart_repository.dart';

import 'cart_use_case.dart';

class CartUseCaseImpl implements CartUseCase {
  final CartRepository cartRepository;
  const CartUseCaseImpl({required this.cartRepository});
  @override
  Future<List<CartItemModel>> fetchCart() async =>
      await cartRepository.fetchCart();

  @override
  Future<void> clearCart() async => await cartRepository.clearCart();

  @override
  Future<void> createOrder(
          List<CartItemModel> cartItems, double totalPrice) async =>
      await cartRepository.createOrder(cartItems, totalPrice);
}
