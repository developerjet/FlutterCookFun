import 'package:json_annotation/json_annotation.dart';

part 'home_list_model.g.dart';

/// 首页数据模型
@JsonSerializable()
class HomeDataModel {
  final List<HomeFoodListData> data;

  HomeDataModel({this.data = const []});

  factory HomeDataModel.fromJson(Map<String, dynamic> json) =>
      _$HomeDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataModelToJson(this);
}

/// 首页食材分类数据
@JsonSerializable()
class HomeFoodListData {
  final String? image;
  final String? id;
  final String? text;
  final int? type;

  @JsonKey(name: 'order_no')
  final int? orderNo;

  @JsonKey(name: 'tag_isselfdefine')
  final int? tagIsselfdefine;

  final List<FoodSubData>? data;

  HomeFoodListData({
    this.image,
    this.id,
    this.text,
    this.type,
    this.orderNo,
    this.tagIsselfdefine,
    this.data,
  });

  factory HomeFoodListData.fromJson(Map<String, dynamic> json) =>
      _$HomeFoodListDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFoodListDataToJson(this);
}

/// 食材子分类数据
@JsonSerializable()
class FoodSubData {
  final String? id;
  final String? text;

  @JsonKey(name: 'tag_isselfdefine')
  final int? tagIsselfdefine;

  final int? type;

  @JsonKey(name: 'order_no')
  final int? orderNo;

  final String? image;

  FoodSubData({
    this.id,
    this.text,
    this.tagIsselfdefine,
    this.type,
    this.orderNo,
    this.image,
  });

  factory FoodSubData.fromJson(Map<String, dynamic> json) =>
      _$FoodSubDataFromJson(json);

  Map<String, dynamic> toJson() => _$FoodSubDataToJson(this);
}

/// 首页分类页的强类型路由参数。
///
/// [title] 用于页面标题，[categories] 为需要展示的一个或多个完整分类。
class FoodClassPageArguments {
  final String title;
  final List<HomeFoodListData> categories;

  /// Parameters:
  /// - [title]: 分类页标题。
  /// - [categories]: 不可为空的分类集合。
  FoodClassPageArguments({
    required this.title,
    required List<HomeFoodListData> categories,
  })  : assert(categories.isNotEmpty),
        categories = List.unmodifiable(categories);
}
