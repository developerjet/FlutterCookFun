import 'package:json_annotation/json_annotation.dart';

part 'book_detail_model.g.dart';

@JsonSerializable()
class BookDetailModel {
  final String? code;
  final String? msg;
  final String? version;
  final int? timestamp;
  final BookMoreData? data;

  const BookDetailModel({
    this.code,
    this.msg,
    this.version,
    this.timestamp,
    this.data,
  });

  factory BookDetailModel.fromJson(Map<String, dynamic> json) =>
      _$BookDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookDetailModelToJson(this);
}

@JsonSerializable()
class BookMoreData {
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
  @JsonKey(name: 'dishes_list')
  final List<BookDishesListModel>? dishesList;
  @JsonKey(name: 'share_url')
  final String? shareUrl;
  final List<BookRelates>? relates;

  const BookMoreData({
    this.dishCount,
    this.isNew,
    this.sceneBackground,
    this.sceneDesc,
    this.sceneId,
    this.sceneTitle,
    this.sceneType,
    this.thumbnail,
    this.dishesList,
    this.shareUrl,
    this.relates,
  });

  factory BookMoreData.fromJson(Map<String, dynamic> json) =>
      _$BookMoreDataFromJson(json);

  Map<String, dynamic> toJson() => _$BookMoreDataToJson(this);
}

@JsonSerializable()
class BookDishesListModel {
  final String? image;
  @JsonKey(name: 'material_video')
  final String? materialVideo;
  @JsonKey(name: 'process_video')
  final String? processVideo;
  @JsonKey(name: 'dishes_id')
  final int? dishesId;
  @JsonKey(name: 'dishes_name')
  final String? dishesName;
  @JsonKey(name: 'dishes_desc')
  final String? dishesDesc;
  @JsonKey(name: 'share_url')
  final String? shareUrl;
  final int? like;
  @JsonKey(name: 'tags_info')
  final List<BookTagsInfo>? tagsInfo;

  const BookDishesListModel({
    this.image,
    this.materialVideo,
    this.processVideo,
    this.dishesId,
    this.dishesName,
    this.dishesDesc,
    this.shareUrl,
    this.like,
    this.tagsInfo,
  });

  factory BookDishesListModel.fromJson(Map<String, dynamic> json) =>
      _$BookDishesListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookDishesListModelToJson(this);
}

@JsonSerializable()
class BookTagsInfo {
  final int? id;
  final String? text;
  final int? type;

  const BookTagsInfo({
    this.id,
    this.text,
    this.type,
  });

  factory BookTagsInfo.fromJson(Map<String, dynamic> json) =>
      _$BookTagsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BookTagsInfoToJson(this);
}

@JsonSerializable()
class BookRelates {
  @JsonKey(name: 'scene_background')
  final String? sceneBackground;
  @JsonKey(name: 'scene_id')
  final int? sceneId;
  @JsonKey(name: 'scene_title')
  final String? sceneTitle;
  @JsonKey(name: 'dishes_count')
  final int? dishesCount;

  const BookRelates({
    this.sceneBackground,
    this.sceneId,
    this.sceneTitle,
    this.dishesCount,
  });

  factory BookRelates.fromJson(Map<String, dynamic> json) =>
      _$BookRelatesFromJson(json);

  Map<String, dynamic> toJson() => _$BookRelatesToJson(this);
}