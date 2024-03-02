import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_slider.g.dart';
part 'app_slider.freezed.dart';

@freezed
class AppSlider with _$AppSlider {
  factory AppSlider({
    required String id,
    required String image,
    required DateTime dateTime,
  }) = _AppSlider;

  factory AppSlider.fromJson(Map<String, dynamic> json) =>
      _$AppSliderFromJson(json);
}
