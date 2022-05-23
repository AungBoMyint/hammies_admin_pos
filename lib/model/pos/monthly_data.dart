import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyData {
  final int? totalOrder;
  final int? totalRevenue;
  final int? originalTotalRevenue;
  final int? expend;
  final DateTime dateTimeMonth;
  MonthlyData({
     this.totalOrder,
     this.totalRevenue,
     this.originalTotalRevenue,
     this.expend,
    required this.dateTimeMonth,
    
  });

  factory MonthlyData.fromJson(Map<String, dynamic> json) => MonthlyData(
        totalOrder: json["totalOrder"] as int?,
        totalRevenue: json["totalRevenue"] as int?,
        originalTotalRevenue: json["originalTotalRevenue"] as int?,
        expend: json["expend"] as int?,
        dateTimeMonth: (json["dateTimeMonth"] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        "totalOrder": totalOrder,
        "totalRevenue": totalRevenue,
        "originalTotalRevenue": originalTotalRevenue,
        "expend": expend,
        "dateTimeMonth": dateTimeMonth,
      };
}
