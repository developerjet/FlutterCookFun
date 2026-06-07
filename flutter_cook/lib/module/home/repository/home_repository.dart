/// 首页 Repository
/// 
/// 职责：
/// 1. 管理首页所有网络请求
/// 2. 处理数据转换和验证
/// 3. 实现统一的错误处理

import 'package:get/get.dart';
import 'package:flutter_cook/base/repository/base_repository.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/utils/networking/networking.dart';

class HomeRepository extends BaseRepository {
  static const String _tag = 'HomeRepository';

  /// 获取首页 Banner 数据
  Future<HomeBannerModel> fetchBannerData({
    String? deviceModel,
    String? systemVersion,
    String? appVersion,
  }) async {
    HomeBannerModel model = await _fetchBannerData(
      deviceModel: deviceModel,
      systemVersion: systemVersion,
      appVersion: appVersion,
      page: '4',
    );

    if (_hasValidBannerData(model)) {
      return model;
    }

    AppLogger.warning(_tag, 'HomePage banner data is empty, trying alternate page parameter');

    model = await _fetchBannerData(
      deviceModel: deviceModel,
      systemVersion: systemVersion,
      appVersion: appVersion,
      page: '1',
    );

    if (_hasValidBannerData(model)) {
      return model;
    }

    AppLogger.warning(_tag, 'HomePage banner still empty after alternate request, using local fallback');
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
