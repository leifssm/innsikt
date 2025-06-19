import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innsikt/src/utils/extensions/units.dart';

class StandardScaffoldController extends GetxController {}

class StandardScaffold extends GetView<StandardScaffoldController> {
  final String title;
  final Widget body;
  const StandardScaffold({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    Get.put(StandardScaffoldController());
    return Scaffold(
      key: key,
      appBar: AppBar(title: Text(title), centerTitle: true),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.unit),
        child: body,
      ),
    );
  }
}
