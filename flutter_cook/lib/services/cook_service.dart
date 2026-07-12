import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:flutter_cook/module/cook/repository/cook_repository.dart';
import 'package:flutter_cook/utils/error_handler.dart';

/// 烹饪模块业务服务层
///
/// 调用 Repository 获取数据，处理数据转换和验证。
class CookService {
  final CookRepository repository;

  CookService({required this.repository});

  Future<List<CookHomeListModel>> fetchCookHomeData() async {
    try {
      return await repository.fetchCookHomeData();
    } on AppException {
      rethrow;
    } catch (e) {
      throw DataException(
        message: 'load_failed_try_again',
        code: 'COOK_HOME_FAILED',
        originalException: e is Exception ? e : null,
      );
    }
  }

  Future<List<CookConfigListModel>> fetchCookConfigData(
      Map<String, dynamic> params) async {
    try {
      return await repository.fetchCookConfigData(params);
    } on AppException {
      rethrow;
    } catch (e) {
      throw DataException(
        message: 'load_failed_try_again',
        code: 'COOK_CONFIG_FAILED',
        originalException: e is Exception ? e : null,
      );
    }
  }

  Future<CookStepDataModel> fetchCookSteps(String dishesId) async {
    try {
      return await repository.fetchCookStepsData(dishesId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw DataException(
        message: 'load_failed_try_again',
        code: 'COOK_STEPS_FAILED',
        originalException: e is Exception ? e : null,
      );
    }
  }
}
