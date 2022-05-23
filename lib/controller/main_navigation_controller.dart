import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  int index = 0;

  void changeNavIndex(int value) {
    index = value;
    update();
  }
}
