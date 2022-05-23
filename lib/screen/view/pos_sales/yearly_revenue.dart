import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/pos/sales_controller.dart';
import '../../../widgets/pos/custom_card.dart';
import '../../../widgets/pos/sales_analysis/yearly_stack_area.dart';
import 'daily_revenue.dart';

class YearlyRevenue extends StatelessWidget {
  const YearlyRevenue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SalesController _controller = Get.find();
    return Obx(() {
      return !(_controller.monthlyDataList.value == null)
          ? Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CustomCardForSales(
                        headTitleText: "${DateTime.now().year} အမြတ်",
                        color: Colors.red,
                        total: "${_controller.getCurrentYearProfit()} ကျပ်",
                      ),
                      CustomCardForSales(
                        headTitleText: "${DateTime.now().year} ဝင်ငွေ",
                        color: Colors.green,
                        total: "${_controller.getCurrentYearRevenue()} ကျပ်",
                      ),
                      CustomCardForSales(
                        headTitleText: "${DateTime.now().year} သုံးစွဲငွေ",
                        color: Colors.blue,
                        total: "${_controller.getCurrentYearExpend()} ကျပ်",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                //
                const Expanded(
                  child: StackedAreaCustomColorLineChart(),
                ),
                //Note For Yearly LineChart
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
            )
          : const Center(
              child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ));
    });
  }
}
