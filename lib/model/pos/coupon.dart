import 'package:freezed_annotation/freezed_annotation.dart';


part "coupon.freezed.dart";
part 'coupon.g.dart';

@freezed
class Coupon with _$Coupon {
  factory Coupon({
    @JsonKey(nullable: true) String? documentID,
    required String code,
    required String discountContent,
    required DateTime startDate,
    required DateTime expireDate,
    required int percentage,
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
}
