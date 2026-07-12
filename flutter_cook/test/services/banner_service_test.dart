import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cook/services/banner_service.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';

void main() {
  group('BannerService', () {
    late BannerService service;

    setUp(() {
      service = BannerService();
    });

    test('buildCrossModuleBanner returns null for null data', () {
      final model = HomeBannerModel(data: null);
      expect(service.buildCrossModuleBanner(model), isNull);
    });

    test('buildCrossModuleBanner returns null for empty module list', () {
      final model = HomeBannerModel(
        data: HomeBannerData(moduleList: []),
      );
      expect(service.buildCrossModuleBanner(model), isNull);
    });

    test('hasValidBannerData returns false for empty modules', () {
      final model = HomeBannerModel(
        data: HomeBannerData(moduleList: []),
      );
      expect(service.hasValidBannerData(model), false);
    });

    test('hasValidBannerData returns false when all banners empty', () {
      final model = HomeBannerModel(
        data: HomeBannerData(moduleList: [
          ModuleList(moduleData: [
            ModuleData(bannerPicture: '', bannerTitle: '', bannerLink: ''),
          ]),
        ]),
      );
      expect(service.hasValidBannerData(model), false);
    });

    test('buildLocalFallbackBanner returns placeholder banner', () {
      final banner = service.buildLocalFallbackBanner();
      final modules = banner.data?.moduleList;
      expect(modules, isNotNull);
      expect(modules!.length, 1);
      expect(modules.first.moduleData?.length, 2);
      expect(modules.first.moduleData?[0].bannerTitle, '精选菜谱');
    });
  });
}
