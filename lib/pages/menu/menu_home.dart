import 'package:absensi/api/facenet.service.dart';
import 'package:absensi/api/ml_kit_service.dart';
import 'package:absensi/api/service.dart';
import 'package:absensi/models/database.dart';
import 'package:absensi/models/menu/cls_absen_hari_ini.dart';
import 'package:absensi/pages/general_widget.dart/widget_error.dart';
import 'package:absensi/pages/general_widget.dart/widget_loading_page.dart';
import 'package:absensi/pages/menu/absen.dart';
import 'package:absensi/pages/menu/sign-up.dart';
import 'package:absensi/style/colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuHome extends StatefulWidget {
  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  bool? loading;
  bool? failed;
  String? remakrs;
  String? nama;
  String? departemen;
  String? posisi;
  String? nip;
  String? hari;
  String? tanggal;
  String? bulantahun;
  Absen? absenIn;
  Absen? absenOut;

  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();

  late CameraDescription cameraDescription;

  Future getData() async {
    startUp();
    setState(() {
      loading = true;
      failed = false;
    });
    DateTime now = DateTime.now();
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getString("PREF_TOKEN")!);
    getClient()
        .getAbsenHariIni(pref.getString("PREF_TOKEN")!)
        .then((res) async {
      if (res.statusJson!) {
        hari = res.hari;
        tanggal = res.tanggal;
        bulantahun = res.bulantahun;
        absenIn = res.absenIn;
        absenOut = res.absenOut;
        nama = pref.getString("PREF_NAMA")!;
        departemen = pref.getString("PREF_DEPARTEMEN")!;
        posisi = pref.getString("PREF_POSISI")!;
        nip = pref.getString("PREF_NIP")!;

        setState(() {
          loading = false;
          failed = false;
        });
      } else {
        setState(() {
          loading = false;
          failed = true;
          remakrs = res.remarks;
        });
      }
    }).catchError((Object obj) {
      setState(() {
        loading = false;
        failed = true;
        remakrs = "Gagal menyambungkan ke server";
      });
    });
  }

  void startUp() async {
    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    _mlKitService.initialize();
  }

  Widget online() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width * 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 51,
              height: 16,
              child: Text(
                "Online",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xff171111),
                  fontSize: 14,
                  fontFamily: "Sansation Light",
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(width: 7),
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff08cc04),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profile() {
    return Padding(
      padding: EdgeInsets.only(top: 32, left: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xffd6d2d2),
                    width: 1,
                  ),
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 16),
              Container(
                child: Text(
                  "Hi, " + nama!,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xff171111),
                    fontSize: 20,
                    fontFamily: "Sansation Light",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Container(
              child: Text(
                nip!,
                style: TextStyle(
                  color: Color(0xff171111),
                  fontSize: 16,
                  fontFamily: "Sansation Light",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Container(
              child: Text(
                posisi!,
                style: TextStyle(
                  color: Color(0xff171111),
                  fontSize: 14,
                  fontFamily: "Sansation Light",
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Container(
              child: Text(
                "Dept. " + departemen!,
                style: TextStyle(
                  color: Color(0xff171111),
                  fontSize: 14,
                  fontFamily: "Sansation Light",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardAbsenHariIni() {
    return Padding(
      padding: EdgeInsets.only(top: Get.height * 0.2),
      child: Center(
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
              width: Get.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3f000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Text(
                              hari!.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff171111),
                                fontSize: 14,
                                fontFamily: "Sansation Light",
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.50),
                          Text(
                            tanggal!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontFamily: "Sansation Light",
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 1.50),
                          SizedBox(
                            width: 81,
                            height: 21,
                            child: Text(
                              bulantahun!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff171111),
                                fontSize: 14,
                                fontFamily: "Sansation Light",
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 80,
                        child: VerticalDivider(color: ColorsTheme.primary1)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "IN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff171111),
                                      fontSize: 30,
                                      fontFamily: "Sansation Light",
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                absenIn == null
                                    ? Container()
                                    : Column(
                                        children: [
                                          SizedBox(
                                            child: Text(
                                              absenIn!.tanggalAbsen == null
                                                  ? "-"
                                                  : absenIn!.tanggalAbsen!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff171111),
                                                fontSize: 12,
                                                fontFamily: "Sansation Light",
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          SizedBox(
                                            child: Text(
                                              absenIn!.jamAbsen == null
                                                  ? "-"
                                                  : absenIn!.jamAbsen!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff171111),
                                                fontSize: 14,
                                                fontFamily: "Sansation Light",
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "OUT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff171111),
                                      fontSize: 30,
                                      fontFamily: "Sansation Light",
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                absenOut == null
                                    ? Container()
                                    : Column(
                                        children: [
                                          SizedBox(
                                            child: Text(
                                              absenOut!.tanggalAbsen == null
                                                  ? "-"
                                                  : absenOut!.tanggalAbsen!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff171111),
                                                fontSize: 12,
                                                fontFamily: "Sansation Light",
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          SizedBox(
                                            child: Text(
                                              absenOut!.jamAbsen == null
                                                  ? "-"
                                                  : absenOut!.jamAbsen!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff171111),
                                                fontSize: 14,
                                                fontFamily: "Sansation Light",
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget cardFaceData() {
    return Padding(
      padding: EdgeInsets.only(top: Get.height * 0.35),
      child: Center(
        child: Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignUp(
                      cameraDescription: cameraDescription,
                    ),
                  ),
                );
              },
              child: Container(
                width: Get.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                  color: Colors.red,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      "Data wajah anda belum di daftarkan\nDaftarkan Sekarang!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget runningClock() {
    return Padding(
      padding: EdgeInsets.only(top: Get.height * 0.5),
      child: StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          String jam = DateFormat('HH').format(DateTime.now());
          String menit = DateFormat('mm').format(DateTime.now());
          String detik = DateFormat('ss').format(DateTime.now());

          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      jam,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      menit,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      detik,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _modalBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (builder) {
          return Container(
            height: Get.height * 0.3,
            color: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.black12,
                                    image: DecorationImage(
                                        image:
                                            AssetImage("assets/images/wfo.png"),
                                        fit: BoxFit.cover),
                                  )),
                              SizedBox(height: 4),
                              Text(
                                "WFO",
                                style: TextStyle(
                                  color: Color(0xff171111),
                                  fontSize: 20,
                                  fontFamily: "Sansation Light",
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            goToAbsenForm("WFO");
                          }),
                      GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.black12,
                                    image: DecorationImage(
                                        image:
                                            AssetImage("assets/images/wfh.png"),
                                        fit: BoxFit.cover),
                                  )),
                              SizedBox(height: 4),
                              Text(
                                "WFH",
                                style: TextStyle(
                                  color: Color(0xff171111),
                                  fontSize: 20,
                                  fontFamily: "Sansation Light",
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            goToAbsenForm("WFH");
                          }),
                    ],
                  ),
                )),
          );
        });
  }

  void goToAbsenForm(String param) {
    Get.to(AbsenForm());
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return loading!
        ? WidgetLoadingPage()
        : failed!
            ? WidgetErrorConnection(
                onRetry: () {
                  setState(() {
                    getData();
                  });
                },
                remarks: remakrs)
            : RefreshIndicator(
                onRefresh: () => getData(),
                child: Scaffold(
                  body: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: Get.width * 1,
                          height: 219,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xffbefffb), Color(0x00fce9a8)],
                            ),
                          ),
                        ),
                        online(),
                        profile(),
                        cardAbsenHariIni(),
                        cardFaceData(),
                        runningClock(),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: Get.height * 0.8),
                            child: RaisedButton(
                              onPressed: () {
                                _modalBottomSheet();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              color: ColorsTheme.primary1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "ABSEN SEKARANG",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }
}
