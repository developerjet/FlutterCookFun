import 'package:get/get.dart';
import 'package:flutter_cook/base/repository/base_repository.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/services/banner_service.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/utils/networking/networking.dart';

class HomeRepository extends BaseRepository {
  static const String _tag = 'HomeRepository';

  final BannerService bannerService;

  HomeRepository({
    required DioClient client,
    BannerService? bannerService,
  })  : bannerService = bannerService ?? BannerService(),
      super(client: client);

  /// 获取首页 Banner 数据（含跨模块推荐 + page 回退）
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

    // 优先：跨模块推荐
    final recommended = bannerService.buildCrossModuleBanner(model);
    if (recommended != null) return recommended;

    // 其次：原始 Banner
    if (bannerService.hasValidBannerData(model)) return model;

    AppLogger.warning(
        _tag, 'HomePage banner empty (page=4), trying page=1 fallback');

    // 重试 page=1
    model = await _fetchBannerData(
      deviceModel: deviceModel,
      systemVersion: systemVersion,
      appVersion: appVersion,
      page: '1',
    );

    final recommended2 = bannerService.buildCrossModuleBanner(model);
    if (recommended2 != null) return recommended2;

    if (bannerService.hasValidBannerData(model)) return model;

    // 最终降级
    AppLogger.warning(_tag,
        'HomePage banner still empty after all strategies, using local fallback');
    return bannerService.buildLocalFallbackBanner();
  }

  Future<HomeBannerModel> _fetchBannerData({
    String? deviceModel,
    String? systemVersion,
    String? appVersion,
    String page = '4',
  }) async {
    return execute(() async {
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
        final response = await client.get('', queryParameters: params);

        if (response.data == null) {
          throw DataException(
            message: 'load_failed_try_again'.tr,
            code: 'EMPTY_RESPONSE',
          );
        }

        final model = HomeBannerModel.fromJson(response.data);

        AppLogger.info(
          _tag,
          'Fetched banner data: ${model.data?.moduleList?.length ?? 0} modules, page $page',
        );

        return model;
      } catch (e) {
        AppLogger.error(_tag, 'Failed to fetch banner data for page $page', e);
        if (e is AppException) rethrow;
        throw NetworkException(
          message: 'load_failed_try_again'.tr,
          code: 'FETCH_BANNER_FAILED',
          originalException: e is Exception ? e : null,
        );
      }
    }, maxRetries: 2);
  }

  /// 获取首页列表数据
  Future<HomeDataModel> fetchHomeListData({
    String methodName = 'CategoryIndex',
    String version = '4.3.2',
  }) async {
    return execute(() async {
      final params = {
        'methodName': methodName,
        'version': version,
      };

      try {
        AppLogger.logNetworkRequest('/home/list', 'GET', params);
        final response = await client.get('', queryParameters: params);

        if (response.data == null || response.data['data'] == null) {
          throw DataException(
            message: 'load_failed_try_again'.tr,
            code: 'EMPTY_LIST_DATA',
          );
        }

        final model = HomeDataModel.fromJson(response.data['data']);

        AppLogger.info(
          _tag,
          'Fetched list data: ${model.data.length} items',
        );

        return model;
      } catch (e) {
        AppLogger.error(_tag, 'Failed to fetch list data', e);
        if (e is AppException) rethrow;
        throw NetworkException(
          message: 'load_failed_try_again'.tr,
          code: 'FETCH_LIST_FAILED',
          originalException: e is Exception ? e : null,
        );
      }
    }, maxRetries: 2);
  }
}
