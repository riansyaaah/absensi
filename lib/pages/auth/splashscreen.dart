import 'dart:async';

import 'package:absensi/pages/auth/login.dart';
import 'package:absensi/pages/main_menu.dart';
import 'package:absensi/style/colors.dart';
import 'package:absensi/style/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = "";
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      if (preferences.getString("PREF_TOKEN") == null ||
          preferences.getString("PREF_TOKEN") == "") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainMenu()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: Get.width * 1,
            height: Get.height * 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff0093e6), Color(0x33ecff16)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ABSENSI",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontFamily: "Sansation Light",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Get.width * 0.2),
                    child: Text(
                      "Recording Your Attendance",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: "Sansation Light",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
