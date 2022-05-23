import 'package:json_annotation/json_annotation.dart';

import 'product_item.dart';

part 'order_item.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItem {
  final String orderID;
  final int pay;
  final int total;
  final int change;
  final List<ProductItem> itemIdList;
  final String dateTime;

  OrderItem({
    required this.orderID,
    required this.pay,
    required this.total,
    required this.change,
    required this.itemIdList,
    required this.dateTime,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
