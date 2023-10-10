import 'package:app/core/data/models/cart/cart_item_model.dart';
import 'package:app/core/data/repositories/cart/cart_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepositoryImpl implements CartRepository {
  final FirebaseAuth firebaseAuth;

  const CartRepositoryImpl({required this.firebaseAuth});

  @override
  Future<List<CartItemModel>> fetchCart() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      // Handle the case where the user is not authenticated.
      return [];
    }

    final userUID = user.uid;
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('cart');
    final querySnapshot = await cartRef.get();

    List<CartItemModel> cartItems = [];

    for (final doc in querySnapshot.docs) {
      final cartItem = CartItemModel.fromJson(doc.data());
      cartItems.add(cartItem);
    }

    return cartItems;
  }

  @override
  Future<void> clearCart() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      // Handle the case where the user is not authenticated.
      return;
    }

    final userUID = user.uid;
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('cart');
    final querySnapshot = await cartRef.get();

    // Delete all cart item documents.
    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> createOrder(
      List<CartItemModel> cartItems, double totalPrice) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      // Handle the case where the user is not authenticated.
      return;
    }

    final userUID = user.uid;
    final ordersRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('orders');

    // Create a new order document with a unique ID (Firestore generates a unique ID).
    final newOrderRef = await ordersRef.add({
      'orderDate': DateTime.now().toIso8601String(),
      'items': cartItems.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
    });

    // You can optionally store the order ID in your app for reference.
    final newOrderID = newOrderRef.id;

    // Clear the cart after the order has been placed.
    await clearCart();
  }
}
