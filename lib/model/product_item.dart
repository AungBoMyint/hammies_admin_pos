import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_item.freezed.dart';
part 'product_item.g.dart';

@freezed
class ProductItem with _$ProductItem {
  factory ProductItem({
    required String id,
    required String photo,
    required String photo2,
    required String photo3,
    required String desc,
    required String name,
    required String deliverytime,
    required int price,
    required String color,
    required String size,
    required int star,
    required String category,
    required int originalQuantity,
    required int originalPrice,
    required int remainQuantity,
    @JsonKey(nullable: true, defaultValue: 0) 
    int? count,
  }) = _ProductItem;

  factory ProductItem.fromJson(Map<String, dynamic> json) =>
      _$ProductItemFromJson(json);
}
