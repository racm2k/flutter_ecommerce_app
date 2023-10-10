import 'package:app/core/data/models/item/item_model.dart';

abstract class HomeUseCase {
  Future<void> addToCart(Item item);
  Future<int> getCartTotalItems();
}
