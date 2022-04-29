import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'config/config.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.setEnvironment(Environment.DEV);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Content Creator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      // home: FlutterSummernoteWidget(),
    );
  }
}
