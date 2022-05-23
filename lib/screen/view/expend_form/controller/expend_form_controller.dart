import 'package:get/get.dart';

import '../../../../model/pos/expend.dart';
import '../../../../service/database.dart';
import '../../../../widgets/pos/input/input.dart';
import '../../../../widgets/show_loading/show_loading.dart';

class ExpendFormController extends GetxController {
  save() async {
    var expendDescription = Input.get("description");
    var cost = Input.get("cost");
    var categoryName = Input.get("category_name");

    showLoading();
    await Database().writeExpend(
      Expend(
        description: expendDescription,
        cost: int.tryParse(cost) ?? 0,
        category: categoryName,
        dateTime: DateTime.now().toString(),
      ),
    );

    hideLoading();
    Get.back();
  }

  delete(Expend expend) async {
    showLoading();
    await Database().deleteExpend(expend);
    hideLoading();
    Get.back();
  }
}
