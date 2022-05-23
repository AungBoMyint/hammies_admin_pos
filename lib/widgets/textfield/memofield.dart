import 'package:flutter/material.dart';

import 'textfield.dart';

class ExMemoField extends StatelessWidget {
  final String id;
  final String value;
  final String label;

  ExMemoField({
    required this.id,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ExTextField(
      onSubmitted: (text) => {},
      id: "$id",
      label: "$label",
      value: value,
      height: 200,
      keyboardType: TextInputType.multiline, onChanged: (String text) {  },
    );
  }
}
