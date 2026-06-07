import 'package:json_annotation/json_annotation.dart';

part 'book_home_model.g.dart';

@JsonSerializable()
class BookListModel {
  @JsonKey(name: 'dish_count')
  final int? dishCount;
  @JsonKey(name: 'is_new')
  final int? isNew;
  @JsonKey(name: 'scene_background')
  final String? sceneBackground;
  @JsonKey(name: 'scene_desc')
  final String? sceneDesc;
  @JsonKey(name: 'scene_id')
  final int? sceneId;
  @JsonKey(name: 'scene_title')
  final String? sceneTitle;
  @JsonKey(name: 'scene_type')
  final int? sceneType;
  final String? thumbnail;

  const BookListModel({
    this.dishCount,
    this.isNew,
    this.sceneBackground,
    this.sceneDesc,
    this.sceneId,
    this.sceneTitle,
    this.sceneType,
    this.thumbnail,
  });

  factory BookListModel.fromJson(Map<String, dynamic> json) =>
      _$BookListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookListModelToJson(this);
}
