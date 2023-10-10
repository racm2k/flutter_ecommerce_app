import 'package:app/core/blocs/cubit_factory.dart';
import 'package:app/core/constants/application_constants.dart';
import 'package:app/core/navigator/application_routes.dart';
import 'package:app/features/auth/presentation/business_components/auth_cubit.dart';
import 'package:app/core/components/garbo_button.dart';
import 'package:app/features/auth/presentation/components/header.dart';
import 'package:app/features/auth/presentation/components/input_fields.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final authCubit = CubitFactory.authCubit;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<AuthCubit, AuthStatus>(
          bloc: authCubit,
          listener: (context, state) {
            // Listen to state changes here, and perform navigation
            // or show snackbar based on authentication status.
            if (state == AuthStatus.authenticated) {
              // Navigate to the next screen after successful authentication.
              // Example: return HomePage();
              FirebaseAnalytics.instance.logLogin(loginMethod: 'email');
              _navigateToHomeScreen();
            }
            if(state == AuthStatus.authenticationFailed){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Falha na autenticação'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.cyan,
                    Colors.red,
                    Colors.yellow,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Header(),
                  const SizedBox(
                    height: 40,
                  ),
                  Expanded(
                      child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: InputFields(
                              authType: AuthType.login,
                              emailController: emailController,
                              passwordController: passwordController,
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                _navigateToForgotPasswordScreen();
                              },
                              child: const Text(
                                "Esqueceu-se da sua senha?",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          GarboButton(
                            onPressed: () => _signIn(),
                            text: 'Login',
                            isLoading: state == AuthStatus.authenticating,
                          ),const SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    authCubit.signInWithFacebook();
                                  },
                                  icon: const Icon(
                                    Icons.facebook_rounded,
                                    color: Colors.blueAccent,
                                    size: 48,
                                  ))
                            ],
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: TextButton(
                                onPressed: () => _navigateToRegistrationScreen(),
                                child: const Text(
                                  'Não possui uma conta? Clique aqui!',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToForgotPasswordScreen() {
    Navigator.of(context).pushNamed(ApplicationRoutes.forgotPasswordScreen);
  }

  void _signIn() {
    authCubit.signInWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );
  }

  void _signInWithFacebook(){
    authCubit.signInWithFacebook();
  }

  void _navigateToRegistrationScreen() {
    Navigator.of(context).pushNamed(ApplicationRoutes.registrationScreen);
  }

  _navigateToHomeScreen() {
    // Navigate to the next screen after successful authentication.
    Navigator.of(context).pushReplacementNamed(ApplicationRoutes.homeScreen);
  }
}
