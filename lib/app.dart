import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'src/themes/innsikt_theme.dart';
import 'src/views/routes.dart';

import 'src/localization/innsikt_translations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: InnsiktTheme.createTheme(),
      translations: InnsiktTranslations(),
      locale: Locale('no', 'NO'),
      getPages: Routes.getRoutes(),
      initialRoute: Routes.getHomeRoute(),
    );
  }
}
