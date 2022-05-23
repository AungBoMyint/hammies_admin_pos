import 'package:freezed_annotation/freezed_annotation.dart';

part 'expend.freezed.dart';
part 'expend.g.dart';

@freezed
class Expend with _$Expend {
  factory Expend({
    required String description,
    required int cost,
    required String category,
    required String dateTime,
  }) = _Expend;

  factory Expend.fromJson(Map<String, dynamic> json) => _$ExpendFromJson(json);
}
