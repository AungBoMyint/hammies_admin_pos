import 'package:get/get.dart';


class OrderController extends GetxController {
  var selectedFilterIndex = 0;

  get filterStatus {
    if (selectedFilterIndex == 0) {
      return "Today";
    } else if (selectedFilterIndex == 1) {
      return "Yesterday";
    } else if (selectedFilterIndex == 2) {
      return "All";
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  updateFilter(index) async {
    selectedFilterIndex = index;
    update();
  }
}
