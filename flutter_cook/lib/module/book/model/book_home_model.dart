import 'package:json_annotation/json_annotation.dart';

part 'book_home_model.g.dart';

@JsonSerializable()
class BookListModel {
  @JsonKey(name: 'dishes_name')
  final String? dishesName;
  @JsonKey(name: 'dish_count')
  final int? dishCount;
  @JsonKey(name: 'is_new')
  final int? isNew;
  @JsonKey(name: 'scene_background')
  final String? sceneBackground;
  @JsonKey(name: 'scene_desc')
  final String? sceneDesc;
  @JsonKey(name: 'scene_id')
  final int? sceneId;
  @JsonKey(name: 'scene_title')
  final String? sceneTitle;
  @JsonKey(name: 'scene_type')
  final int? sceneType;
  final String? thumbnail;

  const BookListModel({
    this.dishesName,
    this.dishCount,
    this.isNew,
    this.sceneBackground,
    this.sceneDesc,
    this.sceneId,
    this.sceneTitle,
    this.sceneType,
    this.thumbnail,
  });

  factory BookListModel.fromJson(Map<String, dynamic> json) =>
      _$BookListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookListModelToJson(this);
}

/// 菜谱专题分页结果。
///
/// 将接口分页元数据与专题列表作为一个不可分割的结果返回，避免页面通过当前列表长度猜测总量。
class BookListPage {
  final List<BookListModel> items;
  final int page;
  final int pageSize;
  final int totalCount;

  /// Parameters:
  /// - [items]: 当前页专题列表。
  /// - [page]: 当前页码，从 1 开始。
  /// - [pageSize]: 服务端返回的分页大小。
  /// - [totalCount]: 服务端专题总数。
  BookListPage({
    required List<BookListModel> items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  }) : items = List.unmodifiable(items);

  /// Returns: 是否仍有下一页数据。
  bool get hasMore {
    if (totalCount > 0) {
      return page * pageSize < totalCount;
    }
    return items.length >= pageSize;
  }
}
