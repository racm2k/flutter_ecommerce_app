import 'dart:convert';
import 'dart:developer';

import 'package:app/core/blocs/application_state.dart';
import 'package:app/core/data/models/cart/cart_item_model.dart';
import 'package:app/features/cart/domain/use_cases/cart_use_case.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'payment_state.dart';

class PaymentCubit extends Cubit<ApplicationState> {
  final CartUseCase _cartUseCase;
  PaymentCubit({required CartUseCase cartUseCase})
      : _cartUseCase = cartUseCase,
        super(const PaymentInitialState());

  _calculateOrderAmount(List<CartItemModel> items) {
    double amount = 0.0;
    for (var element in items) {
      amount += (element.quantity * element.item.price);
    }
    return amount;
  }

  Future<void> startPayment(
      BillingDetails billingDetails, List<CartItemModel> items) async {
    try {
      emit(const PaymentLoadingState());

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );

      final paymentIntentResult = await _callPayEndpointMethodId(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'eur',
        items: items,
      );

      if (paymentIntentResult['status'] == 'succeeded') {
        emit(const PaymentSuccessState());
        _cartUseCase.createOrder(items, _calculateOrderAmount(items));
        _cartUseCase.clearCart();
      }

      if (paymentIntentResult['error'] != null) {
        // Error creating or confirming the payment intent.
        emit(const PaymentFailureState());
      }

      if (paymentIntentResult['client_secret'] != null &&
          paymentIntentResult['next_action'] == null) {
        // The payment succeeded / went through.
        emit(const PaymentSuccessState());
        _cartUseCase.createOrder(items, _calculateOrderAmount(items));
        _cartUseCase.clearCart();
      }

      if (paymentIntentResult['client_secret'] != null &&
          paymentIntentResult['next_action'] == true) {
        final String clientSecret = paymentIntentResult['client_secret'];
        confirmPaymentIntent(clientSecret);
      } else {}
    } catch (e) {
      emit(const PaymentFailureState());
    }
  }

  Future<void> confirmPaymentIntent(String clientSecret) async {
    try {
      final paymentIntent =
          await Stripe.instance.handleNextAction(clientSecret);

      if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
        // Call API to confirm intent
        final results =
            await _callPayEndpointIntentId(paymentIntentId: paymentIntent.id);

        if (results['error'] != null) {
          emit(const PaymentFailureState());
        } else {
          emit(const PaymentSuccessState());
        }
      }
    } catch (err) {
      print(err);
      emit(const PaymentFailureState());
    }
  }

  Future<Map<String, dynamic>> _callPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    List<CartItemModel>? items,
  }) async {
    final url = Uri.parse(
      'https://us-central1-garbo-dcb3a.cloudfunctions.net/StripePayEndpointMethodId',
    );
    final body = json.encode({
      'useStripeSdk': useStripeSdk,
      'paymentMethodId': paymentMethodId,
      'currency': currency,
      'items': items,
    });
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> _callPayEndpointIntentId({
    required String paymentIntentId,
  }) async {
    final url = Uri.parse(
      'https://us-central1-garbo-dcb3a.cloudfunctions.net/StripePayEndpointIntentId',
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'paymentIntentId': paymentIntentId,
      }),
    );
    return json.decode(response.body);
  }
}
