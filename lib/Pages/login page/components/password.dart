import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode passwordFocusNode;
   final  Function login;

  const PasswordField({
    Key? key,
    required this.controller,
    required this.passwordFocusNode,
    required this.login,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        obscureText: isHidden,
        decoration: InputDecoration(
          hintText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon:const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon:
                isHidden ?const Icon(Icons.visibility_off) :const Icon(Icons.visibility),
            onPressed: togglePasswordVisibility,
          ),
        ),
        textInputAction: TextInputAction.done,
        focusNode: widget.passwordFocusNode,
        onFieldSubmitted: (_)=> widget.login(),
        keyboardType: TextInputType.visiblePassword,
        autofillHints:const [AutofillHints.password],
        onEditingComplete: () => TextInput.finishAutofillContext(),
        validator: (password) => password != null && password.length < 5
            ? 'Enter min. 5 characters'
            : null,
      );

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);
}
