import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../pos/input/input.dart';
import 'textfield.dart';
import 'textfield_format.dart';

Map<String, ExRowTextFieldState> exRowTextFieldState = {};

class ExRowTextField extends StatefulWidget {
  final String? id;
  final String? label;
  final String? value;
  final String? hintText;
  final TextFieldType? textFieldType;
  final TextInputType? keyboardType;
  final TextFieldFormat? format;
  final TextAlign? textAlign;
  final bool? enabled;
  final double? height;

  final Function(String text) onChanged;
  final Function(String text) onSubmitted;

  const ExRowTextField({Key? key, 
     this.id,
     this.label,
    this.value = "",
    this.hintText = "",
    this.textFieldType = TextFieldType.normal,
    this.textAlign = TextAlign.left,
    this.format = TextFieldFormat.normal,
     this.keyboardType,
     required this.onChanged,
     required this.onSubmitted,
     this.enabled = true,
     this.height,
  }) : super(key: key);

  @override
  ExRowTextFieldState createState() => ExRowTextFieldState();
}

class ExRowTextFieldState extends State<ExRowTextField> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    String initialText = widget.value!;
    if (widget.value != null) {
      initialText = formatText(initialText);
      controller.text = initialText;
    } else {
      controller.text = initialText;
    }

    textFieldController[widget.id!] = controller;
    exRowTextFieldState[widget.id!] = this;
    Input.set(widget.id, initialText);

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      }
    });
  }

  setValue(String value) {
    controller.text = formatText(value);
  }

String formatText(String text) {
    if (widget.format == TextFieldFormat.normal) return text;
    if (text == null) return text;

    if (widget.format == TextFieldFormat.money) {
      if (text.endsWith(".0")) {
        text = text.substring(0, text.length - 2);
        controller.text = text;
      } else {
        text = double.parse(text).toStringAsFixed(2);
      }
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          // color: Colors.white,
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 4.0,
                right: 4.0,
                top: 4.0,
                bottom: 4.0,
              ),
              child: Text(widget.label!),
            ),
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
                textAlign: widget.textAlign!,
                style: TextStyle(
                  color: widget.enabled!
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
                  text = formatText(text);
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
