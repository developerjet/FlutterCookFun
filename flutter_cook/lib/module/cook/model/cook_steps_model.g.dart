// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cook_steps_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CookStepDataModel _$CookStepDataModelFromJson(Map<String, dynamic> json) =>
    CookStepDataModel(
      dashesId: json['dashes_id'] as String?,
      dashesName: json['dashes_name'] as String?,
      materialVideo: json['material_video'] as String?,
      processVideo: json['process_video'] as String?,
      hardLevel: json['hard_level'] as String?,
      taste: json['taste'] as String?,
      cookeTime: json['cooke_time'] as String?,
      image: json['image'] as String?,
      materialDesc: json['material_desc'] as String?,
      shareAmount: json['share_amount'] as String?,
      dishesName: json['dishes_name'] as String?,
      dishesTitle: json['dishes_title'] as String?,
      dishesId: json['dishes_id'] as String?,
      cookingTime: json['cooking_time'] as String?,
      collectCount: json['collect_count'] as String?,
      clickCount: json['click_count'] as String?,
      createDate: json['create_date'] as String?,
      lastUpdate: json['last_update'] as String?,
      commentCount: json['comment_count'] as String?,
      agreementAmount: json['agreement_amount'] as String?,
      tagsInfo: (json['tags_info'] as List<dynamic>?)
          ?.map((e) => TagsInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      shareUrl: json['share_url'] as String?,
      step: (json['step'] as List<dynamic>?)
          ?.map((e) => StepLitsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      like: (json['like'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CookStepDataModelToJson(CookStepDataModel instance) =>
    <String, dynamic>{
      'dashes_id': instance.dashesId,
      'dashes_name': instance.dashesName,
      'material_video': instance.materialVideo,
      'process_video': instance.processVideo,
      'hard_level': instance.hardLevel,
      'taste': instance.taste,
      'cooke_time': instance.cookeTime,
      'image': instance.image,
      'material_desc': instance.materialDesc,
      'share_amount': instance.shareAmount,
      'dishes_name': instance.dishesName,
      'dishes_title': instance.dishesTitle,
      'dishes_id': instance.dishesId,
      'cooking_time': instance.cookingTime,
      'collect_count': instance.collectCount,
      'click_count': instance.clickCount,
      'create_date': instance.createDate,
      'last_update': instance.lastUpdate,
      'comment_count': instance.commentCount,
      'agreement_amount': instance.agreementAmount,
      'tags_info': instance.tagsInfo,
      'share_url': instance.shareUrl,
      'step': instance.step,
      'like': instance.like,
    };

TagsInfo _$TagsInfoFromJson(Map<String, dynamic> json) => TagsInfo(
      id: (json['id'] as num?)?.toInt(),
      text: json['text'] as String?,
      type: (json['type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TagsInfoToJson(TagsInfo instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'type': instance.type,
    };

StepLitsModel _$StepLitsModelFromJson(Map<String, dynamic> json) =>
    StepLitsModel(
      dishesStepId: json['dishes_step_id'] as String?,
      dishesId: json['dishes_id'] as String?,
      dishesStepOrder: json['dishes_step_order'] as String?,
      dishesStepImage: json['dishes_step_image'] as String?,
      dishesStepDesc: json['dishes_step_desc'] as String?,
    );

Map<String, dynamic> _$StepLitsModelToJson(StepLitsModel instance) =>
    <String, dynamic>{
      'dishes_step_id': instance.dishesStepId,
      'dishes_id': instance.dishesId,
      'dishes_step_order': instance.dishesStepOrder,
      'dishes_step_image': instance.dishesStepImage,
      'dishes_step_desc': instance.dishesStepDesc,
    };
