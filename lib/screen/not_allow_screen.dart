import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          SizedBox(
            width: Get.width * 0.18,
            height: Get.height * 0.28,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              child: Image.asset(
                "assets/logo.jpg",
                width: Get.width / 2,
                height: Get.height / 3,
                fit: BoxFit.cover,
              ),
            ),
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
