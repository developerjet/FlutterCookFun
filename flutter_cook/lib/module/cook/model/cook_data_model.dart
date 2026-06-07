import 'package:json_annotation/json_annotation.dart';

part 'cook_data_model.g.dart';

@JsonSerializable()
class CookHomeListModel {
  final String? id;
  final String? text;
  final String? image;
  final List<CookListDataModel>? data;

  const CookHomeListModel({
    this.id,
    this.text,
    this.image,
    this.data,
  });

  factory CookHomeListModel.fromJson(Map<String, dynamic> json) =>
      _$CookHomeListModelFromJson(json);

  Map<String, dynamic> toJson() => _$CookHomeListModelToJson(this);
}

@JsonSerializable()
class CookListDataModel {
  final String? id;
  final String? text;
  final String? image;

  /// 是否选中
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isSelected;

  CookListDataModel({
    this.id,
    this.text,
    this.image,
    this.isSelected = false,
  });

  factory CookListDataModel.fromJson(Map<String, dynamic> json) =>
      _$CookListDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CookListDataModelToJson(this);
}
