import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_slider.g.dart';

@JsonSerializable()
class ImageSliderAccesses extends Equatable {
  final int? id;
  final String? attachmentUrl;
  final bool? active;

  const ImageSliderAccesses({
    this.id = 0,
    this.attachmentUrl = '',
    this.active = false,
  });

  factory ImageSliderAccesses.fromJson(Map<String, dynamic> json) =>
      _$ImageSliderAccessesFromJson(json);
  Map<String, dynamic> toJson() => _$ImageSliderAccessesToJson(this);

  @override
  List<Object> get props => [];
}
