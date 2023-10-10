import 'package:app/core/data/models/cart/cart_item_model.dart';
import 'package:app/core/data/models/item/item_model.dart';
import 'package:app/core/data/repositories/home/home_respository.dart';
import 'package:app/features/home/domain/use_cases/home_use_case.dart';

class HomeUseCaseImpl implements HomeUseCase {
  final HomeRepository homeRepository;

  const HomeUseCaseImpl({required this.homeRepository});

  @override
  Future<void> addToCart(Item item) async {
    final CartItemModel cartItem = CartItemModel(
        item: Item(
            id: item.id,
            name: item.name,
            image: item.image,
            price: item.price));
    await homeRepository.addToCart(cartItem);
  }

  @override
  Future<int> getCartTotalItems() async =>
      await homeRepository.getCartTotalItems();
}
