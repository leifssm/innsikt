import 'package:get/get.dart';

mixin StandaloneControllerMixin<T> on GetView<T> {
  @override
  String get tag => key!.toString();

  void control(T controller) {
    if (key == null) {
      throw Exception("Key must be set for StandaloneControllerMixin");
    }
    Get.put(controller, tag: tag);
  }
}
