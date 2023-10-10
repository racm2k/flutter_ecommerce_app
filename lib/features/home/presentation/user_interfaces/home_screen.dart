import 'package:app/core/blocs/application_state.dart';
import 'package:app/core/blocs/cubit_factory.dart';
import 'package:app/core/components/custom_scaffold.dart';
import 'package:app/core/data/models/item/item_model.dart';
import 'package:app/core/data/models/user_model.dart';
import 'package:app/core/utils/scroll_listener.dart';
import 'package:app/features/home/presentation/business_components/home_cubit.dart';
import 'package:app/core/navigator/application_routes.dart';
import 'package:app/features/home/presentation/components/drawer_body.dart';
import 'package:app/features/home/presentation/components/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final homeCubit = CubitFactory.homeCubit;
  final items = List<Item>.generate(
    10,
    (index) => Item(
        name: 'Dignissim convallis aenaea',
        image: 'assets/images/mock_image.jpg',
        price: 19.99,
        id: '1'),
  );

  late bool _showCartBadge;
  UserModel? user;

  int _totalCartItems = 0;

  void getUserData() {
    homeCubit.getHomeData();
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    getUserData();
    homeCubit.updateCartTotalItems();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateToAuthScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(ApplicationRoutes.authScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    _showCartBadge = _totalCartItems > 0;

    return BlocConsumer<HomeCubit, ApplicationState>(
      bloc: homeCubit,
      listener: (context, state) {
        switch (state.runtimeType) {
          case HomeSignOutSuccessState:
            _navigateToAuthScreen();
            break;
          case HomeAddToCartSuccessState:
            homeCubit.updateCartTotalItems();
            break;
          case HomeGetTotalCartItemsState:
            setState(() {
              _totalCartItems = (state as HomeGetTotalCartItemsState).num;
            });
            break;
        }
      },
      builder: (context, state) {
        if (state is HomeUserDataSuccessState) {
          user = state.user;
        }
        if (state is HomeGetTotalCartItemsState) {
          _totalCartItems = state.num;
        }
        return CustomScaffold(
          scaffoldKey: _key,
          padding: const EdgeInsets.all(0),
          drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: DrawerBody(
            user: user,
            onSignOutConfirm: () => homeCubit.signOut(),
          )),
          leading: IconButton(
              onPressed: () {
                _key.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.amber[800],
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 16.0),
              child: _shoppingCartBadge(),
            ),
          ],
          body: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.5,
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemBuilder: (context, index) {
                    var item = items[index];
                    return ItemCard(
                      item: item,
                      onAddToCartPressed: () {
                        homeCubit.addToCart(item);
                      },
                      onAddToFavoritesPressed: () {},
                    );
                  },
                  itemCount: items.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shoppingCartBadge() {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).pushNamed(ApplicationRoutes.cartScreen);
        if (mounted) {
          homeCubit.updateCartTotalItems();
        }
      },
      child: badges.Badge(
        showBadge: _showCartBadge,
        ignorePointer: false,
        badgeContent: Text(
          _totalCartItems.toString(),
        ),
        badgeStyle: badges.BadgeStyle(
          shape: badges.BadgeShape.circle,
          badgeColor: Colors.amber,
          padding: const EdgeInsets.all(6),
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.white, width: 2),
          elevation: 0,
        ),
        child: Icon(
          Icons.shopping_cart,
          color: Colors.amber[800],
          size: 26,
        ),
      ),
    );
  }
}
