import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_and_total.dart';

 
part 'daily_order_data.freezed.dart';
part 'daily_order_data.g.dart';

@freezed
class DailyOrderData with _$DailyOrderData {
  @JsonSerializable(explicitToJson: true)
  factory DailyOrderData({
    required Map<String,OrderAndTotal > dateTime,
 
 }) = _DailyOrderData; 
     
  factory DailyOrderData.fromJson(Map<String,dynamic> json) => _$DailyOrderDataFromJson(json);
}
