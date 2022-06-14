import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode passwordFocusNode;

  const EmailField({
    Key? key,
    required this.controller,
    required this.passwordFocusNode,
  }) : super(key: key);

  @override
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onListen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onListen);
    super.dispose();
  }

  void onListen() => setState(() {});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon:const Icon(Icons.mail),
          suffixIcon: widget.controller.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon:const Icon(Icons.close),
                  onPressed: () => widget.controller.clear(),
                ),
        ),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_)=>FocusScope.of(context)
                          .requestFocus(widget.passwordFocusNode),
        keyboardType: TextInputType.emailAddress,
        autofillHints:const [AutofillHints.email],
        autofocus: true,
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
      );
}
