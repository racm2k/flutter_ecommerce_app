import 'package:app/core/data/repositories/auth/auth_repository_impl.dart';
import 'package:app/core/data/repositories/cart/cart_repository_impl.dart';
import 'package:app/core/data/repositories/home/home_respository_impl.dart';
import 'package:app/core/data/repositories/orders/orders_repository_impl.dart';
import 'package:app/features/cart/domain/use_cases/cart_use_case_impl.dart';
import 'package:app/features/cart/presentation/business_components/cart_cubit.dart';
import 'package:app/features/forgot_password/domain/use_cases/forgot_password_use_case_impl.dart';
import 'package:app/features/forgot_password/presentation/business_components/cubit/forgot_password_cubit.dart';
import 'package:app/features/home/domain/use_cases/home_use_case_impl.dart';
import 'package:app/features/home/presentation/business_components/home_cubit.dart';
import 'package:app/features/auth/domain/use_cases/auth_use_case_impl.dart';
import 'package:app/features/auth/presentation/business_components/auth_cubit.dart';
import 'package:app/features/orders/domain/use_cases/orders_use_case_impl.dart';
import 'package:app/features/orders/presentation/business_components/orders_cubit.dart';
import 'package:app/features/payment/presentation/business_components/payment_cubit.dart';
import 'package:app/features/reset_password/domain/use_cases/reset_password_use_case_impl.dart';
import 'package:app/features/reset_password/presentation/business_components/cubit/reset_password_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CubitFactory {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static AuthCubit get authCubit => AuthCubit(
        authUseCase: AuthUseCaseImpl(
          authRepository: AuthRepositoryImpl(firebaseAuth: _firebaseAuth),
        ),
      );

  static HomeCubit get homeCubit => HomeCubit(
        authUseCase: AuthUseCaseImpl(
          authRepository: AuthRepositoryImpl(firebaseAuth: _firebaseAuth),
        ),
        homeUseCase: HomeUseCaseImpl(
          homeRepository: HomeRepositoryImpl(firebaseAuth: _firebaseAuth),
        ),
      );

  static ForgotPasswordCubit get forgotPasswordCubit => ForgotPasswordCubit(
        forgotPasswordUseCase: ForgotPasswordUseCaseImpl(
          AuthRepositoryImpl(firebaseAuth: _firebaseAuth),
        ),
      );

  static ResetPasswordCubit get resetPasswordCubit => ResetPasswordCubit(
        resetPasswordUseCase: ResetPasswordUseCaseImpl(
          authRepository: AuthRepositoryImpl(firebaseAuth: _firebaseAuth),
        ),
      );

  static CartCubit get cartCubit => CartCubit(
        cartUseCase: CartUseCaseImpl(
          cartRepository: CartRepositoryImpl(firebaseAuth: _firebaseAuth),
        ),
      );

  static OrdersCubit get ordersCubit => OrdersCubit(
        ordersUseCase: OrdersUseCaseImpl(
          ordersRepository: OrdersRepositoryImpl(firebaseAuth: _firebaseAuth),
        ),
      );

  static PaymentCubit get paymentCubit => PaymentCubit(
      cartUseCase: CartUseCaseImpl(
          cartRepository: CartRepositoryImpl(firebaseAuth: _firebaseAuth)));
}
