import 'dart:developer';

import 'package:app/core/blocs/application_state.dart';
import 'package:app/core/data/models/item/item_model.dart';
import 'package:app/core/data/models/user_model.dart';
import 'package:app/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:app/features/home/domain/use_cases/home_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<ApplicationState> {
  final AuthUseCase _authUseCase;
  final HomeUseCase _homeUseCase;
  HomeCubit(
      {required AuthUseCase authUseCase, required HomeUseCase homeUseCase})
      : _homeUseCase = homeUseCase,
        _authUseCase = authUseCase,
        super(const HomeInitialState());

  void updateCartTotalItems() async {
    try {
      final totalItems = await _homeUseCase.getCartTotalItems();
      emit(HomeGetTotalCartItemsState(num: totalItems));
    } on Exception catch (e) {

      print('Error: $e');
    }
  }

  void addToCart(Item item) async {
    try {
      emit(const ApplicationLoadingState());
      await _homeUseCase.addToCart(item);
      emit(const HomeAddToCartSuccessState());
    } catch (e) {
      log(e.toString());
      emit(ApplicationApiError(message: e.runtimeType.toString()));
    }
  }

  void getHomeData() async {
    try {
      final uid = await _authUseCase.getUserUUID();
      if (uid == null) {
        return;
      }
      final name = await _authUseCase.getUserName(uid);
      final email = await _authUseCase.getUserEmail();
      final imageURL = await _authUseCase.getUserImageURL(uid);
      final user = UserModel(name: name, email: email, imageUrl: imageURL);
      emit(HomeUserDataSuccessState(user: user));
    } catch (e) {
      // Handle any exceptions that occur during the check
      // You can show an error message here if required
    }
  }

  void signOut() async {
    // Implement Firebase sign-out here
    // Update the state accordingly.
    try {
      await _authUseCase.signOut();
      emit(const HomeSignOutSuccessState());
    } catch (e) {
      // Handle any exceptions that occur during sign-out
      // You can show an error message here if required
    }
  }
}
