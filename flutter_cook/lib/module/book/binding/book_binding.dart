import 'package:get/get.dart';
import 'package:flutter_cook/services/book_service.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import '../controller/book_controller.dart';

class BookBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookService>(
        () => BookService(client: Get.find<DioClient>()));
    Get.lazyPut<BookController>(
        () => BookController(service: Get.find<BookService>()));
  }
}
