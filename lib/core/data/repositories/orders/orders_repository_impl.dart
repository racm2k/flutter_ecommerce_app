import 'package:app/core/data/models/cart/cart_item_model.dart';
import 'package:app/core/data/models/order/order_model.dart';
import 'package:app/core/data/repositories/orders/orders_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final FirebaseAuth _firebaseAuth;

  const OrdersRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth,
        super();

  @override
  Future<List<OrderModel>> getOrders() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      // Handle the case where the user is not authenticated.
      return [];
    }

    final userUID = user.uid;
    final ordersRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('orders');

    final querySnapshot = await ordersRef.get();

    List<OrderModel> orders = [];

    for (final doc in querySnapshot.docs) {
      final orderId=doc.id;
      final orderData=doc.data();
      var order = OrderModel.fromJson(orderData);
      order.orderId=orderId;
      orders.add(order);
    }

    return orders;
  }
}
