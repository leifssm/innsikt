import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  final RxString title = 'Hello World'.obs;
}

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    return Obx(() => Text(controller.title.value));
  }
}

