class CookHomeListModel {
  String? _id;
  String? _text;
  String? _image;
  List<CookListDataModel>? _data;

  CookHomeListModel(
      {String? id, String? text, String? image, List<CookListDataModel>? data}) {
    if (id != null) {
      this._id = id;
    }
    if (text != null) {
      this._text = text;
    }
    if (image != null) {
      this._image = image;
    }
    if (data != null) {
      this._data = data;
    }
  }

  String? get id => _id;
  set id(String? id) => _id = id;
  String? get text => _text;
  set text(String? text) => _text = text;
  String? get image => _image;
  set image(String? image) => _image = image;
  List<CookListDataModel>? get data => _data;
  set data(List<CookListDataModel>? data) => _data = data;

  CookHomeListModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _text = json['text'];
    _image = json['image'];
    if (json['data'] != null) {
      _data = <CookListDataModel>[];
      json['data'].forEach((v) {
        _data!.add(new CookListDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['text'] = this._text;
    data['image'] = this._image;
    if (this._data != null) {
      data['data'] = this._data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CookListDataModel {
  String? _id;
  String? _text;
  String? _image;

  CookListDataModel({String? id, String? text, String? image}) {
    if (id != null) {
      this._id = id;
    }
    if (text != null) {
      this._text = text;
    }
    if (image != null) {
      this._image = image;
    }
  }

  String? get id => _id;
  set id(String? id) => _id = id;
  String? get text => _text;
  set text(String? text) => _text = text;
  String? get image => _image;
  set image(String? image) => _image = image;

  CookListDataModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _text = json['text'];
    _image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['text'] = this._text;
    data['image'] = this._image;
    return data;
  }
}