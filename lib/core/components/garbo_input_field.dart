import 'package:flutter/material.dart';

enum InputFieldType { email, password, username, message }

class GarboInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController? inputController;
  final InputFieldType inputFieldType;

  const GarboInputField(
      {super.key,
      required this.labelText,
      required this.inputController,
      required this.inputFieldType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: inputController,
      autofillHints: inputFieldType == InputFieldType.username
          ? const [AutofillHints.name]
          : inputFieldType == InputFieldType.email
              ? const [AutofillHints.email]
              : const [AutofillHints.password],
      textInputAction: (inputFieldType == InputFieldType.password ||
              inputFieldType == InputFieldType.message)
          ? TextInputAction.done
          : TextInputAction.next,
      keyboardType: inputFieldType == InputFieldType.email
          ? TextInputType.emailAddress
          : inputFieldType == InputFieldType.username
              ? TextInputType.name
              : TextInputType.text,
      autocorrect: false,
      minLines: inputFieldType == InputFieldType.message ? 4 : 1,
      maxLines: inputFieldType == InputFieldType.message ? 5 : 1,
      cursorColor: Colors.grey,
      obscureText: inputFieldType == InputFieldType.password ? true : false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        if (inputFieldType == InputFieldType.email) {
          if (!value.contains('@')) {
            return 'Por favor, insira um email válido';
          }
        }
        return null;
      },
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          isCollapsed: true,
          labelText: labelText,
          contentPadding: EdgeInsets.all(16),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20)),
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          floatingLabelBehavior: FloatingLabelBehavior.never),
    );
  }
}
