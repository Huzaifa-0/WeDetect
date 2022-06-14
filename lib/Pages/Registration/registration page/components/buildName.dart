import 'package:flutter/material.dart';

Widget buildName(
  TextEditingController name,
  String label,
 BuildContext context,
 FocusNode lastNameFocusNode
) =>
    TextFormField(
      controller: name,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value?.length as num < 3) {
          return 'Enter at least 3 characters';
        } else {
          return null;
        }
      },
      focusNode: label == 'First Name' ? null : lastNameFocusNode,
      textInputAction:
          label == 'First Name' ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: label == 'First Name'
          ? (_) => FocusScope.of(context).requestFocus(lastNameFocusNode)
          : null,
      maxLength: 30,
    );
