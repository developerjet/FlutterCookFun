class SearchDataModel {
  Top? top;
  Second? second;
  List<SearchDataListModel>? data;

  SearchDataModel({this.top, this.second, this.data});

  SearchDataModel.fromJson(Map<String, dynamic> json) {
    top = json['top'] != null ? new Top.fromJson(json['top']) : null;
    second =
        json['second'] != null ? new Second.fromJson(json['second']) : null;
    if (json['data'] != null) {
      data = <SearchDataListModel>[];
      json['data'].forEach((v) {
        data!.add(new SearchDataListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.top != null) {
      data['top'] = this.top!.toJson();
    }
    if (this.second != null) {
      data['second'] = this.second!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Top {
  int? count;
  List<TopData>? data;

  Top({this.count, this.data});

  Top.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <TopData>[];
      json['data'].forEach((v) {
        data!.add(new TopData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TopData {
  String? id;
  String? title;
  String? image;

  TopData({this.id, this.title, this.image});

  TopData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    return data;
  }
}

class Second {
  String? total;
  String? courseName;

  Second({this.total, this.courseName});

  Second.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    courseName = json['course_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['course_name'] = this.courseName;
    return data;
  }
}

class SearchDataListModel {
  String? id;
  String? text;

  SearchDataListModel({this.id, this.text});

  SearchDataListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }
}