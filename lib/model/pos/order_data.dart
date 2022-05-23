class OrderData {
  final String id;
  final String name;
  final int count;

  OrderData({required this.id, required this.name, required this.count});

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        id: json["id"],
        name: json["name"],
        count: json["count"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "count": count,
      };
}
