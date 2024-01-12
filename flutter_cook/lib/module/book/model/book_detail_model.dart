class BookDetailModel {
  String? code;
  String? msg;
  String? version;
  int? timestamp;
  BookMoreData? data;

  BookDetailModel(
      {this.code, this.msg, this.version, this.timestamp, this.data});

  BookDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    version = json['version'];
    timestamp = json['timestamp'];
    data = json['data'] != null ? new BookMoreData.fromJson(json['data']) : null;
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

class BookMoreData {
  int? dishCount;
  int? isNew;
  String? sceneBackground;
  String? sceneDesc;
  int? sceneId;
  String? sceneTitle;
  int? sceneType;
  String? thumbnail;
  List<BookDishesListModel>? dishesList;
  String? shareUrl;
  List<Relates>? relates;

  BookMoreData(
      {this.dishCount,
      this.isNew,
      this.sceneBackground,
      this.sceneDesc,
      this.sceneId,
      this.sceneTitle,
      this.sceneType,
      this.thumbnail,
      this.dishesList,
      this.shareUrl,
      this.relates});

  BookMoreData.fromJson(Map<String, dynamic> json) {
    dishCount = json['dish_count'];
    isNew = json['is_new'];
    sceneBackground = json['scene_background'];
    sceneDesc = json['scene_desc'];
    sceneId = json['scene_id'];
    sceneTitle = json['scene_title'];
    sceneType = json['scene_type'];
    thumbnail = json['thumbnail'];
    if (json['dishes_list'] != null) {
      dishesList = <BookDishesListModel>[];
      json['dishes_list'].forEach((v) {
        dishesList!.add(new BookDishesListModel.fromJson(v));
      });
    }
    shareUrl = json['share_url'];
    if (json['relates'] != null) {
      relates = <Relates>[];
      json['relates'].forEach((v) {
        relates!.add(new Relates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dish_count'] = this.dishCount;
    data['is_new'] = this.isNew;
    data['scene_background'] = this.sceneBackground;
    data['scene_desc'] = this.sceneDesc;
    data['scene_id'] = this.sceneId;
    data['scene_title'] = this.sceneTitle;
    data['scene_type'] = this.sceneType;
    data['thumbnail'] = this.thumbnail;
    if (this.dishesList != null) {
      data['dishes_list'] = this.dishesList!.map((v) => v.toJson()).toList();
    }
    data['share_url'] = this.shareUrl;
    if (this.relates != null) {
      data['relates'] = this.relates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookDishesListModel {
  String? image;
  String? materialVideo;
  String? processVideo;
  int? dishesId;
  String? dishesName;
  String? dishesDesc;
  String? shareUrl;
  int? like;
  List<TagsInfo>? tagsInfo;

  BookDishesListModel(
      {this.image,
      this.materialVideo,
      this.processVideo,
      this.dishesId,
      this.dishesName,
      this.dishesDesc,
      this.shareUrl,
      this.like,
      this.tagsInfo});

  BookDishesListModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    materialVideo = json['material_video'];
    processVideo = json['process_video'];
    dishesId = json['dishes_id'];
    dishesName = json['dishes_name'];
    dishesDesc = json['dishes_desc'];
    shareUrl = json['share_url'];
    like = json['like'];
    if (json['tags_info'] != null) {
      tagsInfo = <TagsInfo>[];
      json['tags_info'].forEach((v) {
        tagsInfo!.add(new TagsInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['material_video'] = this.materialVideo;
    data['process_video'] = this.processVideo;
    data['dishes_id'] = this.dishesId;
    data['dishes_name'] = this.dishesName;
    data['dishes_desc'] = this.dishesDesc;
    data['share_url'] = this.shareUrl;
    data['like'] = this.like;
    if (this.tagsInfo != null) {
      data['tags_info'] = this.tagsInfo!.map((v) => v.toJson()).toList();
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

class Relates {
  String? sceneBackground;
  int? sceneId;
  String? sceneTitle;
  int? dishesCount;

  Relates(
      {this.sceneBackground, this.sceneId, this.sceneTitle, this.dishesCount});

  Relates.fromJson(Map<String, dynamic> json) {
    sceneBackground = json['scene_background'];
    sceneId = json['scene_id'];
    sceneTitle = json['scene_title'];
    dishesCount = json['dishes_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scene_background'] = this.sceneBackground;
    data['scene_id'] = this.sceneId;
    data['scene_title'] = this.sceneTitle;
    data['dishes_count'] = this.dishesCount;
    return data;
  }
}