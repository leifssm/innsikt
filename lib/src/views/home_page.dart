import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/data/stortinget_repository.dart';
import 'package:innsikt/src/features/stortinget/domain/sessions.dart';
import 'package:innsikt/src/utils/fluid.dart';

class HomePageController extends GetxController {
  final title = 'Hello World'.obs;
  final sessions = Fluid.loading<Sessions>().obs;
  final repository = StortingetRepository.create();

  void fetch() async {
    sessions.updateAsync(repository.getError);
  }

  String get str {
    if (sessions.isLoading) return 'Loading...';
    if (sessions.isError) return 'Error: ${sessions.error}';
    return 'Success: Fetched ${sessions.data!.sessions.length} sessions';
  }
}

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());

    return Obx(
      () => Scaffold(
        body: TextButton(onPressed: controller.fetch, child: Text(controller.str)),
      ),
    );
  }
}
