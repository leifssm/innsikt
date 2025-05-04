import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:innsikt/src/views/home_page.dart';

class Routes {
  static const String _home = '/';

  static String getHomeRoute() => _home;

  static final List<GetPage> _pages = [
    GetPage(name: _home, page: () => const HomePage()),
  ];

  static List<GetPage> getRoutes() => _pages;
}