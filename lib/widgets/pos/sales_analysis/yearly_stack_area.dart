/// Example of a stacked area chart with custom area colors.
///
/// By default, the area skirt for a chart will be drawn with the same color as
/// the line, but with a 10% opacity assigned to it. An area color function can
/// be provided to override this with any custom color.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../controller/pos/sales_controller.dart';
import '../../../model/pos/chart_data.dart';

class StackedAreaCustomColorLineChart extends StatelessWidget {
  const StackedAreaCustomColorLineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        title: ChartTitle(
            text: "ယခု နှစ် ၏ ဝင်ငွေ ၊ အမြတ် နှင့် သုံးစွဲငွေ ဇယား",
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 15, 70, 17),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            )),
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          SplineAreaSeries<ChartData, String>(
              color: Colors.red,
              //groupName: 'Profit',
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true, useSeriesColor: true),
              dataSource: profitChartDataList(),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y),
          SplineAreaSeries<ChartData, String>(
              color: Colors.green,
              //groupName: 'Revenue',
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true, useSeriesColor: true),
              dataSource: revenueChartDataList(),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y),
          SplineAreaSeries<ChartData, String>(
              color: Colors.blue,
              //groupName: 'Cost',
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true, useSeriesColor: true),
              dataSource: costChartDataList(),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y),
        ]);
  }

  List<ChartData> profitChartDataList() {
    SalesController _controller = Get.find();
    return _controller.monthlyDataList.value!.map((monthData) {
      return ChartData(
          _controller.getMonthName(monthData.dateTimeMonth),
          (monthData.totalRevenue ?? 0) -
              (monthData.originalTotalRevenue ?? 0));
    }).toList();
  }
}

List<ChartData> revenueChartDataList() {
  SalesController _controller = Get.find();
  return _controller.monthlyDataList.value!.map((monthData) {
    return ChartData(_controller.getMonthName(monthData.dateTimeMonth),
        monthData.totalRevenue ?? 0);
  }).toList();
}

List<ChartData> costChartDataList() {
  SalesController _controller = Get.find();
  int total = 0;
  final List<ChartData> chartDataList =
      _controller.monthlyDataList.value!.map((monthData) {
    total += monthData.expend ?? 0;
    return ChartData(_controller.getMonthName(monthData.dateTimeMonth),
        monthData.expend ?? 0);
  }).toList();
  debugPrint("*****YearCost: $total");
  return chartDataList;
}
