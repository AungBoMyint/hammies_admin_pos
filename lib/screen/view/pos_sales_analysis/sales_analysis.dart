import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/pos/sales_controller.dart';
import '../view/../pos_sales/daily_revenue.dart';
import '../view/../pos_sales/monthly_revenue.dart';
import '../view/../pos_sales/yearly_revenue.dart';


class SalesAnalysis extends StatefulWidget {
  const SalesAnalysis({Key? key}) : super(key: key);

  @override
  State<SalesAnalysis> createState() => _SalesAnalysisState();
}

class _SalesAnalysisState extends State<SalesAnalysis> {
  @override
  void initState() {
    Get.put(SalesController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.indigo),
          backgroundColor: Colors.white,
          title: const Text("Sales Analysis",
          style: TextStyle(color: Colors.black,
          letterSpacing: 1,
          wordSpacing: 1,
          fontSize: 16),
          ),
          leading: const BackButton(color: Colors.black),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black26,
            labelPadding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
            indicatorColor: Colors.indigo,
            indicatorWeight: 5,
            tabs: [
              Text(
                "နေ့စဉ်",
              ),
              Text(
                "လချူပ်",
              ),
              Text("နှစ်ချူပ်"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DailyRevenue(),
            MonthlyRevenue(),
            YearlyRevenue(),
          ],
        ),
      ),
    );
  }
}
