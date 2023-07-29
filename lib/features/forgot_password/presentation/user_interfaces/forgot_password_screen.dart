import 'dart:async';
import 'dart:developer';

import 'package:app/core/blocs/application_state.dart';
import 'package:app/core/blocs/cubit_factory.dart';
import 'package:app/core/constants/application_constants.dart';
import 'package:app/core/navigator/application_routes.dart';
import 'package:app/features/forgot_password/presentation/business_components/cubit/forgot_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final forgotPasswordCubit = CubitFactory.forgotPasswordCubit;
  final TextEditingController emailController = TextEditingController();
  StreamSubscription<Map>? _branchSub;

  void _onResetPassword(BuildContext context) {
    final email = emailController.text.trim();

    if (email.isNotEmpty) {
      forgotPasswordCubit.sendPasswordResetEmail(email);
    }
  }

  @override
  void initState() {
    listenBranchSDKLinks();
    super.initState();
  }

  @override
  void dispose() {
    _branchSub?.cancel();
    super.dispose();
  }

  void listenBranchSDKLinks() async {
    _branchSub = FlutterBranchSdk.initSession().listen((data) async {
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        // This code will execute when a Branch link is clicked
        // Retrieve the link params from 'data' and navigate to the right page
        // Example: Navigator.of(context).pushNamed(data['\$deeplink_path']);
        if (data.containsKey('\$deeplink_path')) {
          if (data['\$deeplink_path'] == branchIOResetPasswordKey &&
              data.containsKey('oobCode') &&
              mounted) {
            final bool didUpatePassword = await Navigator.of(context).pushNamed(
                ApplicationRoutes.resetPasswordScreen,
                arguments: data['oobCode']) as bool;
            if (didUpatePassword && mounted) {
              Navigator.of(context).pop();
            }
          }
        }
        log('Branch link clicked');
      }
    }, onError: (error, stacktrace) {
      log('Branch error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ApplicationState>(
      bloc: forgotPasswordCubit,
      listener: (context, state) {
        if (state is ForgotPasswordEmailSentState) {
          if (state.emailSentStatus) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Email enviado com sucesso'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Erro ao enviar email'),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: BackButton(
                  color: Colors.grey,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: const Text(
                  'Atualizar Senha',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                        'Insira o seu email para receber um link de atualização de senha',
                        style: TextStyle(color: Colors.grey, fontSize: 18)),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const Key('emailFieldForgotPassword'),
                      controller: emailController,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      cursorHeight: 24,
                      cursorColor: Colors.grey,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () => _onResetPassword(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(8.0),
                          backgroundColor: Colors.cyan,
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Receber Link')),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}