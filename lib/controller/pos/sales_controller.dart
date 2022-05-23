import 'dart:collection';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../model/pos/chart_data.dart';
import '../../model/pos/coupon.dart';
import '../../model/pos/daily_order_data.dart';
import '../../model/pos/monthly_data.dart';
import '../../model/pos/order_and_total.dart';
import '../../utils/utils.dart';
import '../home_controller.dart';

class SalesController extends GetxController {
  //Rxn<DailyOrderData> dailyOrderData = Rxn<DailyOrderData>();
  Rxn<List<MapEntry<int, MapEntry<String, OrderAndTotal>>>>
      dailySplayTreeMapList =
      Rxn<List<MapEntry<int, MapEntry<String, OrderAndTotal>>>>();

  Rxn<List<List<MapEntry<int, MapEntry<String, OrderAndTotal>>>>>
      dailyChunkDataList =
      Rxn<List<List<MapEntry<int, MapEntry<String, OrderAndTotal>>>>>([]);

  Rxn<List<MonthlyData>> monthlyDataList = Rxn<List<MonthlyData>>();
  Rxn<DateTime> expireDate = Rxn<DateTime>(DateTime.now());

  final HomeController _controller = Get.find();

  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();

  //For Coupon
  TextEditingController discountContentController = TextEditingController();
  TextEditingController couponCodeController = TextEditingController();
  TextEditingController percentageController = TextEditingController();
  //

  void refreshCoupon() {
    discountContentController.text = "";
    couponCodeController.text = "";
    percentageController.text = "";
  }

  /*Future<void> addCoupon() async {
    _controller
        .addCoupon(
          coupon: Coupon(
            documentID: Uuid().v1(),
            code: couponCodeController.text,
            discountContent: discountContentController.text,
            startDate: DateTime.now(),
            expireDate: expireDate.value!,
            percentage: int.parse(percentageController.text),
          ),
        )
        .then((value) => refreshCoupon());
  }*/

  void changeExpireDate(DateTime dateTime) {
    expireDate.value = dateTime;
  }

  var barIndex = 0.obs;

  void changeBarIndex() {
    barIndex.value + 1 <= dailyChunkDataList.value!.length - 1
        ? barIndex.value++
        : barIndex.value = 0;
  }

  int getCurrentYearRevenue() {
    var result = 0;
    try {
      monthlyDataList.value!.forEach((element) {
        result += element.totalRevenue ?? 0;
      });
    } catch (e) {
      result = 0;
    }
    return result;
  }

  int getCurrentYearCost() {
    var result = 0;
    try {
      monthlyDataList.value!.forEach((element) {
        result += element.originalTotalRevenue ?? 0;
      });
    } catch (e) {
      result = 0;
    }
    return result;
  }

  int getCurrentYearExpend() {
    var result = 0;
    try {
      monthlyDataList.value!.forEach((element) {
        result += element.expend ?? 0;
      });
    } catch (e) {
      result = 0;
    }
    return result;
  }

  int getCurrentYearProfit() {
    var result = 0;
    try {
      int revenue = getCurrentYearRevenue();
      int cost = getCurrentYearCost();
      result = revenue - cost;
    } catch (e) {
      result = 0;
    }
    return result;
  }

  int monthlyRevenue() {
    var result = 0;
    try {
      result = monthlyDataList.value
              ?.firstWhere((element) =>
                  element.dateTimeMonth.month == DateTime.now().month)
              .totalRevenue ??
          0;
    } catch (e) {
      result = result;
      debugPrint("*****No order in this month*******");
    }
    return result;
  }

  int monthlyOriginalRevenue() {
    var result = 0;
    try {
      result = monthlyDataList.value
              ?.firstWhere((element) =>
                  element.dateTimeMonth.month == DateTime.now().month)
              .originalTotalRevenue ??
          0;
    } catch (e) {
      result = result;
      debugPrint("*****No order in this month*******");
    }
    return result;
  }

  int monthlyExpend() {
    var result = 0;
    try {
      result = monthlyDataList.value
              ?.firstWhere((element) =>
                  element.dateTimeMonth.month == DateTime.now().month)
              .expend ??
          0;
    } catch (e) {
      result = result;
      debugPrint("*****No order in this month*******");
    }
    return result;
  }

  int monthlyProfit() {
    var result = 0;
    try {
      var totalRevenue = monthlyRevenue();
      var totalOriginalRevenue = monthlyOriginalRevenue();
      result = totalRevenue - totalOriginalRevenue;
    } catch (e) {
      result = result;
      debugPrint("*****No order in this month*******8");
    }
    return result;
  }

  String todayRevenue() {
    var result = "0 ကျပ်";
    try {
      var map = dailySplayTreeMapList.value!
          .firstWhere((element) => element.key == DateTime.now().day);
      result = "${map.value.value.totalRevenue}";
    } catch (e) {
      result = result;
      debugPrint("********No order in today!.*********");
    }
    return result;
  }

  String todayExpend() {
    var result = "0 ကျပ်";
    try {
      var map = dailySplayTreeMapList.value!
          .firstWhere((element) => element.key == DateTime.now().day);
      result = "${map.value.value.expend}";
    } catch (e) {
      result = result;
      debugPrint("********No order in today!.*********");
    }
    return result;
  }

