import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/repository/home_repository.dart';
import 'package:flutter_cook/utils/error_handler.dart';

import '../helpers/mocks.dart';

class FakeHomeBannerModel extends Fake implements HomeBannerModel {}

void main() {
  late MockDioClient mockClient;
  late MockBannerService mockBannerService;
  late HomeRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeHomeBannerModel());
  });

  setUp(() {
    mockClient = MockDioClient();
    mockBannerService = MockBannerService();
    repository = HomeRepository(
      client: mockClient,
      bannerService: mockBannerService,
    );
  });

  group('fetchBannerData', () {
    test('returns banner from cross-module recommendation', () async {
      final rawData = {'data': {'module_list': []}};

      when(() => mockClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: rawData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final mockBanner = HomeBannerModel(
          data: HomeBannerData(moduleList: []));
      when(() => mockBannerService.buildCrossModuleBanner(any()))
          .thenReturn(mockBanner);

      final result = await repository.fetchBannerData();

      expect(result, mockBanner);
    });

    test('throws NetworkException on connection error', () async {
      when(() => mockClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(
        NetworkException(message: 'no connection', code: 'CONNECTION_ERROR'),
      );

      expect(
        () => repository.fetchBannerData(),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
