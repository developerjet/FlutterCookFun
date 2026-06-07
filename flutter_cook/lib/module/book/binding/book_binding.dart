import 'package:get/get.dart';
import '../controller/book_controller.dart';

class BookBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookController>(() => BookController());
  }
}
