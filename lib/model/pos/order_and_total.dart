import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_data.dart';

part 'order_and_total.freezed.dart';
part 'order_and_total.g.dart';

@freezed
class OrderAndTotal with _$OrderAndTotal{
  @JsonSerializable(explicitToJson: true)
  factory OrderAndTotal({
    @JsonKey(nullable: true)
    required List<OrderData>? orderDataList,
    @JsonKey(nullable: true,defaultValue: 0)
    int? totalOrder,
    @JsonKey(nullable: true,defaultValue: 0)
     int? originalTotalRevenue,
     @JsonKey(nullable: true,defaultValue: 0)
   int? totalRevenue,
    @JsonKey(nullable: true,defaultValue: 0)
    int? expend,
  }) = _OrderAndTotal;

  factory OrderAndTotal.fromJson(Map<String, dynamic> json) =>
      _$OrderAndTotalFromJson(json);
}
