import 'package:flutter/material.dart';

class CustomCardForSales extends StatelessWidget {
  final String headTitleText;
  final Color color;
  final String total;
  const CustomCardForSales({Key? key,
  required this.headTitleText,
  required this.color,
  required this.total,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(10),
      )),
      elevation: 5,
      color: color,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                headTitleText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  wordSpacing: 1,
                  letterSpacing: 1,
                ),
              ),
            ),
            Text(
              total,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
