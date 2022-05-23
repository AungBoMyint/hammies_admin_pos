import 'package:intl/intl.dart';

String getMonthString(DateTime dateTime) {
  var result = DateFormat.yMMMMEEEEd().format(dateTime);
  return result.split(",")[1].split(" ").first;
}
