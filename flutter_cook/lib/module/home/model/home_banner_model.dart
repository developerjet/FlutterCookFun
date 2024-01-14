class HomeBannerModel {
  String? code;
  String? msg;
  String? version;
  int? timestamp;
  HomeBannerData? data;

  HomeBannerModel(
      {this.code, this.msg, this.version, this.timestamp, this.data});

  HomeBannerModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    version = json['version'];
    timestamp = json['timestamp'];
    data = json['data'] != null ? new HomeBannerData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['version'] = this.version;
    data['timestamp'] = this.timestamp;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class HomeBannerData {
  int? moduleCountAll;
  List<ModuleList>? moduleList;
  String? iosLatestVersion;
  String? androidLatestVersion;

  HomeBannerData(
      {this.moduleCountAll,
      this.moduleList,
      this.iosLatestVersion,
      this.androidLatestVersion});

  HomeBannerData.fromJson(Map<String, dynamic> json) {
    moduleCountAll = json['module_count_all'];
    if (json['module_list'] != null) {
      moduleList = <ModuleList>[];
      json['module_list'].forEach((v) {
        moduleList!.add(new ModuleList.fromJson(v));
      });
    }
    iosLatestVersion = json['ios_latest_version'];
    androidLatestVersion = json['android_latest_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module_count_all'] = this.moduleCountAll;
    if (this.moduleList != null) {
      data['module_list'] = this.moduleList!.map((v) => v.toJson()).toList();
    }
    data['ios_latest_version'] = this.iosLatestVersion;
    data['android_latest_version'] = this.androidLatestVersion;
    return data;
  }
}

class ModuleList {
  String? moduleId;
  String? moduleName;
  String? showNum;
  String? moduleTypeId;
  List<ModuleData>? moduleData;

  ModuleList(
      {this.moduleId,
      this.moduleName,
      this.showNum,
      this.moduleTypeId,
      this.moduleData});

  ModuleList.fromJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    moduleName = json['module_name'];
    showNum = json['show_num'];
    moduleTypeId = json['module_type_id'];
    if (json['module_data'] != null) {
      moduleData = <ModuleData>[];
      json['module_data'].forEach((v) {
        moduleData!.add(new ModuleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module_id'] = this.moduleId;
    data['module_name'] = this.moduleName;
    data['show_num'] = this.showNum;
    data['module_type_id'] = this.moduleTypeId;
    if (this.moduleData != null) {
      data['module_data'] = this.moduleData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModuleData {
  String? bannerTitle;
  String? bannerPicture;
  String? bannerLink;
  String? isLink;
  String? id;
  String? entryTitle;
  String? entryDesc;
  String? link;
  String? entryIcon;
  String? dishesId;
  String? dishesName;
  String? dishesImage;
  String? dishesDesc;
  String? imgUrl;
  String? linkUrl;
  String? seriesId;
  String? seriesName;
  String? seriesImage;
  String? description;
  String? dateType;
  String? background;
  String? userId;
  String? nick;
  String? headImg;
  String? fans;
  String? follow;
  String? topicId;
  String? title;
  String? topicPicture;
  String? desc;
  String? image;
  String? createTime;
  String? content;
  String? agreeCount;
  String? seriesTitle;
  String? price;
  String? oldPrice;
  String? isBuy;
  String? dataType;
  String? isCharge;
  String? courseNum;
  String? seriesType;

  ModuleData(
      {this.bannerTitle,
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
      this.seriesType});

  ModuleData.fromJson(Map<String, dynamic> json) {
    bannerTitle = json['banner_title'];
    bannerPicture = json['banner_picture'];
    bannerLink = json['banner_link'];
    isLink = json['is_link'];
    id = json['id'];
    entryTitle = json['entry_title'];
    entryDesc = json['entry_desc'];
    link = json['link'];
    entryIcon = json['entry_icon'];
    dishesId = json['dishes_id'];
    dishesName = json['dishes_name'];
    dishesImage = json['dishes_image'];
    dishesDesc = json['dishes_desc'];
    imgUrl = json['img_url'];
    linkUrl = json['link_url'];
    seriesId = json['series_id'];
    seriesName = json['series_name'];
    seriesImage = json['series_image'];
    description = json['description'];
    dateType = json['dateType'];
    background = json['background'];
    userId = json['user_id'];
    nick = json['nick'];
    headImg = json['head_img'];
    fans = json['fans'];
    follow = json['follow'];
    topicId = json['topic_id'];
    title = json['title'];
    topicPicture = json['topic_picture'];
    desc = json['desc'];
    image = json['image'];
    createTime = json['create_time'];
    content = json['content'];
    agreeCount = json['agree_count'];
    seriesTitle = json['series_title'];
    price = json['price'];
    oldPrice = json['old_price'];
    isBuy = json['is_buy'];
    dataType = json['data_type'];
    isCharge = json['is_charge'];
    courseNum = json['course_num'];
    seriesType = json['series_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_title'] = this.bannerTitle;
    data['banner_picture'] = this.bannerPicture;
    data['banner_link'] = this.bannerLink;
    data['is_link'] = this.isLink;
    data['id'] = this.id;
    data['entry_title'] = this.entryTitle;
    data['entry_desc'] = this.entryDesc;
    data['link'] = this.link;
    data['entry_icon'] = this.entryIcon;
    data['dishes_id'] = this.dishesId;
    data['dishes_name'] = this.dishesName;
    data['dishes_image'] = this.dishesImage;
    data['dishes_desc'] = this.dishesDesc;
    data['img_url'] = this.imgUrl;
    data['link_url'] = this.linkUrl;
    data['series_id'] = this.seriesId;
    data['series_name'] = this.seriesName;
    data['series_image'] = this.seriesImage;
    data['description'] = this.description;
    data['dateType'] = this.dateType;
    data['background'] = this.background;
    data['user_id'] = this.userId;
    data['nick'] = this.nick;
    data['head_img'] = this.headImg;
    data['fans'] = this.fans;
    data['follow'] = this.follow;
    data['topic_id'] = this.topicId;
    data['title'] = this.title;
    data['topic_picture'] = this.topicPicture;
    data['desc'] = this.desc;
    data['image'] = this.image;
    data['create_time'] = this.createTime;
    data['content'] = this.content;
    data['agree_count'] = this.agreeCount;
    data['series_title'] = this.seriesTitle;
    data['price'] = this.price;
    data['old_price'] = this.oldPrice;
    data['is_buy'] = this.isBuy;
    data['data_type'] = this.dataType;
    data['is_charge'] = this.isCharge;
    data['course_num'] = this.courseNum;
    data['series_type'] = this.seriesType;
    return data;
  }
}