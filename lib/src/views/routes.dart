import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:innsikt/src/features/stortinget/presentation/case_view/detailed_case_view.dart';
import 'package:innsikt/src/views/home_page.dart';

class Routes {
  static const String _home = '/';
  static const String _detailedPage = '/case';

  static String getHomeRoute() => _home;
  static String getDetailedRoute() => _detailedPage;

  static final List<GetPage> _pages = [
    GetPage(name: _home, page: () => const HomePage()),
    GetPage(name: _detailedPage, page: () => const DetailedCaseView())
  ];

  static List<GetPage> getRoutes() => _pages;
}