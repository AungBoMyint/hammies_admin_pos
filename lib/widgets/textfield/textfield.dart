import 'package:flutter/material.dart';

import '../../utils/theme.dart';
import '../pos/input/input.dart';


enum TextFieldType {
  normal,
  password,
}

Map<String, TextEditingController> textFieldController = {};

class ExTextField extends StatefulWidget {
  final String id;
  final String label;
  final String value;
  final String hintText;
  final TextFieldType textFieldType;
  final TextInputType keyboardType;
  final bool enabled;
  final double height;

  final Function(String text) onChanged;
  final Function(String text) onSubmitted;

  ExTextField({
    required this.id,
    required this.label,
    this.value = "",
    this.hintText = "",
    this.textFieldType = TextFieldType.normal,
    required this.keyboardType,
    required this.onChanged,
    required this.onSubmitted,
    this.enabled = true,
    required this.height,
  });

  @override
  _ExTextFieldState createState() => _ExTextFieldState();
}

class _ExTextFieldState extends State<ExTextField> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.text = widget.value;
    textFieldController[widget.id] = controller;
    Input.set(widget.id, widget.value);

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          // color: Colors.white,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 4.0,
              right: 4.0,
              top: 4.0,
              bottom: 4.0,
            ),
            child: Text(widget.label),
          ),
          SizedBox(
            height: 4.0,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0.0,
                  color: theme.disabled,
                ),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: TextField(
                enabled: widget.enabled,
                keyboardType: widget.keyboardType,
                focusNode: focusNode,
                maxLines:
                    widget.keyboardType == TextInputType.multiline ? 5 : 1,
                style: TextStyle(
                  color: widget.enabled
                      ? theme.textColor
                      : theme.textColor.withOpacity(0.4),
                ),
                controller: controller,
                obscureText: widget.textFieldType == TextFieldType.password
                    ? true
                    : false,
                decoration: InputDecoration.collapsed(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: theme.textColor.withOpacity(0.3),
                  ),
                ),
                onChanged: (text) {
                  Input.set(widget.id, text);
                  if (widget.onChanged != null) return widget.onChanged(text);
                },
                onSubmitted: (text) {
                  Input.set(widget.id, text);
                  if (widget.onSubmitted != null)
                    return widget.onSubmitted(text);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
