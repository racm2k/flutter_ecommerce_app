import 'package:app/core/components/garbo_input_field.dart';
import 'package:flutter/material.dart';

enum AuthType { login, registration }

class InputFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? usernameController;
  final AuthType authType;

  const InputFields(
      {super.key,
      this.usernameController,
      required this.authType,
      required this.emailController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        children: <Widget>[
          if (authType == AuthType.registration) ...[
            GarboInputField(
              key: const Key('usernameField'),
              inputController: usernameController,
              labelText: "Nome de utilizador",
              inputFieldType: InputFieldType.username,
            ),
            const SizedBox(
              height: 16,
            )
          ],
          GarboInputField(
            key: const Key('emailField'),
            inputController: emailController,
            labelText: "Email",
            inputFieldType: InputFieldType.email,
          ),
          const SizedBox(
            height: 16,
          ),
          GarboInputField(
            key: const Key('passwordField'),
            inputController: passwordController,
            labelText: "Senha",
            inputFieldType: InputFieldType.password,
          ),
        ],
      ),
    );
  }
}
