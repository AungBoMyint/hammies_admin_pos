import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../constant/constant.dart';
import '../../../../controller/home_controller.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/pos/button/button.dart';
import '../../../../widgets/textfield/textfield.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Obx(
        () {
          final authUser = homeController.user.value;
          return Padding(
            padding: theme.mediumPadding,
            child: Column(
              children: [
                authUser == null
                    ? const CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(
                          defaultProfileImage,
                        ),
                      )
                    : CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(
                          authUser.photoURL ?? defaultProfileImage,
                        ),
                      ),
                const SizedBox(
                  height: 20.0,
                ),
                ExTextField(
                  id: "full_name",
                  label: "Full Name",
                  hintText: "Your full name",
                  enabled: false,
                  value: authUser?.displayName == null
                      ? "Guest"
                      : "${authUser!.displayName}",
                  onSubmitted: (value) {},
                  onChanged: (value) {},
                  height: 100,
                  keyboardType: TextInputType.text,
                ),
                ExTextField(
                  id: "email",
                  label: "Email",
                  hintText: "Your email",
                  enabled: false,
                  value: authUser?.email == null
                      ? "guest@world.com"
                      : "${authUser!.email}",
                  onSubmitted: (value) {},
                  onChanged: (value) {},
                  height: 100,
                  keyboardType: TextInputType.text,
                ),
                Spacer(),
                ExButton(
                  label: "Logout",
                  height: 40.0,
                  color: theme.primary,
                  onPressed: () => homeController.logOut(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
