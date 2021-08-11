import 'package:absensi/pages/auth/login.dart';
import 'package:absensi/pages/general_widget.dart/widget_snackbar.dart';
import 'package:absensi/style/colors.dart';
import 'package:absensi/style/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuAkun extends StatefulWidget {
  @override
  _MenuAkunState createState() => _MenuAkunState();
}

class _MenuAkunState extends State<MenuAkun> {
  String nip = "";
  String nama = "";
  String alamat = "";
  String version = "";

  TextEditingController ctrlNip = new TextEditingController();
  TextEditingController ctrlNama = new TextEditingController();
  TextEditingController ctrlAlamat = new TextEditingController();

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
      nip = pref.getString("PREF_NIP")!;
      nama = pref.getString("PREF_NAMA")!;
      alamat = pref.getString("PREF_ALAMAT")!;
      ctrlNip.text = nip;
      ctrlNama.text = nama;
      ctrlAlamat.text = alamat;
    });
  }

  dialogLogout() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Konfirmasi')),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 12,
                  ),
                  //USERNAME FIELD
                  Text("Anda yakin akan keluar aplikasi ?")
                ]),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenLeftRight1, bottom: 8),
                    child: Container(
                      width: Get.width * 0.3,
                      child: SizedBox(
                        height: Get.height * 0.045,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: ColorsTheme.primary1)),
                          color: Colors.white,
                          child: Text(
                            "TIDAK",
                            style: TextStyle(
                                color: ColorsTheme.primary1,
                                fontSize: SizeConfig.fontSize4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: SizeConfig.screenLeftRight1, bottom: 8),
                    child: Container(
                      width: Get.width * 0.3,
                      child: SizedBox(
                        height: Get.height * 0.045,
                        child: RaisedButton(
                          onPressed: () {
                            goToLogin();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: ColorsTheme.primary1,
                          child: Text(
                            "YA",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.fontSize4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget textField(TextEditingController ctrl, String hintText,
      TextInputType textInputType, bool obscureText) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.screenLeftRight0,
          right: SizeConfig.screenLeftRight0,
          bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: ColorsTheme.background2,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: SizeConfig.screenLeftRight1),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  controller: ctrl,
                  keyboardType: textInputType,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: hintText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateProfileDialog(String value) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
              title: Center(child: Text(value)),
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 12,
                    ),
                    textField(ctrlNip, "NIP", TextInputType.text, false),
                    textField(ctrlNama, "Nama", TextInputType.text, false),
                    textField(ctrlAlamat, "Alamat", TextInputType.text, false),
                  ]),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.screenLeftRight1,
                      right: SizeConfig.screenLeftRight1,
                      bottom: 8),
                  child: Container(
                    width: Get.width,
                    child: SizedBox(
                      height: Get.height * 0.045,
                      child: RaisedButton(
                        onPressed: () {
                          String check = checkMandatory();
                          if (check == "") {
                            submitRegister();
                          } else {
                            FocusScope.of(context).requestFocus(FocusNode());
                            WidgetSnackbar(
                                context: context,
                                message: check,
                                warna: "merah");
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: ColorsTheme.primary1,
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.fontSize4),
                        ),
                      ),
                    ),
                  ),
                )
              ]);
        });
  }

  goToLogin() {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginPage();
        },
      ),
      (_) => false,
    );
  }

  void _showPopupMenu() async {
    String? selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(50, 50, 0, 0),
      items: [
        PopupMenuItem<String>(
          child: Text('Edit Profile'),
          value: "Edit Profile",
        ),
        PopupMenuItem<String>(
          child: Text('Logout'),
          value: "Logout",
        ),
      ],
      elevation: 8.0,
    );
    if (selected == "Edit Profile") {
      updateProfileDialog(selected!);
    } else if (selected == "Logout") {
      dialogLogout();
    }
  }

  Future submitRegister() async {}

  checkMandatory() {
    return "";
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Container(
              height: Get.height * 0.4,
              color: ColorsTheme.primary1,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.screenLeftRight1,
                  right: SizeConfig.screenLeftRight1,
                  top: Get.height * 0.05),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      " Akun",
                      style: TextStyle(
                          fontFamily: 'BalsamiqSans',
                          fontSize: 24,
                          color: Colors.white),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showPopupMenu();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.widgets,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Get.height * 0.3),
              child: Container(
                // height: Get.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Get.height * 0.15,
                    ),
                    card(context, Icons.email, "NIP", nip),
                    card(context, Icons.email, "Nama", nama),
                    card(context, Icons.email, "Alamat", alamat),
                    SizedBox(
                      height: Get.height * 0.075,
                    ),
                    GestureDetector(
                      onTap: () {
                        dialogLogout();
                      },
                      child: Text(
                        "KELUAR",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorsTheme.primary2),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.025,
                    ),
                    Text(
                      version == null ? "" : "Version " + version,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorsTheme.primary1),
                    ),
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.screenLeftRight1,
                  right: SizeConfig.screenLeftRight1,
                  top: Get.height * 0.2),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      height: Get.height * 0.175,
                      width: Get.width * 0.375,
                      child: CircleAvatar(
                        radius: Get.width * 0.2,
                        backgroundImage: AssetImage(
                          "assets/ilustration/avatar.png",
                          // fit: BoxFit.,
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Text(
                      nama,
                      style: TextStyle(
                          fontFamily: 'BalsamiqSans',
                          fontSize: 24,
                          color: ColorsTheme.primary1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget card(BuildContext context, IconData icon, String key, String value) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
    child: Card(
      elevation: 2,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        child: Container(
          // height: 100,
          width: Get.width,
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: ColorsTheme.primary1, width: 5))),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  key,
                  style: TextStyle(
                      fontFamily: 'BalsamiqSans',
                      fontSize: 16,
                      color: ColorsTheme.background3),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  value,
                  style: TextStyle(
                      fontFamily: 'BalsamiqSans',
                      fontSize: 18,
                      color: ColorsTheme.text1),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
