import 'package:flutter/material.dart';

import '../../utils/theme.dart';


class CardRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final void Function()? navigateRoute;
  const CardRow({
    Key? key,
    required this.icon,
    required this.color,
    required this.text,
    required this.navigateRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: navigateRoute,
      child: SizedBox(
        width: 180,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              children: [
                //Icon
                Icon(icon, size: 30, color: color),
                const SizedBox(
                  width: 15,
                ),
                //Text
                SizedBox(height: 10,),
                SizedBox(
                  width: 200,
                  child: Center(
                    child: Text(text,
                        style: buttonText.copyWith(
                          color: color,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
