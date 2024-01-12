class BookListModel {
  int? _dishCount;
  int? _isNew;
  String? _sceneBackground;
  String? _sceneDesc;
  int? _sceneId;
  String? _sceneTitle;
  int? _sceneType;
  String? _thumbnail;

  BookListModel(
      {int? dishCount,
      int? isNew,
      String? sceneBackground,
      String? sceneDesc,
      int? sceneId,
      String? sceneTitle,
      int? sceneType,
      String? thumbnail}) {
    if (dishCount != null) {
      this._dishCount = dishCount;
    }
    if (isNew != null) {
      this._isNew = isNew;
    }
    if (sceneBackground != null) {
      this._sceneBackground = sceneBackground;
    }
    if (sceneDesc != null) {
      this._sceneDesc = sceneDesc;
    }
    if (sceneId != null) {
      this._sceneId = sceneId;
    }
    if (sceneTitle != null) {
      this._sceneTitle = sceneTitle;
    }
    if (sceneType != null) {
      this._sceneType = sceneType;
    }
    if (thumbnail != null) {
      this._thumbnail = thumbnail;
    }
  }

  int? get dishCount => _dishCount;
  set dishCount(int? dishCount) => _dishCount = dishCount;
  int? get isNew => _isNew;
  set isNew(int? isNew) => _isNew = isNew;
  String? get sceneBackground => _sceneBackground;
  set sceneBackground(String? sceneBackground) =>
      _sceneBackground = sceneBackground;
  String? get sceneDesc => _sceneDesc;
  set sceneDesc(String? sceneDesc) => _sceneDesc = sceneDesc;
  int? get sceneId => _sceneId;
  set sceneId(int? sceneId) => _sceneId = sceneId;
  String? get sceneTitle => _sceneTitle;
  set sceneTitle(String? sceneTitle) => _sceneTitle = sceneTitle;
  int? get sceneType => _sceneType;
  set sceneType(int? sceneType) => _sceneType = sceneType;
  String? get thumbnail => _thumbnail;
  set thumbnail(String? thumbnail) => _thumbnail = thumbnail;

  BookListModel.fromJson(Map<String, dynamic> json) {
    _dishCount = json['dish_count'];
    _isNew = json['is_new'];
    _sceneBackground = json['scene_background'];
    _sceneDesc = json['scene_desc'];
    _sceneId = json['scene_id'];
    _sceneTitle = json['scene_title'];
    _sceneType = json['scene_type'];
    _thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dish_count'] = this._dishCount;
    data['is_new'] = this._isNew;
    data['scene_background'] = this._sceneBackground;
    data['scene_desc'] = this._sceneDesc;
    data['scene_id'] = this._sceneId;
    data['scene_title'] = this._sceneTitle;
    data['scene_type'] = this._sceneType;
    data['thumbnail'] = this._thumbnail;
    return data;
  }
}
