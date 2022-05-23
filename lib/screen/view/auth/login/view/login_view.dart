import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../controller/home_controller.dart';
import '../../../../../utils/theme.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              color: Colors.transparent,
              constraints: BoxConstraints(
                maxWidth: 400.0,
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Image.asset(
                      "assets/hammies.jpg",
                      width: Get.width / 3,
                    ),
                  ),
                  /*Text(
                    "Pos App",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),*/
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: Get.width - 100,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => homeController.signInWithGoogle(),
                          child: Card(
                            color: theme.primary,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: theme.primary,
                                    radius: 12,
                                    child: Icon(
                                      FontAwesomeIcons.google,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Sign in with Google",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        InkWell(
                          onTap: () => homeController.signInAnonymous(),
                          child: Card(
                            color: theme.primary,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: theme.primary,
                                    radius: 12,
                                    child: Icon(
                                      FontAwesomeIcons.user,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Guest",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
