import 'package:get/get.dart';
import 'package:innsikt/src/features/stortinget/domain/representative/representative.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/detailed_case_view.dart';
import 'package:innsikt/src/features/stortinget/presentation/representative/representative_view.dart';
import 'package:innsikt/src/views/home_page.dart';

class Routes {
  static const String _home = '/';
  static const String _detailedCase = '/case';
  static const String _representative = '/representative';

  static String getHomeRoute() => _home;
  static String getDetailedCaseRoute() => _detailedCase;
  static String getRepresentativeRoute() => _representative;

  static void goToHome() {
    Get.toNamed(getHomeRoute());
  }

  static void goToDetailedCase(int caseId) {
    Get.toNamed(
      getDetailedCaseRoute(),
      preventDuplicates: false,
      parameters: {'caseId': caseId.toString()},
    );
  }

  static void goToRepresentativeRoute(Representative representative) {
    Get.toNamed(
      getRepresentativeRoute(),
      parameters: {'representativeId': representative.id.toString()},
      arguments: {'representative': representative},
    );
  }

  static final List<GetPage> _pages = [
    GetPage(name: _home, page: () => const HomePage()),
    GetPage(name: _detailedCase, page: () => const DetailedCaseView()),
    GetPage(name: _representative, page: () => const RepresentativeView()),
  ];

  static List<GetPage> getRoutes() => _pages;
}
