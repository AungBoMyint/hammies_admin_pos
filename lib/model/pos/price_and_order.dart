class PriceAndOrder {
  final int totalPrice;
  final int totalOrder;
  PriceAndOrder({required this.totalPrice, required this.totalOrder});

  factory PriceAndOrder.fromJson(Map<String, dynamic> json) => PriceAndOrder(
        totalPrice: json["totalPrice"],
        totalOrder: json["totalOrder"],
      );
}
