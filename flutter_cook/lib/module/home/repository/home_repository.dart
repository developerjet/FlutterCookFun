/// 首页 Repository
/// 
/// 职责：
/// 1. 管理首页所有网络请求
/// 2. 处理数据转换和验证
/// 3. 实现统一的错误处理

import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter_cook/base/repository/base_repository.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/utils/networking/networking.dart';

class HomeRepository extends BaseRepository {
  static const String _tag = 'HomeRepository';

  /// 模块质量权重（越高越优先推荐）
  static const Map<String, double> _moduleWeights = {
    '14': 0.80, // 今日新品
    '15': 0.90, // 美食研究所
    '16': 0.80, // 为你甄选
    '17': 0.70, // 吃货种草机
    '18': 0.95, // 活动专题（最适合作 Banner）
    '22': 0.85, // 热门专题
  };

  /// 跳过的模块（空 banner、功能入口、用户头像）
  static const Set<String> _skipModuleIds = {'12', '13', '19', '20'};

  /// 轮播最大条目数
  static const int _maxBannerItems = 6;

  /// 单模块最多抽取条数（多样性保障）
  static const int _maxItemsPerModule = 2;

  /// 获取首页 Banner 数据
  Future<HomeBannerModel> fetchBannerData({
    String? deviceModel,
    String? systemVersion,
    String? appVersion,
  }) async {
    // 尝试 page=4
    HomeBannerModel model = await _fetchBannerData(
      deviceModel: deviceModel,
      systemVersion: systemVersion,
      appVersion: appVersion,
      page: '4',
    );

    // 优先：跨模块推荐提取
    final recommended = _buildCrossModuleBanner(model);
    if (recommended != null) return recommended;

    // 其次：原始 Banner 数据
    if (_hasValidBannerData(model)) return model;

    AppLogger.warning(
        _tag, 'HomePage banner empty (page=4), trying page=1 fallback');

    // 重试 page=1
    model = await _fetchBannerData(
      deviceModel: deviceModel,
      systemVersion: systemVersion,
      appVersion: appVersion,
      page: '1',
    );

    final recommended2 = _buildCrossModuleBanner(model);
    if (recommended2 != null) return recommended2;

    if (_hasValidBannerData(model)) return model;

    // 最终降级：本地占位
    AppLogger.warning(
        _tag, 'HomePage banner still empty after all strategies, using local fallback');
    return _buildLocalFallbackBanner();
  }

  Future<HomeBannerModel> _fetchBannerData({
    String? deviceModel,
    String? systemVersion,
    String? appVersion,
    String page = '4',
  }) async {
    return execute(
      () async {
        final params = {
          'devModel': deviceModel ?? 'iPhone',
          'sysVersion': systemVersion ?? '16.7.2',
          'appVersion': appVersion ?? '5.61',
          'version': appVersion ?? '5.61',
          'methodName': 'HomePage',
          'token': '0',
          'user_id': '0',
          'page': page,
        };

        try {
          AppLogger.logNetworkRequest('/home', 'GET', params);

          final response = await DioClient.get('', queryParameters: params);

          if (response.data == null) {
            throw DataException(
              message: 'load_failed_try_again'.tr,
              code: 'EMPTY_RESPONSE',
            );
          }

          final model = HomeBannerModel.fromJson(response.data);

          AppLogger.info(
            _tag,
            'Fetched banner data successfully: ${model.data?.moduleList?.length ?? 0} modules for page $page',
          );

          return model;
        } catch (e) {
          AppLogger.error(_tag, 'Failed to fetch banner data for page $page', e as Exception?);

          if (e is AppException) {
            rethrow;
          }

          throw NetworkException(
            message: 'load_failed_try_again'.tr,
            code: 'FETCH_BANNER_FAILED',
            originalException: e as Exception?,
          );
        }
      },
      maxRetries: 2,
    );
  }

  bool _hasValidBannerData(HomeBannerModel model) {
    return model.data?.moduleList?.any((module) {
          return module.moduleData?.any((item) {
                final picture = item.bannerPicture?.trim();
                return picture != null && picture.isNotEmpty && picture != 'null';
              }) == true;
        }) == true;
  }

