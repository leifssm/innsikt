import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/data/stortinget_repository.dart';

extension Repos on GetxController {
  StortingetRepository get stortinget => Get.find<StortingetRepository>();
}