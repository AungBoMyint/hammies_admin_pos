import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/pos/sales_controller.dart';
import '../../../widgets/pos/custom_card.dart';
import '../../../widgets/pos/sales_analysis/animate_bar.dart';

class DailyRevenue extends StatelessWidget {
  const DailyRevenue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SalesController _controller = Get.find();
    return Obx(() => !(_controller.dailySplayTreeMapList.value == null) &&
            (_controller.dailySplayTreeMapList.value!.isNotEmpty)
        ? SingleChildScrollView(
            child: Column(
              children: [
                //Top Daily Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CustomCardForSales(
                        headTitleText: "ယနေ့ အမြတ်",
                        color: Colors.red,
                        total: "${_controller.todayProfit()} ကျပ်",
                      ),
                      CustomCardForSales(
                        headTitleText: "ယနေ့ဝင်ငွေ",
                        color: Colors.green,
                        total: "${_controller.todayRevenue()} ကျပ်",
                      ),
                      CustomCardForSales(
                        headTitleText: "ယနေ့ သုံးစွဲငွေ",
                        color: Colors.blue,
                        total: "${_controller.todayExpend()} ကျပ်",
                      ),
                    ],
                  ),
                ),
                //DailyBarChart
                Center(
                    child: SizedBox(
                        height: size.height * 0.6,
                        child: const SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: BarChartSample1()))),

                //Note For AnimateBarChart
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      noteForDailyAnimateBarChart(
                          color: Colors.red, text: "အမြတ်"),
                      noteForDailyAnimateBarChart(
                          color: Colors.green, text: "ဝင်ငွေ"),
                      noteForDailyAnimateBarChart(
                          color: Colors.blue, text: "သုံးစွဲငွေ"),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator())));
  }
}

Widget noteForDailyAnimateBarChart({
  required Color color,
  required String text,
}) {
  return Row(
    children: [
      const SizedBox(width: 20),
      CircleAvatar(
        radius: 10,
        backgroundColor: color,
      ),
      const SizedBox(width: 10),
      Text(text),
    ],
  );
}