  HomeBannerModel _buildLocalFallbackBanner() {
    return HomeBannerModel(
      data: HomeBannerData(
        moduleList: [
          ModuleList(
            moduleData: [
              ModuleData(
                bannerTitle: '精选菜谱',
                bannerPicture: 'assets/images/banner_placeholder.png',
                bannerLink: 'https://flutter.cn',
              ),
              ModuleData(
                bannerTitle: '热门推荐',
                bannerPicture: 'assets/images/banner_placeholder.png',
                bannerLink: 'https://flutter.cn',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 跨模块推荐提取：从所有非 Banner 模块中收集美食图片生成轮播数据。
  /// 返回 null 表示无可用候选项。
  HomeBannerModel? _buildCrossModuleBanner(HomeBannerModel model) {
    final modules = model.data?.moduleList;
    if (modules == null || modules.isEmpty) return null;

    final candidates = <_RecommendationCandidate>[];

    for (final module in modules) {
      final moduleId = module.moduleId;
      if (moduleId == null || _skipModuleIds.contains(moduleId)) continue;

      final items = module.moduleData;
      if (items == null || items.isEmpty) continue;

      for (final item in items) {
        final candidate = _extractCandidate(item, moduleId);
        if (candidate != null) {
          candidates.add(candidate);
        }
      }
    }

    if (candidates.isEmpty) return null;

    // 按评分降序
    candidates.sort((a, b) => b.score.compareTo(a.score));

    // 多样性裁剪：每模块最多 _maxItemsPerModule 条
    final selected = <_RecommendationCandidate>[];
    final moduleCounts = <String, int>{};

    for (final candidate in candidates) {
      final count = moduleCounts[candidate.moduleId] ?? 0;
      if (count >= _maxItemsPerModule) continue;

      selected.add(candidate);
      moduleCounts[candidate.moduleId] = count + 1;

      if (selected.length >= _maxBannerItems) break;
    }

    if (selected.isEmpty) return null;

    // 合成为 ModuleData（复用 banner 字段）
    final moduleDataList = selected.map((c) => ModuleData(
          bannerTitle: c.title,
          bannerPicture: c.image,
          bannerLink: c.link,
        )).toList();

    AppLogger.info(
      _tag,
      'Cross-module banner built: ${moduleDataList.length} items from '
      '${moduleCounts.keys.length} modules',
    );

    return HomeBannerModel(
      data: HomeBannerData(
        moduleList: [
          ModuleList(
            moduleId: '999',
            moduleName: '智能推荐',
            moduleData: moduleDataList,
          ),
        ],
      ),
    );
  }

  /// 从单个 ModuleData 中提取推荐候选项，按模块 ID 映射字段。
  _RecommendationCandidate? _extractCandidate(
      ModuleData item, String moduleId) {
    String? image;
    String? title;
    String? link;

    switch (moduleId) {
      case '14': // 今日新品
        image = item.dishesImage;
        title = item.dishesName;
        link = _buildAppLink('dish', item.dishesId);
        break;
      case '15': // 美食研究所
        image = item.seriesImage;
        title = item.seriesName ?? item.description;
        link = _buildAppLink('series', item.seriesId);
        break;
      case '16': // 为你甄选
        image = item.dishesImage;
        title = item.dishesName;
        link = _buildAppLink('dish', item.dishesId);
        break;
      case '17': // 吃货种草机
        image = item.imgUrl;
        title = item.title;
        link = item.linkUrl;
        break;
      case '18': // 活动专题
        image = item.topicPicture;
        title = item.title;
        link = item.link;
        break;
      case '22': // 热门专题
        image = item.seriesImage;
        title = item.seriesTitle ?? item.seriesName;
        link = _buildAppLink('series', item.seriesId);
        break;
      default:
        return null;
    }

    // 硬门禁：图片必须有效
    final trimmedImage = image?.trim();
    if (trimmedImage == null ||
        trimmedImage.isEmpty ||
        trimmedImage == 'null') {
      return null;
    }

    final hasTitle = title != null && title.isNotEmpty && title != 'null';
    final hasLink = link != null && link.isNotEmpty && link != 'null';

    final score = _calculateRecommendationScore(
      moduleId: moduleId,
      hasImage: true,
      hasTitle: hasTitle,
      hasLink: hasLink,
      imageUrl: trimmedImage,
    );

    return _RecommendationCandidate(
      moduleId: moduleId,
      image: trimmedImage,
      title: hasTitle ? title : null,
      link: hasLink ? link : null,
      score: score,
    );
  }

  /// 为无直接链接的模块生成 app:// 协议链接
  String? _buildAppLink(String type, String? id) {
    if (id == null || id.isEmpty || id == 'null') return null;
    return 'app://$type?id=$id';
  }

  /// 推荐评分算法
  double _calculateRecommendationScore({
    required String moduleId,
    required bool hasImage,
    required bool hasTitle,
    required bool hasLink,
    required String imageUrl,
  }) {
    final weight = _moduleWeights[moduleId] ?? 0.5;

    double score = weight *
        (0.5 + // 基础分
            (hasImage ? 0.30 : 0.0) +
            (hasTitle ? 0.10 : 0.0) +
            (hasLink ? 0.10 : 0.0));

    // 图片质量加分
    if (_hasGoodImageQuality(imageUrl)) {
      score += 0.03;
    }

    // 随机抖动（0 ~ 0.06），保证每次刷新的多样性
    score += Random().nextDouble() * 0.06;

    return score;
  }

  /// 图片 URL 质量启发式检查
  bool _hasGoodImageQuality(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return false;
    }
    final lower = url.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp');
  }

  /// 获取首页列表数据
  Future<HomeDataModel> fetchHomeListData({
    String methodName = 'CategoryIndex',
    String version = '4.3.2',
  }) async {
    return execute(
      () async {
        final params = {
          'methodName': methodName,
          'version': version,
        };

        try {
          AppLogger.logNetworkRequest('/home/list', 'GET', params);
          
          final response = await DioClient.get('', queryParameters: params);
          
          if (response.data == null || response.data['data'] == null) {
            throw DataException(
              message: 'load_failed_try_again'.tr,
              code: 'EMPTY_LIST_DATA',
            );
          }

          final model = HomeDataModel.fromJson(response.data['data']);
          
          AppLogger.info(
            _tag,
            'Fetched list data successfully: ${model.data.length} items',
          );
          
          return model;
        } catch (e) {
          AppLogger.error(_tag, 'Failed to fetch list data', e as Exception?);
          
          if (e is AppException) {
            rethrow;
          }
          
          throw NetworkException(
            message: 'load_failed_try_again'.tr,
            code: 'FETCH_LIST_FAILED',
            originalException: e as Exception?,
          );
        }
      },
      maxRetries: 2,
    );
  }
}

/// 推荐候选项（跨模块提取的内部数据类）
class _RecommendationCandidate {
  final String moduleId;
  final String image;
  final String? title;
  final String? link;
  final double score;

  const _RecommendationCandidate({
    required this.moduleId,
    required this.image,
    this.title,
    this.link,
    required this.score,
  });
}
