import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../controller/pos/sales_controller.dart';
import '../../../model/pos/chart_data.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
          text: "ယခု လ ၏  ဝင်ငွေ ၊ အမြတ် နှင့် သုံးစွဲထားသော ငွေများ",
          textStyle: const TextStyle(
            color: Color.fromARGB(255, 15, 70, 17),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          )),
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        SplineSeries<ChartData, String>(
            width: 1,
            color: Colors.red,
            dataLabelSettings:
                const DataLabelSettings(isVisible: true, useSeriesColor: true),
            dataSource: profitDataList(),
            // Renders the track
            //isTrackVisible: true,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y),
        SplineSeries<ChartData, String>(
            width: 1,
            color: Colors.green,
            dataLabelSettings:
                const DataLabelSettings(isVisible: true, useSeriesColor: true),
            dataSource: revenueDataList(),
            // Renders the track
            //isTrackVisible: true,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y),
        SplineSeries<ChartData, String>(
            color: Colors.blue,
            width: 1,
            dataLabelSettings:
                const DataLabelSettings(isVisible: true, useSeriesColor: true),
            dataSource: costDataList(),
            // Renders the track
            //isTrackVisible: true,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y),
      ],
    );
  }

  List<ChartData> profitDataList() {
    SalesController _controller = Get.find();
    List<ChartData> profitList = [];
    for (var i = 0; i < _controller.dailyChunkDataList.value!.length; i++) {
      int revenue = 0;
      int cost = 0;
      _controller.dailyChunkDataList.value![i].forEach((element) {
        revenue += element.value.value.totalRevenue ?? 0;
        cost += element.value.value.originalTotalRevenue ?? 0;
      });
      profitList.add(
        ChartData("Week${i + 1}", revenue - cost),
      );
    }
    debugPrint("******ProfitLength: ${profitList.length}");
    return profitList;
  }

  List<ChartData> revenueDataList() {
    SalesController _controller = Get.find();
    List<ChartData> profitList = [];
    for (var i = 0; i < _controller.dailyChunkDataList.value!.length; i++) {
      int revenue = 0;
      _controller.dailyChunkDataList.value![i].forEach((element) {
        revenue += element.value.value.totalRevenue ?? 0;
      });
      profitList.add(
        ChartData("Week$i", revenue),
      );
    }
    debugPrint("******ProfitLength: ${profitList.length}");
    return profitList;
  }

  List<ChartData> costDataList() {
    SalesController _controller = Get.find();
    List<ChartData> profitList = [];
    for (var i = 0; i < _controller.dailyChunkDataList.value!.length; i++) {
      int cost = 0;
      _controller.dailyChunkDataList.value![i].forEach((element) {
        cost += element.value.value.expend ?? 0;
      });
      profitList.add(
        ChartData("Week$i", cost),
      );
      debugPrint("******Cost: $cost");
    }
    debugPrint("******CostDataList: ${profitList.length}");
    return profitList;
  }
}
