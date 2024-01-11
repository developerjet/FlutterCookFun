
class CookConfigListModel {
  String? dishesId;
  String? title;
  String? description;
  String? video;
  String? video1;
  String? image;
  String? hardLevel;
  String? play;
  String? cookingTime;
  String? collectCount;
  String? taste;
  int? createDate;
  String? content;
  List<CookTagsInfo>? tagsInfo;

  CookConfigListModel(
      {this.dishesId,
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
      this.tagsInfo});

  CookConfigListModel.fromJson(Map<String, dynamic> json) {
    dishesId = json['dishes_id'];
    title = json['title'];
    description = json['description'];
    video = json['video'];
    video1 = json['video1'];
    image = json['image'];
    hardLevel = json['hard_level'];
    play = json['play'];
    cookingTime = json['cooking_time'];
    collectCount = json['collect_count'];
    taste = json['taste'];
    createDate = json['create_date'];
    content = json['content'];
    if (json['tags_info'] != null) {
      tagsInfo = <CookTagsInfo>[];
      json['tags_info'].forEach((v) {
        tagsInfo!.add(new CookTagsInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dishes_id'] = this.dishesId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['video'] = this.video;
    data['video1'] = this.video1;
    data['image'] = this.image;
    data['hard_level'] = this.hardLevel;
    data['play'] = this.play;
    data['cooking_time'] = this.cookingTime;
    data['collect_count'] = this.collectCount;
    data['taste'] = this.taste;
    data['create_date'] = this.createDate;
    data['content'] = this.content;
    if (this.tagsInfo != null) {
      data['tags_info'] = this.tagsInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CookTagsInfo {
  int? id;
  String? text;
  int? type;

  CookTagsInfo({this.id, this.text, this.type});

  CookTagsInfo.fromJson(Map<String, dynamic> json) {
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