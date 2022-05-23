import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../controller/home_controller.dart';
import '../../../../model/order_item.dart';
import '../../../../model/product_item.dart';
import '../../../../service/database.dart';
import '../../../../widgets/pos/input/input.dart';
import '../../../../widgets/show_loading/show_loading.dart';
import '../../../../widgets/textfield/row_textfield.dart';
import '../../pos/controller/pos_controller.dart';
import '../../pos_complete/view/pos_complete_view.dart';

class PosCheckoutController extends GetxController {
  final HomeController homeController = Get.find();
  final Database _database = Database();
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

  onInputValue(double total) {
    var pay = Input.get("pay");
    var change = double.parse(pay) - total;
    exRowTextFieldState["change"]!.setValue(change.toString());
  }

  save(Map<String, dynamic> orderDetail, List<ProductItem> orderItems,
      int total) async {
    var pay = double.parse(Input.get("pay"));
    var change = double.parse(Input.get("change"));

    if (change < 0) {
      print("change: $change");
      Get.snackbar("Insufficient amount of payment", "");
      return;
    }

    showLoading();
    debugPrint("**********OrderID: ${orderDetail["id"]}");
    await _database.writePurchaseData(OrderItem(
      orderID: orderDetail["id"],
      pay: double.parse(exRowTextFieldState["pay"]!.controller.text).round(),
      total: total,
      change: int.tryParse(
          exRowTextFieldState["change"]!.controller.text == "0.00"
              ? "0"
              : exRowTextFieldState["change"]!.controller.text)!,
      itemIdList: orderItems,
      dateTime: DateTime.now().toString(),
    ));
    hideLoading();
    PosController posController = Get.find();
    posController.resetState();

    Get.to(PosCompleteView());
  }
}
