import 'dart:convert';

import 'package:absensi/api/camera.service.dart';
import 'package:absensi/api/facenet.service.dart';
import 'package:absensi/api/service.dart';
import 'package:absensi/models/auth/cls_return_login.dart';
import 'package:absensi/models/database.dart';
import 'package:absensi/models/menu/cls_absen_hari_ini.dart';
import 'package:absensi/models/user.model.dart';
import 'package:absensi/pages/general_widget.dart/widget_progress.dart';
import 'package:absensi/pages/general_widget.dart/widget_snackbar.dart';
import 'package:absensi/pages/main_menu.dart';
import 'package:absensi/pages/widgets/app_button.dart';
import 'package:absensi/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(this._initializeControllerFuture,
      {Key? key,
      required this.onPressed,
      required this.isLogin,
      required this.reload,
      required this.absen});
  final Future _initializeControllerFuture;
  final Function()? onPressed;
  final bool isLogin;
  final Function reload;
  final Absen absen;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  /// service injection
  final FaceNetService _faceNetService = FaceNetService();

  String? predictedUser;

  Future _signUp(context) async {
    /// gets predicted data from facenet service (user face detected)
    ///
    List predictedData = _faceNetService.predictedDataList;
    print("========DAFTAR============");
    print(json.encode(predictedData));
    SharedPreferences pref = await SharedPreferences.getInstance();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());
    DataUser dataSubmit = new DataUser();
    print("===============SUBMIT===============");
    print(json.encode(predictedData));
    dataSubmit.facedata = json.encode(predictedData);
    getClient()
        .updateFaceData(pref.getString("PREF_TOKEN")!, dataSubmit)
        .then((res) async {
      Navigator.pop(context);
      if (res.statusJson) {
        pref.setString("PREF_FACE", json.encode(predictedData));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainMenu()),
            (Route<dynamic> route) => false);
        WidgetSnackbar(context: context, message: res.remarks, warna: "hijau");
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainMenu()),
            (Route<dynamic> route) => false);
        WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
      }
    }).catchError((Object obj) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainMenu()),
          (Route<dynamic> route) => false);
      WidgetSnackbar(
          context: context,
          message: "Failed connect to server!",
          warna: "merah");
    });

    /// resets the face stored in the face net sevice
    this._faceNetService.setPredictedData(null);
  }

  navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainMenu()),
        (Route<dynamic> route) => false);
  }

  Future _signIn(context) async {
    // ignore: unrelated_type_equality_checks
    if (this.predictedUser != "") {
      SharedPreferences pref = await SharedPreferences.getInstance();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => WidgetProgressSubmit());
      print(json.encode(widget.absen));
      getClient()
          .postAbsen(pref.getString("PREF_TOKEN")!, widget.absen)
          .then((res) async {
        Navigator.pop(context);
        if (res.statusJson) {
          displayDialog(context, res.remarks, true);
        } else {
          WidgetSnackbar(
              context: context, message: res.remarks, warna: "merah");
        }
      }).catchError((Object obj) {
        Navigator.pop(context);
        WidgetSnackbar(
            context: context,
            message: "Failed connect to server!",
            warna: "merah");
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Wajah tidak cocok!'),
          );
        },
      );
    }
  }

  String? _predictUser(List<dynamic> datas) {
    String? userAndPass = _faceNetService.predict(datas);
    return userAndPass;
  }

  displayDialog(BuildContext context, String msg, bool navigate) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Informasi')),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 12,
                  ),
                  Center(child: Text(msg))
                ]),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * 0.05, right: Get.width * 0.05, bottom: 8),
                child: Container(
                  width: Get.width * 1,
                  child: SizedBox(
                    height: Get.height * 0.045,
                    child: RaisedButton(
                      onPressed: () {
                        navigate
                            ? Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MainMenu(),
                                    fullscreenDialog: true))
                            : Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: ColorsTheme.primary1,
                      child: Text(
                        "TUTUP",
                        style: TextStyle(
                            color: Colors.white, fontSize: Get.width * 0.04),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          // Ensure that the camera is initialized.
          await widget._initializeControllerFuture;
          // onShot event (takes the image and predict output)
          bool faceDetected = await widget.onPressed!();

          if (faceDetected) {
            print("===================userAndPass===================");
            if (widget.isLogin) {
              SharedPreferences pref = await SharedPreferences.getInstance();
              List<dynamic> datas = json.decode(pref.getString("PREF_FACE")!);
              predictedUser = _predictUser(datas);
              this.predictedUser = predictedUser;
              print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@predictedUser");
              print(predictedUser);
            }
            PersistentBottomSheetController bottomSheetController =
                Scaffold.of(context)
                    .showBottomSheet((context) => signSheet(context));

            bottomSheetController.closed.whenComplete(() => widget.reload());
          }
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF0F0BDB),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }

  signSheet(context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: Get.width * 1,
            child: Column(
              children: [
                widget.isLogin
                    ? AppButton(
                        text: 'ABSEN SEKARANG',
                        onPressed: () async {
                          _signIn(context);
                        },
                        icon: Icon(
                          Icons.login,
                          color: Colors.white,
                        ),
                      )
                    : !widget.isLogin
                        ? AppButton(
                            text: 'DAFTARKAN',
                            onPressed: () async {
                              await _signUp(context);
                            },
                            icon: Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
