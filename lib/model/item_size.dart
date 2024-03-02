import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'item_size.g.dart';
part 'item_size.freezed.dart';

@freezed
class ItemSize with _$ItemSize {
  factory ItemSize({
    required String id,
    required String size,
    required int price,
  }) = _ItemSize;

  factory ItemSize.fromJson(Map<String, dynamic> json) =>
      _$ItemSizeFromJson(json);

  factory ItemSize.empty() => ItemSize(id: Uuid().v1(), size: "", price: 0);
}
