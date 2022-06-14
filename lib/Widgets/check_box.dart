import 'package:provider/provider.dart';

import '../provider/provider.dart';
import '/Models/check_box_state.dart';
import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final List<String> titleList;
  final CheckBoxState checkBox;

  const CheckBox({
    required this.titleList,
    required this.checkBox,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    var gender = Provider.of<DataProvider>(context).gender;
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Theme.of(context).primaryColor,
      value: widget.checkBox.value,
      title: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Text(
          widget.checkBox.title,
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
      ),
      onChanged: (widget.checkBox.title == CheckBoxState.checkUpTitleList[0] &&
              gender == 'Male')
          ? null
          : (val) {
              setState(() {
                if (val == true) {
                  if (!widget.titleList.contains(widget.checkBox.title)) {
                    widget.titleList.add(widget.checkBox.title);
                  }
                } else {
                  widget.titleList.remove(widget.checkBox.title);
                }
                // print(widget.titleList.toString());
                widget.checkBox.value = val!;
              });
            },
    );
  }
}
