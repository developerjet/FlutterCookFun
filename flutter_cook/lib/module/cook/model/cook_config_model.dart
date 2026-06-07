
import 'package:json_annotation/json_annotation.dart';

part 'cook_config_model.g.dart';

@JsonSerializable()
class CookConfigListModel {
  @JsonKey(name: 'dishes_id')
  final String? dishesId;
  final String? title;
  final String? description;
  final String? video;
  final String? video1;
  final String? image;
  @JsonKey(name: 'hard_level')
  final String? hardLevel;
  final String? play;
  @JsonKey(name: 'cooking_time')
  final String? cookingTime;
  @JsonKey(name: 'collect_count')
  final String? collectCount;
  final String? taste;
  @JsonKey(name: 'create_date')
  final int? createDate;
  final String? content;
  @JsonKey(name: 'tags_info')
  final List<CookTagsInfo>? tagsInfo;

  const CookConfigListModel({
    this.dishesId,
    this.title,
    this.description,
    this.video,
    this.video1,
    this.image,
    this.hardLevel,
    this.play,
    this.cookingTime,
    this.collectCount,
    this.taste,
    this.createDate,
    this.content,
    this.tagsInfo,
  });

  factory CookConfigListModel.fromJson(Map<String, dynamic> json) =>
      _$CookConfigListModelFromJson(json);

  Map<String, dynamic> toJson() => _$CookConfigListModelToJson(this);

  //保存数据库JSON
  Map<String, dynamic> toDataBaseJson() {
    return {
      'dishes_id': dishesId ?? "",
      'title': title ?? "",
      'image': image ?? "",
      'hard_level': hardLevel ?? "",
      'cooking_time': cookingTime ?? "",
      'taste': taste ?? "",
      'description': description ?? "",
    };
  }
}

@JsonSerializable()
class CookTagsInfo {
  final int? id;
  final String? text;
  final int? type;

  const CookTagsInfo({
    this.id,
    this.text,
    this.type,
  });

  factory CookTagsInfo.fromJson(Map<String, dynamic> json) =>
      _$CookTagsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CookTagsInfoToJson(this);
}