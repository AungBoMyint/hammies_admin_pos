import 'package:flutter/material.dart';

class RowItem extends StatelessWidget {
  final String label;
  final String value;

  const RowItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: 4.0,
        bottom: 4.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12.0,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
