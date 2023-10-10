import 'package:app/core/blocs/application_state.dart';
import 'package:app/core/blocs/cubit_factory.dart';
import 'package:app/core/components/custom_scaffold.dart';
import 'package:app/core/components/garbo_button.dart';
import 'package:app/core/data/models/cart/cart_item_model.dart';
import 'package:app/core/navigator/application_routes.dart';
import 'package:app/features/cart/presentation/business_components/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartUI extends StatefulWidget {
  const CartUI({Key? key}) : super(key: key);

  @override
  State<CartUI> createState() => _CartUIState();
}

class _CartUIState extends State<CartUI> {
  final cartCubit = CubitFactory.cartCubit;
  List<CartItemModel>? cartItems = [];

  @override
  void initState() {
    cartCubit.fetchCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Carrinho',
      body: BlocConsumer<CartCubit, ApplicationState>(
        bloc: cartCubit,
        listener: (context, state) {
          if (state is CartCreateOrderSuccessState) {}
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case ApplicationLoadingState:
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.amber[800],
                ),
              );
            case CartFetchSuccessState:
              cartItems = (state as CartFetchSuccessState).items;
              if (cartItems!.isEmpty) {
                return const Center(
                  child: Text('Carrinho vazio!'),
                );
              } else {
                return _buildSuccessState();
              }
            case ApplicationApiError:
              return _buildApiErrorState();
          }

          return const Center(
            child: Text('Carrinho vazio!'),
          );
        },
      ),
    );
  }

  double getTotalCartAmount() {
    double totalCartAmount = 0.0;
    for (var element in cartItems!) {
      totalCartAmount += (element.item.price * element.quantity);
    }
    return totalCartAmount;
  }

  Widget _buildSuccessState() {
    final totalCartAmount = getTotalCartAmount();
    final totalCartAmountPlusTax = totalCartAmount + (totalCartAmount * 0.23);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        ListTile(
          title: const Text('Carrinho de Compras'),
          subtitle:
              const Text('Verifique o carrinho antes de finalizar a compra'),
          leading: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.amber[800],
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cartItems!.length,
            itemBuilder: (context, index) {
              final item = cartItems![index];
              final totalItemAmount = item.quantity * item.item.price;
              return ListTile(
                title: Text(item.item.name),
                leading: Image.asset(item.item.image),
                trailing: Text(item.quantity.toString()),
                subtitle: Text('${totalItemAmount.toStringAsFixed(2)}€'),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal'),
            Text('${totalCartAmount.toStringAsFixed(2)}€')
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('IVA(23%)'),
            Text('${totalCartAmountPlusTax.toStringAsFixed(2)}€')
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: GarboButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ApplicationRoutes.paymentScreen,
                  arguments: cartItems);
            },
            text: 'Pagamento',
          ),
        ),
      ],
    );
  }

  Widget _buildApiErrorState() {
    return Center(
      child: Column(
        children: [
          const Text('Erro ao buscar o carrinho.'),
          ElevatedButton(
            onPressed: () {
              cartCubit.fetchCart();
            },
            child: const Text('Tentar de novo'),
          ),
        ],
      ),
    );
  }
}
