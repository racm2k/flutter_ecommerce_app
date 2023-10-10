import 'package:app/core/data/models/cart/cart_item_model.dart';

abstract class CartRepository {
  Future<List<CartItemModel>> fetchCart();
  Future<void> clearCart();
  Future<void> createOrder(List<CartItemModel> cartItems, double totalPrice);
}
