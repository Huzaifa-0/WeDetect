// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import '/Models/user_information.dart';
import 'package:flutter/material.dart';

class EmailInput extends StatefulWidget {
 final FocusNode emailFocusNode, passwordFocusNode;
 final UserInformation user;
  EmailInput({required  this.emailFocusNode,required  this.passwordFocusNode,required  this.user,});

  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration:const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
        final regExp = RegExp(pattern);

        if (value!.isEmpty) {
          return 'Enter an email';
        } else if (!regExp.hasMatch(value)) {
          return 'Enter a valid email';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: widget.emailFocusNode,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(widget.passwordFocusNode),
      onSaved: (value) => setState(() => widget.user.email = value as String),
    );
  }
}
