import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/pos/sales_controller.dart';

class BarChartSample1 extends StatefulWidget {
  final List<Color> availableColors = const [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  const BarChartSample1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = Colors.white; //const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;
  int touchedGroupIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    SalesController _controller = Get.find();
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Card(
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'ယနေ့ ၏  ဝင်ငွေ ၊ အမြတ် နှင့် သုံးစွဲထားသော ငွေများ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    const SizedBox(width: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                      onPressed: () => _controller.changeBarIndex(),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    //Next Button
                  ]),
                  Expanded(
                    child: Obx(() {
                      return BarChart(
                        isPlaying ? randomData() : mainBarData(),
                        swapAnimationDuration: animDuration,
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: const Color(0xff0f4a3c),
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                      if (isPlaying) {
                        refreshState();
                      }
                    });
                  },
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y1,
    double y2,
    double y3, {
    bool isTouched = false,
    Color barColor = Colors.green,
    double width = 15,
    List<int> showTooltips = const [],
  }) {
    debugPrint("*******Y1: $y1\nY2: $y2\nY3: $y3");
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          borderRadius: BorderRadius.zero,
          toY: y1,
          color: Colors.red,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
        BarChartRodData(
          borderRadius: BorderRadius.zero,
          toY: y2,
          color: Colors.green,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
        BarChartRodData(
          borderRadius: BorderRadius.zero,
          toY: y3,
          color: Colors.blue,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    SalesController _controller = Get.find();
    List<BarChartGroupData> groupDataList = List.generate(
        _controller.dailyChunkDataList.value![_controller.barIndex.value]
            .length, (index) {
      final item = _controller
          .dailyChunkDataList.value![_controller.barIndex.value][index];
      return makeGroupData(
          index,
          ((item.value.value.totalRevenue ?? 0) -
                  (item.value.value.originalTotalRevenue ?? 0)) +
              .0,
          (item.value.value.totalRevenue ?? 0) + .0,
          (item.value.value.expend ?? 0) + .0, //total cost
          isTouched: index == touchedIndex,
          showTooltips: [0, 1, 2]);
    });
    return groupDataList;
  }

  BarChartData mainBarData() {
    SalesController _controller = Get.find();
    return BarChartData(
      groupsSpace: 40,
      alignment: BarChartAlignment.center,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            fitInsideHorizontally: true,
            maxContentWidth: 150,
            tooltipBgColor: Colors.blueGrey.withOpacity(0.7),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay = _controller
                  .dailyChunkDataList
                  .value![_controller.barIndex.value][group.x.toInt()]
                  .value
                  .key;
              return (rodIndex == touchedIndex) &&
                      (groupIndex == touchedGroupIndex)
                  ? BarTooltipItem(
                      "",
                      TextStyle(),
                      children: <TextSpan>[
                        TextSpan(
                          text: "${rod.toY.toInt()}ks",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : null;
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              touchedGroupIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedRodDataIndex;
            touchedGroupIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    SalesController _controller = Get.find();
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text = Text(_controller.dailyChunkDataList
        .value![_controller.barIndex.value][value.toInt()].value.key);
    return Padding(padding: const EdgeInsets.only(top: 16), child: text);
  }

  BarChartData randomData() {
    return BarChartData(
        barTouchData: BarTouchData(
          enabled: false,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getTitles,
              reservedSize: 38,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: animateBarChartGroup());
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }

  List<BarChartGroupData> animateBarChartGroup() {
    SalesController _controller = Get.find();
    int index = 0;
    List<BarChartGroupData> groupDataList =
        List.generate(_controller.dailySplayTreeMapList.value!.length, (index) {
      final item = _controller.dailySplayTreeMapList.value![index];
      return makeGroupData(
          index,
          Random().nextInt(15).toDouble() + 6,
          Random().nextInt(15).toDouble() + 6,
          Random().nextInt(15).toDouble() + 6,
          barColor: widget.availableColors[
              Random().nextInt(widget.availableColors.length)]);
    });
    return groupDataList;
  }
}
