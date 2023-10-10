import 'package:app/core/blocs/application_state.dart';
import 'package:app/core/blocs/cubit_factory.dart';
import 'package:app/core/components/custom_scaffold.dart';
import 'package:app/core/data/models/order/order_model.dart';
import 'package:app/features/orders/presentation/business_components/orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersUI extends StatefulWidget {
  const OrdersUI({Key? key}) : super(key: key);

  @override
  State<OrdersUI> createState() => _OrdersUIState();
}

class _OrdersUIState extends State<OrdersUI> {
  final OrdersCubit _ordersCubit = CubitFactory.ordersCubit;
  List<OrderModel> orders = [];

  @override
  void initState() {
    _ordersCubit.fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: 'Encomendas',
        body: BlocConsumer(
          bloc: _ordersCubit,
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.runtimeType) {
              case OrdersFetchLoadingState:
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber[800],
                  ),
                );
              case OrdersFetchSuccessState:
                orders = (state as OrdersFetchSuccessState).orders;
                return _buildSuccessState();
              case ApplicationApiError:
                return _buildApiErrorState();
            }

            return const Center(
              child: Text('Realiza primeiro uma encomenda para aparecer aqui.'),
            );
          },
        ));
  }

  Widget _buildApiErrorState() {
    return Center(
      child: Column(
        children: [
          const Text('Erro ao buscar as encomendas.'),
          ElevatedButton(
            onPressed: () {
              _ordersCubit.fetchOrders();
            },
            child: const Text('Tentar de novo'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    if(orders.isEmpty){
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.local_shipping_outlined,size: 100,color: Colors.grey,),
          Text('Sem encomendas efetuadas.',textAlign: TextAlign.center,),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final item = orders[index];
              return ListTile(
                title: Text('#${item.orderId??''}',overflow: TextOverflow.ellipsis),
                leading: Icon(
                  Icons.local_shipping,
                  color: Colors.amber[800],
                ),
                trailing: Text(item.totalPrice.toStringAsFixed(2)),
              );
            },
          ),
        ),
      ],
    );
  }
}
