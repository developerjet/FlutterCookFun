
class CookStepDataModel {
  String? dashesId;
  String? dashesName;
  String? materialVideo;
  String? processVideo;
  String? hardLevel;
  String? taste;
  String? cookeTime;
  String? image;
  String? materialDesc;
  String? shareAmount;
  String? dishesName;
  String? dishesTitle;
  String? dishesId;
  String? cookingTime;
  String? collectCount;
  String? clickCount;
  String? createDate;
  String? lastUpdate;
  String? commentCount;
  String? agreementAmount;
  List<TagsInfo>? tagsInfo;
  String? shareUrl;
  List<StepLitsModel>? step;
  int? like;

  CookStepDataModel(
      {this.dashesId,
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
      this.like});

  CookStepDataModel.fromJson(Map<String, dynamic> json) {
    dashesId = json['dashes_id'];
    dashesName = json['dashes_name'];
    materialVideo = json['material_video'];
    processVideo = json['process_video'];
    hardLevel = json['hard_level'];
    taste = json['taste'];
    cookeTime = json['cooke_time'];
    image = json['image'];
    materialDesc = json['material_desc'];
    shareAmount = json['share_amount'];
    dishesName = json['dishes_name'];
    dishesTitle = json['dishes_title'];
    dishesId = json['dishes_id'];
    cookingTime = json['cooking_time'];
    collectCount = json['collect_count'];
    clickCount = json['click_count'];
    createDate = json['create_date'];
    lastUpdate = json['last_update'];
    commentCount = json['comment_count'];
    agreementAmount = json['agreement_amount'];
    if (json['tags_info'] != null) {
      tagsInfo = <TagsInfo>[];
      json['tags_info'].forEach((v) {
        tagsInfo!.add(new TagsInfo.fromJson(v));
      });
    }
    shareUrl = json['share_url'];
    if (json['step'] != null) {
      step = <StepLitsModel>[];
      json['step'].forEach((v) {
        step!.add(new StepLitsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dashes_id'] = this.dashesId;
    data['dashes_name'] = this.dashesName;
    data['material_video'] = this.materialVideo;
    data['process_video'] = this.processVideo;
    data['hard_level'] = this.hardLevel;
    data['taste'] = this.taste;
    data['cooke_time'] = this.cookeTime;
    data['image'] = this.image;
    data['material_desc'] = this.materialDesc;
    data['share_amount'] = this.shareAmount;
    data['dishes_name'] = this.dishesName;
    data['dishes_title'] = this.dishesTitle;
    data['dishes_id'] = this.dishesId;
    data['cooking_time'] = this.cookingTime;
    data['collect_count'] = this.collectCount;
    data['click_count'] = this.clickCount;
    data['create_date'] = this.createDate;
    data['last_update'] = this.lastUpdate;
    data['comment_count'] = this.commentCount;
    data['agreement_amount'] = this.agreementAmount;
    if (this.tagsInfo != null) {
      data['tags_info'] = this.tagsInfo!.map((v) => v.toJson()).toList();
    }
    data['share_url'] = this.shareUrl;
    if (this.step != null) {
      data['step'] = this.step!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TagsInfo {
  int? id;
  String? text;
  int? type;

  TagsInfo({this.id, this.text, this.type});

  TagsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['type'] = this.type;
    return data;
  }
}

class StepLitsModel {
  String? dishesStepId;
  String? dishesId;
  String? dishesStepOrder;
  String? dishesStepImage;
  String? dishesStepDesc;

  StepLitsModel(
      {this.dishesStepId,
      this.dishesId,
      this.dishesStepOrder,
      this.dishesStepImage,
      this.dishesStepDesc});

  StepLitsModel.fromJson(Map<String, dynamic> json) {
    dishesStepId = json['dishes_step_id'];
    dishesId = json['dishes_id'];
    dishesStepOrder = json['dishes_step_order'];
    dishesStepImage = json['dishes_step_image'];
    dishesStepDesc = json['dishes_step_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dishes_step_id'] = this.dishesStepId;
    data['dishes_id'] = this.dishesId;
    data['dishes_step_order'] = this.dishesStepOrder;
    data['dishes_step_image'] = this.dishesStepImage;
    data['dishes_step_desc'] = this.dishesStepDesc;
    return data;
  }
}