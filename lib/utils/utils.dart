import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../widgets/pos/button/button.dart';
import 'theme.dart';


var currentDateTime =
    "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

enum Filter {
  all,
  date,
}

List<DateTime> startDateToEndDateList() {
  var from = DateTime(DateTime.now().year, DateTime.now().month, 1);
  var to =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int difDay = (to.difference(from).inHours / 24).round();
  debugPrint("*********TotalDiffDay: $difDay");
  return List.generate(difDay + 1, (index) {
    debugPrint("*****Day: ${index + 1}");
    return DateTime(DateTime.now().year, DateTime.now().month, index + 1);
  });
}

//BlueWarnning
void showBlueWarnning() {
  Get.defaultDialog(
      barrierDismissible: false,
      title: "Warnning",
      content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Please turn on bluetooth.",
            ),
            ExButton(
              color: theme.primary,
              label: "OK",
              onPressed: () => Get.back(),
            ),
          ]));
}
