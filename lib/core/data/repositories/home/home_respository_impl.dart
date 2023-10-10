import 'package:app/core/data/models/cart/cart_item_model.dart';
import 'package:app/core/data/repositories/home/home_respository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeRepositoryImpl implements HomeRepository {
  final FirebaseAuth firebaseAuth;
  const HomeRepositoryImpl({required this.firebaseAuth});

  @override
  Future<void> addToCart(CartItemModel cartItemModel) async {
    final userId = firebaseAuth.currentUser!.uid;
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');
    final cartItemSnapshot = await cartRef.doc(cartItemModel.item.id).get();
    if (cartItemSnapshot.exists) {
      // Cart item already exists, update the quantity.
      final currentQuantity = cartItemSnapshot.data()?['quantity'] ?? 0;
      await cartRef
          .doc(cartItemModel.item.id)
          .update({'quantity': currentQuantity + 1});
    } else {
      // Cart item does not exist, create a new document.
      await cartRef.doc(cartItemModel.item.id).set(cartItemModel.toJson());
    }
  }

  @override
  Future<int> getCartTotalItems() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle the case where the user is not authenticated.
      return 0;
    }

    final userUID = user.uid;
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('cart');
    final querySnapshot = await cartRef.get();

    var totalItems = 0;

    for (final doc in querySnapshot.docs) {
      var cartItem = CartItemModel.fromJson(doc.data());
      totalItems += cartItem.quantity;
    }

    return totalItems;
  }
}
