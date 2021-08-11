// @dart=2.9
import 'package:absensi/pages/auth/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  // RenderErrorBox.backgroundColor = Colors.transparent;
  // RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absensi Sistem',
      home: SplashScreen(),
    );
  }
}
