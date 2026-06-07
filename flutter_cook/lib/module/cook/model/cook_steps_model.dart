
import 'package:json_annotation/json_annotation.dart';

part 'cook_steps_model.g.dart';

@JsonSerializable()
class CookStepDataModel {
  @JsonKey(name: 'dashes_id')
  final String? dashesId;
  @JsonKey(name: 'dashes_name')
  final String? dashesName;
  @JsonKey(name: 'material_video')
  final String? materialVideo;
  @JsonKey(name: 'process_video')
  final String? processVideo;
  @JsonKey(name: 'hard_level')
  final String? hardLevel;
  final String? taste;
  @JsonKey(name: 'cooke_time')
  final String? cookeTime;
  final String? image;
  @JsonKey(name: 'material_desc')
  final String? materialDesc;
  @JsonKey(name: 'share_amount')
  final String? shareAmount;
  @JsonKey(name: 'dishes_name')
  final String? dishesName;
  @JsonKey(name: 'dishes_title')
  final String? dishesTitle;
  @JsonKey(name: 'dishes_id')
  final String? dishesId;
  @JsonKey(name: 'cooking_time')
  final String? cookingTime;
  @JsonKey(name: 'collect_count')
  final String? collectCount;
  @JsonKey(name: 'click_count')
  final String? clickCount;
  @JsonKey(name: 'create_date')
  final String? createDate;
  @JsonKey(name: 'last_update')
  final String? lastUpdate;
  @JsonKey(name: 'comment_count')
  final String? commentCount;
  @JsonKey(name: 'agreement_amount')
  final String? agreementAmount;
  @JsonKey(name: 'tags_info')
  final List<TagsInfo>? tagsInfo;
  @JsonKey(name: 'share_url')
  final String? shareUrl;
  final List<StepLitsModel>? step;
  final int? like;

  const CookStepDataModel({
    this.dashesId,
    this.dashesName,
    this.materialVideo,
    this.processVideo,
    this.hardLevel,
    this.taste,
    this.cookeTime,
    this.image,
    this.materialDesc,
    this.shareAmount,
    this.dishesName,
    this.dishesTitle,
    this.dishesId,
    this.cookingTime,
    this.collectCount,
    this.clickCount,
    this.createDate,
    this.lastUpdate,
    this.commentCount,
    this.agreementAmount,
    this.tagsInfo,
    this.shareUrl,
    this.step,
    this.like,
  });

  factory CookStepDataModel.fromJson(Map<String, dynamic> json) =>
      _$CookStepDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CookStepDataModelToJson(this);
}

@JsonSerializable()
class TagsInfo {
  final int? id;
  final String? text;
  final int? type;

  const TagsInfo({
    this.id,
    this.text,
    this.type,
  });

  factory TagsInfo.fromJson(Map<String, dynamic> json) =>
      _$TagsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TagsInfoToJson(this);
}

@JsonSerializable()
class StepLitsModel {
  @JsonKey(name: 'dishes_step_id')
  final String? dishesStepId;
  @JsonKey(name: 'dishes_id')
  final String? dishesId;
  @JsonKey(name: 'dishes_step_order')
  final String? dishesStepOrder;
  @JsonKey(name: 'dishes_step_image')
  final String? dishesStepImage;
  @JsonKey(name: 'dishes_step_desc')
  final String? dishesStepDesc;

  const StepLitsModel({
    this.dishesStepId,
    this.dishesId,
    this.dishesStepOrder,
    this.dishesStepImage,
    this.dishesStepDesc,
  });

  factory StepLitsModel.fromJson(Map<String, dynamic> json) =>
      _$StepLitsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StepLitsModelToJson(this);
}