import 'package:get/get.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import '../controller/book_controller.dart';

class BookBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookController>(
        () => BookController(client: Get.find<DioClient>()));
  }
}
