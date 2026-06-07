// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeBannerModel _$HomeBannerModelFromJson(Map<String, dynamic> json) =>
    HomeBannerModel(
      code: json['code'] as String?,
      msg: json['msg'] as String?,
      version: json['version'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : HomeBannerData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeBannerModelToJson(HomeBannerModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'version': instance.version,
      'timestamp': instance.timestamp,
      'data': instance.data,
    };

HomeBannerData _$HomeBannerDataFromJson(Map<String, dynamic> json) =>
    HomeBannerData(
      moduleCountAll: (json['module_count_all'] as num?)?.toInt(),
      moduleList: (json['module_list'] as List<dynamic>?)
          ?.map((e) => ModuleList.fromJson(e as Map<String, dynamic>))
          .toList(),
      iosLatestVersion: json['ios_latest_version'] as String?,
      androidLatestVersion: json['android_latest_version'] as String?,
    );

Map<String, dynamic> _$HomeBannerDataToJson(HomeBannerData instance) =>
    <String, dynamic>{
      'module_count_all': instance.moduleCountAll,
      'module_list': instance.moduleList,
      'ios_latest_version': instance.iosLatestVersion,
      'android_latest_version': instance.androidLatestVersion,
    };

ModuleList _$ModuleListFromJson(Map<String, dynamic> json) => ModuleList(
      moduleId: json['module_id'] as String?,
      moduleName: json['module_name'] as String?,
      showNum: json['show_num'] as String?,
      moduleTypeId: json['module_type_id'] as String?,
      moduleData: (json['module_data'] as List<dynamic>?)
          ?.map((e) => ModuleData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModuleListToJson(ModuleList instance) =>
    <String, dynamic>{
      'module_id': instance.moduleId,
      'module_name': instance.moduleName,
      'show_num': instance.showNum,
      'module_type_id': instance.moduleTypeId,
      'module_data': instance.moduleData,
    };

ModuleData _$ModuleDataFromJson(Map<String, dynamic> json) => ModuleData(
      bannerTitle: json['banner_title'] as String?,
      bannerPicture: json['banner_picture'] as String?,
      bannerLink: json['banner_link'] as String?,
      isLink: json['is_link'] as String?,
      id: json['id'] as String?,
      entryTitle: json['entry_title'] as String?,
      entryDesc: json['entry_desc'] as String?,
      link: json['link'] as String?,
      entryIcon: json['entry_icon'] as String?,
      dishesId: json['dishes_id'] as String?,
      dishesName: json['dishes_name'] as String?,
      dishesImage: json['dishes_image'] as String?,
      dishesDesc: json['dishes_desc'] as String?,
      imgUrl: json['img_url'] as String?,
      linkUrl: json['link_url'] as String?,
      seriesId: json['series_id'] as String?,
      seriesName: json['series_name'] as String?,
      seriesImage: json['series_image'] as String?,
      description: json['description'] as String?,
      dateType: json['dateType'] as String?,
      background: json['background'] as String?,
      userId: json['user_id'] as String?,
      nick: json['nick'] as String?,
      headImg: json['head_img'] as String?,
      fans: json['fans'] as String?,
      follow: json['follow'] as String?,
      topicId: json['topic_id'] as String?,
      title: json['title'] as String?,
      topicPicture: json['topic_picture'] as String?,
      desc: json['desc'] as String?,
      image: json['image'] as String?,
      createTime: json['create_time'] as String?,
      content: json['content'] as String?,
      agreeCount: json['agree_count'] as String?,
      seriesTitle: json['series_title'] as String?,
      price: json['price'] as String?,
      oldPrice: json['old_price'] as String?,
      isBuy: json['is_buy'] as String?,
      dataType: json['data_type'] as String?,
      isCharge: json['is_charge'] as String?,
      courseNum: json['course_num'] as String?,
      seriesType: json['series_type'] as String?,
    );

Map<String, dynamic> _$ModuleDataToJson(ModuleData instance) =>
    <String, dynamic>{
      'banner_title': instance.bannerTitle,
      'banner_picture': instance.bannerPicture,
      'banner_link': instance.bannerLink,
      'is_link': instance.isLink,
      'id': instance.id,
      'entry_title': instance.entryTitle,
      'entry_desc': instance.entryDesc,
      'link': instance.link,
      'entry_icon': instance.entryIcon,
      'dishes_id': instance.dishesId,
      'dishes_name': instance.dishesName,
      'dishes_image': instance.dishesImage,
      'dishes_desc': instance.dishesDesc,
      'img_url': instance.imgUrl,
      'link_url': instance.linkUrl,
      'series_id': instance.seriesId,
      'series_name': instance.seriesName,
      'series_image': instance.seriesImage,
      'description': instance.description,
      'dateType': instance.dateType,
      'background': instance.background,
      'user_id': instance.userId,
      'nick': instance.nick,
      'head_img': instance.headImg,
      'fans': instance.fans,
      'follow': instance.follow,
      'topic_id': instance.topicId,
      'title': instance.title,
      'topic_picture': instance.topicPicture,
      'desc': instance.desc,
      'image': instance.image,
      'create_time': instance.createTime,
      'content': instance.content,
      'agree_count': instance.agreeCount,
      'series_title': instance.seriesTitle,
      'price': instance.price,
      'old_price': instance.oldPrice,
      'is_buy': instance.isBuy,
      'data_type': instance.dataType,
      'is_charge': instance.isCharge,
      'course_num': instance.courseNum,
      'series_type': instance.seriesType,
    };
