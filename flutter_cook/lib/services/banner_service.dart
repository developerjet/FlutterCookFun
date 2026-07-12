import 'dart:math';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';

/// Banner 跨模块推荐服务
///
/// 从首页多模块数据中智能提取轮播图候选项，按权重评分排序。
class BannerService {
  static const Map<String, double> _moduleWeights = {
    '14': 0.80, // 今日新品
    '15': 0.90, // 美食研究所
    '16': 0.80, // 为你甄选
    '17': 0.70, // 吃货种草机
    '18': 0.95, // 活动专题
    '22': 0.85, // 热门专题
  };

  static const Set<String> _skipModuleIds = {'12', '13', '19', '20'};
  static const int _maxBannerItems = 6;
  static const int _maxItemsPerModule = 2;

  /// 跨模块推荐 Banner — 返回 null 表示无可用候选项
  HomeBannerModel? buildCrossModuleBanner(HomeBannerModel model) {
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
        if (candidate != null) candidates.add(candidate);
      }
    }

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) => b.score.compareTo(a.score));

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

    final moduleDataList = selected
        .map((c) => ModuleData(
              bannerTitle: c.title,
              bannerPicture: c.image,
              bannerLink: c.link,
            ))
        .toList();

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

  /// 本地兜底 Banner（离线占位）
  HomeBannerModel buildLocalFallbackBanner() {
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

  /// 检查 Banner 数据是否有效（有非空图片）
  bool hasValidBannerData(HomeBannerModel model) {
    return model.data?.moduleList?.any((module) {
          return module.moduleData?.any((item) {
                final picture = item.bannerPicture?.trim();
                return picture != null &&
                    picture.isNotEmpty &&
                    picture != 'null';
              }) ==
              true;
        }) ==
        true;
  }

  _RecommendationCandidate? _extractCandidate(
      ModuleData item, String moduleId) {
    String? image;
    String? title;
    String? link;

    switch (moduleId) {
      case '14':
        image = item.dishesImage;
        title = item.dishesName;
        link = _buildAppLink('dish', item.dishesId);
        break;
      case '15':
        image = item.seriesImage;
        title = item.seriesName ?? item.description;
        link = _buildAppLink('series', item.seriesId);
        break;
      case '16':
        image = item.dishesImage;
        title = item.dishesName;
        link = _buildAppLink('dish', item.dishesId);
        break;
      case '17':
        image = item.imgUrl;
        title = item.title;
        link = item.linkUrl;
        break;
      case '18':
        image = item.topicPicture;
        title = item.title;
        link = item.link;
        break;
      case '22':
        image = item.seriesImage;
        title = item.seriesTitle ?? item.seriesName;
        link = _buildAppLink('series', item.seriesId);
        break;
      default:
        return null;
    }

    final trimmedImage = image?.trim();
    if (trimmedImage == null ||
        trimmedImage.isEmpty ||
        trimmedImage == 'null') {
      return null;
    }

    final hasTitle = title != null && title.isNotEmpty && title != 'null';
    final hasLink = link != null && link.isNotEmpty && link != 'null';

    final score = _calculateScore(
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

  String? _buildAppLink(String type, String? id) {
    if (id == null || id.isEmpty || id == 'null') return null;
    return 'app://$type?id=$id';
  }

  double _calculateScore({
    required String moduleId,
    required bool hasImage,
    required bool hasTitle,
    required bool hasLink,
    required String imageUrl,
  }) {
    final weight = _moduleWeights[moduleId] ?? 0.5;
    double score = weight *
        (0.5 +
            (hasImage ? 0.30 : 0.0) +
            (hasTitle ? 0.10 : 0.0) +
            (hasLink ? 0.10 : 0.0));
    if (_hasGoodImageQuality(imageUrl)) score += 0.03;
    score += Random().nextDouble() * 0.06;
    return score;
  }

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
}

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
