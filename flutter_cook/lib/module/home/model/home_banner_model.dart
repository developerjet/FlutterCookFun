import 'package:json_annotation/json_annotation.dart';

part 'home_banner_model.g.dart';

/// 首页Banner数据模型
@JsonSerializable()
class HomeBannerModel {
  final String? code;
  final String? msg;
  final String? version;
  final int? timestamp;
  final HomeBannerData? data;

  HomeBannerModel({
    this.code,
    this.msg,
    this.version,
    this.timestamp,
    this.data,
  });

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) =>
      _$HomeBannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeBannerModelToJson(this);
}

/// Banner数据内容
@JsonSerializable()
class HomeBannerData {
  @JsonKey(name: 'module_count_all')
  final int? moduleCountAll;

  @JsonKey(name: 'module_list')
  final List<ModuleList>? moduleList;

  @JsonKey(name: 'ios_latest_version')
  final String? iosLatestVersion;

  @JsonKey(name: 'android_latest_version')
  final String? androidLatestVersion;

  HomeBannerData({
    this.moduleCountAll,
    this.moduleList,
    this.iosLatestVersion,
    this.androidLatestVersion,
  });

  factory HomeBannerData.fromJson(Map<String, dynamic> json) =>
      _$HomeBannerDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeBannerDataToJson(this);
}

/// 模块列表
@JsonSerializable()
class ModuleList {
  @JsonKey(name: 'module_id')
  final String? moduleId;

  @JsonKey(name: 'module_name')
  final String? moduleName;

  @JsonKey(name: 'show_num')
  final String? showNum;

  @JsonKey(name: 'module_type_id')
  final String? moduleTypeId;

  @JsonKey(name: 'module_data')
  final List<ModuleData>? moduleData;

  ModuleList({
    this.moduleId,
    this.moduleName,
    this.showNum,
    this.moduleTypeId,
    this.moduleData,
  });

  factory ModuleList.fromJson(Map<String, dynamic> json) =>
      _$ModuleListFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleListToJson(this);
}

/// 模块数据
@JsonSerializable()
class ModuleData {
  @JsonKey(name: 'banner_title')
  final String? bannerTitle;

  @JsonKey(name: 'banner_picture')
  final String? bannerPicture;

  @JsonKey(name: 'banner_link')
  final String? bannerLink;

  @JsonKey(name: 'is_link')
  final String? isLink;

  final String? id;

  @JsonKey(name: 'entry_title')
  final String? entryTitle;

  @JsonKey(name: 'entry_desc')
  final String? entryDesc;

  final String? link;

  @JsonKey(name: 'entry_icon')
  final String? entryIcon;

  @JsonKey(name: 'dishes_id')
  final String? dishesId;

  @JsonKey(name: 'dishes_name')
  final String? dishesName;

  @JsonKey(name: 'dishes_image')
  final String? dishesImage;

  @JsonKey(name: 'dishes_desc')
  final String? dishesDesc;

  @JsonKey(name: 'img_url')
  final String? imgUrl;

  @JsonKey(name: 'link_url')
  final String? linkUrl;

  @JsonKey(name: 'series_id')
  final String? seriesId;

  @JsonKey(name: 'series_name')
  final String? seriesName;

  @JsonKey(name: 'series_image')
  final String? seriesImage;

  final String? description;
  final String? dateType;
  final String? background;

  @JsonKey(name: 'user_id')
  final String? userId;

  final String? nick;

  @JsonKey(name: 'head_img')
  final String? headImg;

  final String? fans;
  final String? follow;

  @JsonKey(name: 'topic_id')
  final String? topicId;

  final String? title;

  @JsonKey(name: 'topic_picture')
  final String? topicPicture;

  final String? desc;
  final String? image;

  @JsonKey(name: 'create_time')
  final String? createTime;

  final String? content;

  @JsonKey(name: 'agree_count')
  final String? agreeCount;

  @JsonKey(name: 'series_title')
  final String? seriesTitle;

  final String? price;

  @JsonKey(name: 'old_price')
  final String? oldPrice;

  @JsonKey(name: 'is_buy')
  final String? isBuy;

  @JsonKey(name: 'data_type')
  final String? dataType;

  @JsonKey(name: 'is_charge')
  final String? isCharge;

  @JsonKey(name: 'course_num')
  final String? courseNum;

  @JsonKey(name: 'series_type')
  final String? seriesType;

  ModuleData({
    this.bannerTitle,
    this.bannerPicture,
    this.bannerLink,
    this.isLink,
    this.id,
    this.entryTitle,
    this.entryDesc,
    this.link,
    this.entryIcon,
    this.dishesId,
    this.dishesName,
    this.dishesImage,
    this.dishesDesc,
    this.imgUrl,
    this.linkUrl,
    this.seriesId,
    this.seriesName,
    this.seriesImage,
    this.description,
    this.dateType,
    this.background,
    this.userId,
    this.nick,
    this.headImg,
    this.fans,
    this.follow,
    this.topicId,
    this.title,
    this.topicPicture,
    this.desc,
    this.image,
    this.createTime,
    this.content,
    this.agreeCount,
    this.seriesTitle,
    this.price,
    this.oldPrice,
    this.isBuy,
    this.dataType,
    this.isCharge,
    this.courseNum,
    this.seriesType,
  });

  factory ModuleData.fromJson(Map<String, dynamic> json) =>
      _$ModuleDataFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleDataToJson(this);
}