/// 烹饪模块 Repository
///
/// 职责：
/// 1. 管理烹饪模块网络请求
/// 2. 处理接口返回数据验证和类型转换
/// 3. 统一错误分类和日志记录

import 'package:get/get.dart';
import 'package:flutter_cook/base/repository/base_repository.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/utils/networking/networking.dart';

class CookRepository extends BaseRepository {
  static const String _tag = 'CookRepository';

  Future<List<CookHomeListModel>> fetchCookHomeData({
    String methodName = 'MaterialSubtype',
    String version = '4.3.2',
  }) async {
    return execute(
      () async {
        final params = {
          'methodName': methodName,
          'version': version,
        };

        AppLogger.logNetworkRequest('/cook/home', 'GET', params);

        final response = await DioClient.get('', queryParameters: params);
        final responseData = response.data;

        if (responseData == null || responseData['data'] == null) {
          throw DataException(
            message: 'load_failed_try_again'.tr,
            code: 'EMPTY_COOK_HOME_DATA',
          );
        }

        final jsonList = responseData['data']?['data'] as List?;
        if (jsonList == null) {
          throw DataException(
            message: 'load_failed_try_again'.tr,
            code: 'INVALID_COOK_HOME_DATA',
          );
        }

        final list = jsonList
            .whereType<Map<String, dynamic>>()
            .map((item) => CookHomeListModel.fromJson(item))
            .toList();

        AppLogger.info(
          _tag,
          'Fetched cook home data successfully: ${list.length} groups',
        );

        return list;
      },
      maxRetries: 2,
    );
  }

  Future<List<CookConfigListModel>> fetchCookConfigData(
    Map<String, dynamic> params,
  ) async {
    return execute(
      () async {
        AppLogger.logNetworkRequest('/cook/config', 'GET', params);

        final response = await DioClient.get('', queryParameters: params);
        final responseData = response.data;

        if (responseData == null || responseData['data'] == null) {
          throw DataException(
            message: 'load_failed_try_again'.tr,
            code: 'EMPTY_COOK_CONFIG_DATA',
          );
        }

        final jsonList = responseData['data']?['data'] as List?;
        if (jsonList == null) {
          throw DataException(
            message: 'load_failed_try_again'.tr,
            code: 'INVALID_COOK_CONFIG_DATA',
          );
        }

        final list = jsonList
            .whereType<Map<String, dynamic>>()
            .map((item) => CookConfigListModel.fromJson(item))
            .toList();

        AppLogger.info(
          _tag,
          'Fetched cook config data successfully: ${list.length} items',
        );

        return list;
      },
      maxRetries: 2,
    );
  }

  Future<CookStepDataModel> fetchCookStepsData(String dishesId) async {
    return execute(
      () async {
        final params = {
          'methodName': 'DishesView',
          'version': '4.3.2',
          'dishes_id': dishesId,
        };

        AppLogger.logNetworkRequest('/cook/steps', 'GET', params);

        final response = await DioClient.get('', queryParameters: params);
        final responseData = response.data;

        if (responseData == null || responseData['data'] == null) {
          throw DataException(
            message: 'load_failed_try_again'.tr,
            code: 'EMPTY_COOK_STEPS_DATA',
          );
        }

        final model = CookStepDataModel.fromJson(
          Map<String, dynamic>.from(responseData['data'] as Map),
        );

        AppLogger.info(_tag, 'Fetched cook steps data successfully: ${model.step?.length ?? 0} steps');

        return model;
      },
      maxRetries: 2,
    );
  }
}
