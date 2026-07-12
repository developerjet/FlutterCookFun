import 'package:mocktail/mocktail.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/services/banner_service.dart';
import 'package:flutter_cook/services/cook_service.dart';
import 'package:flutter_cook/services/book_service.dart';
import 'package:flutter_cook/module/home/repository/home_repository.dart';
import 'package:flutter_cook/module/cook/repository/cook_repository.dart';

class MockDioClient extends Mock implements DioClient {}
class MockHomeRepository extends Mock implements HomeRepository {}
class MockCookRepository extends Mock implements CookRepository {}
class MockBannerService extends Mock implements BannerService {}
class MockCookService extends Mock implements CookService {}
class MockBookService extends Mock implements BookService {}
