import 'package:app/core/data/models/cart/cart_item_model.dart';

abstract class HomeRepository {
  Future<void> addToCart(CartItemModel cartItemModel);
  Future<int> getCartTotalItems();
}
