import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_item.freezed.dart';
part 'purchase_item.g.dart';

@freezed
class PurchaseItem with _$PurchaseItem{
  factory PurchaseItem({
    required String id, 
    required String itemName, 
    required int count, 
    required String size, 
    required String color,
    required String priceType, 
    required int price,
    }) = _PurchaseItem;
    factory PurchaseItem.fromJson(Map<String,dynamic> json) => _$PurchaseItemFromJson(json);
}