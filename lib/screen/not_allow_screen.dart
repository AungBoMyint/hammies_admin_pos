import 'package:flutter/material.dart';

class NotAllowScreen extends StatelessWidget {
  const NotAllowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Image.asset(
            "assets/logo.png",
            width: size.width * 0.3,
            height: size.height * 0.3,
          ),
          const SizedBox(
            height: 25,
          ),
          RichText(
            text: TextSpan(
                text: "You are not an admin.\n",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
                children: [
                  TextSpan(
                      text: "Please contact to developer to become an admin.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ))
                ]),
          ),
        ],
      ))),
    );
  }
}
