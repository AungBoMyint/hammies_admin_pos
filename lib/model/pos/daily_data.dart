class DailyData {
  final int day;
  final int totalPrice;
  final int totalOrder;
  DailyData(
      {required this.day, required this.totalPrice, required this.totalOrder});

  factory DailyData.fromJson(Map<String, dynamic> json) => DailyData(
        day: json["day"],
        totalPrice: json["totalPrice"],
        totalOrder: json["totalOrder"],
      );
  Map<String, dynamic> toJson() => {
        "da": day,
        "totalPrice": totalPrice,
        "totalOrder": totalOrder,
      };
}
