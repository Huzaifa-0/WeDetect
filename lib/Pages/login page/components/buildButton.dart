import 'package:flutter/widgets.dart';

import '../../../Widgets/button.dart';

Widget buildButton(VoidCallback login) => Button(
      text: 'LOGIN',
      onClicked: login,
    );
