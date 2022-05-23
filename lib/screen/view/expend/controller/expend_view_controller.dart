import 'package:get/get.dart';

import '../../../../utils/utils.dart';

class ExpendViewController extends GetxController {
  Filter filter = Filter.all;
  var selectedDateString = currentDateTime;
  var selectedDate = DateTime.now();

  void changeFilter(Filter value) {
    filter = value;
    update();
  }

  void confirmSelectedDate(DateTime date) {
    selectedDateString = "${date.day}/${date.month}/${date.year}";
    selectedDate = date;
    update();
  }
}
