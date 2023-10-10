import 'package:app/core/blocs/application_state.dart';
import 'package:app/core/blocs/cubit_factory.dart';
import 'package:app/core/components/custom_scaffold.dart';
import 'package:app/core/components/garbo_button.dart';
import 'package:app/core/data/models/cart/cart_item_model.dart';
import 'package:app/core/navigator/application_routes.dart';
import 'package:app/features/payment/presentation/business_components/payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:badges/badges.dart' as badges;

class PaymentUI extends StatefulWidget {
  final List<CartItemModel> items;
  const PaymentUI({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<PaymentUI> createState() => _PaymentUIState();
}

class _PaymentUIState extends State<PaymentUI> {
  final PaymentCubit paymentCubit = CubitFactory.paymentCubit;
  final CardFormEditController controller = CardFormEditController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: CustomScaffold(
        title: 'Pagamento',
        body: BlocConsumer<PaymentCubit, ApplicationState>(
          bloc: paymentCubit,
          listener: (context, state) {
            if (state is PaymentSuccessState) {
              Future.delayed(
                const Duration(seconds: 2),
                () => Navigator.of(context).popUntil((route) =>
                    route.settings.name == ApplicationRoutes.homeScreen),
              );
            }
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case ApplicationLoadingState:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case PaymentSuccessState:
                return Center(
                  child: badges.Badge(
                    ignorePointer: false,
                    badgeContent: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 150,
                    ),
                    badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.circle,
                      badgeColor: Colors.transparent,
                      padding: const EdgeInsets.all(6),
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                      elevation: 0,
                    ),
                  ),
                );
            }

            return Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                CardFormField(
                  style: CardFormStyle(
                    backgroundColor: Colors.grey[800],
                    borderRadius: 8,
                  ),
                  controller: controller,
                ),
                const SizedBox(
                  height: 32,
                ),
                GarboButton(
                    text: 'Pagar',
                    isLoading: state is PaymentLoadingState,
                    onPressed: () {
                      paymentCubit.startPayment(
                          const BillingDetails(email: 'ruben.xb@hotmail.com'),
                          widget.items);
                    })
              ],
            );
          },
        ),
      ),
    );
  }
}