  String todayProfit() {
    var result = "0 ကျပ်";
    try {
      var map = dailySplayTreeMapList.value!
          .firstWhere((element) => element.key == DateTime.now().day);
      var total = (map.value.value.totalRevenue ?? 0) -
          (map.value.value.originalTotalRevenue ?? 0);
      result = "$total";
    } catch (e) {
      result = result;
      debugPrint("********No order in today!.*********");
    }
    return result;
  }

  /*Future<void> getMonthlySalesData() async {
    if (yearController.text.isNotEmpty &&
        monthController.text.isNotEmpty &&
        checkYear(yearController.text) &&
        checkMonth(monthController.text)) {
      _controller.firestore
          .getMonthlySalesData(
        yearCollection: "${yearController.text}Collection",
      )
          .then((value) {
        monthlyDataList.value =
            value.docs.map((e) => MonthlyData.fromJson(e.data())).toList();
        debugPrint("***********MonthlyDataList: ${monthlyDataList.value}***");
      });
    }
  }*/

  bool checkYear(String yearString) {
    var result = int.tryParse(yearString) ?? 0;
    return result > 2021 ? true : false;
  }

  bool checkMonth(String monthString) {
    var result = int.tryParse(monthString) ?? 0;
    return result > 0 ? true : false;
  }

  int getDay(String dateTime) {
    return int.parse(dateTime.split("-").last);
    /**TODO: to replace underline
     * return DateTime.tryParse(dateTime)?.day ?? 0;
     */
  }

  String getMonthName(DateTime dateTime) {
    return DateFormat.MMMM().format(dateTime);
  }

  List<ChartData> getWeeklyRevenueData() {
    int index = 0;
    int indexForXValue = 0;
    int totalRevenueIn7Days = 0;
    List<ChartData> resultList = [];
    for (var item in dailySplayTreeMapList.value!) {
      if (index > 7) {
        /*If previous loop period is a week,we create ChartData,
        then add this object into ChartDataList and
      result index and totalRevenueIn7Days to initial value
      and Increase indexForXValue for next Week
      */
        resultList.add(ChartData("$indexForXValue", totalRevenueIn7Days));
        indexForXValue++;
        index = 0;
        totalRevenueIn7Days = 0;
      }
      totalRevenueIn7Days += item.value.value.totalRevenue ?? 0;
      index++;
    }
    debugPrint("**********Weekly ChartDataList: ${resultList.length}******");
    return resultList;
  }

  DateTime getCurrentMonthDateTime() {
    if (!(monthlyDataList.value == null) && monthlyDataList.value!.isNotEmpty) {
      return monthlyDataList.value!
          .firstWhere(
              (element) => element.dateTimeMonth.month == DateTime.now().month)
          .dateTimeMonth;
    }
    return DateTime.now();
  }

  @override
  void onInit() async {
    await _controller.getDaysSales().then((value) {
      debugPrint("****${value.data()}***");
      var dailySplay = SplayTreeMap<int, MapEntry<String, OrderAndTotal>>();
      DailyOrderData.fromJson(value.data()!).dateTime.forEach((key, value) {
        log("********documentKey: $key*****");
        dailySplay[getDay(key)] = MapEntry(key, value);
      });
      dailySplayTreeMapList.value = startDateToEndDateList().map((e) {
        if (dailySplay.containsKey(e.day)) {
          return MapEntry(e.day,
              MapEntry(dailySplay[e.day]!.key, dailySplay[e.day]!.value));
        }
        return MapEntry(
            e.day,
            MapEntry(
                "${e.year}-${e.month}-${e.day}",
                OrderAndTotal(
                  orderDataList: null,
                  totalOrder: 0,
                  totalRevenue: 0,
                  originalTotalRevenue: 0,
                  expend: 0,
                )));
      }).toList(); //this is new version
      /*dailySplayTreeMapList.value = mapList.map((e) {
        debugPrint("Daily: ${e.key}");
        return e;
      }).toList(); */ //this is old version

      for (var i = 0; i < dailySplayTreeMapList.value!.length; i += 7) {
        int end = i + 7 <= dailySplayTreeMapList.value!.length
            ? i + 7
            : dailySplayTreeMapList.value!.length;
        dailyChunkDataList.value!
            .add(dailySplayTreeMapList.value!.sublist(i, end));
        debugPrint("**********End: $end");
      }
      // monthlySdailySplayTreeMap.value = dailySplayTreeMap.value;
      debugPrint(
          "*******DailySplayTreeMap:${dailySplayTreeMapList.value!.length}");
    });

    await _controller.getMonthsSales().then((value) {
      monthlyDataList.value =
          value.docs.map((e) => MonthlyData.fromJson(e.data())).toList();
      int index = 0;
      monthlyDataList.value!.forEach((data) {
        debugPrint("*****Index: $index");
        debugPrint("*******TotalOrder: ${data.totalOrder}");
        debugPrint("*******TotalRevenue: ${data.totalRevenue}");
        debugPrint("*******TotalOriginalRevenue: ${data.originalTotalRevenue}");
        index++;
      });
    });
    yearController.text = "${DateTime.now().year}";
    super.onInit();
  }
}
