import 'package:absensi/api/service.dart';
import 'package:absensi/models/menu/cls_absen_hari_ini.dart';
import 'package:absensi/pages/general_widget.dart/widget_error.dart';
import 'package:absensi/pages/general_widget.dart/widget_loading_page.dart';
import 'package:absensi/style/colors.dart';
import 'package:absensi/style/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuData extends StatefulWidget {
  @override
  _MenuDataState createState() => _MenuDataState();
}

class _MenuDataState extends State<MenuData> {
  bool? loading;
  bool? failed;
  String? remakrs;
  List<Absen> dataAbsen = [];

  Future getData() async {
    setState(() {
      loading = false;
      failed = false;
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    getClient().listAbsen(pref.getString("PREF_TOKEN")!).then((res) async {
      if (res.statusJson!) {
        setState(() {
          dataAbsen = res.listabsen;
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
                // ignore: missing_return
                onRefresh: () => getData(),
                child: Scaffold(
                    body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Container(
                        child: Text(
                          "Riwayat Absensi",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff171111),
                            fontSize: 20,
                            fontFamily: "Sansation Light",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: dataAbsen.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            Absen item = dataAbsen[index];
                            return InkWell(
                              child: card(item),
                            );
                          })
                    ],
                  ),
                )));
  }
}

Widget card(Absen item) {
  DateTime tempDate =
      DateFormat("yyyy-MM-dd hh:mm:ss").parse("2020-08-09 00:00:00");
  String tanggal = DateFormat('dd').format(tempDate);
  String hari = DateFormat('EEEE').format(tempDate);
  String bulantahun = DateFormat('MM/yyyy').format(tempDate);
  String wfhWfo = item.wfhWfo!.toUpperCase();
  String datangPulang = item.datangPulang!.toUpperCase();
  String tanggalAbsen = item.tanggalAbsen!;
  String jamAbsen = item.jamAbsen!;

  return Center(
    child: Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
          width: Get.width * 0.9,
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
                          hari.toUpperCase(),
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
                        tanggal,
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
                          bulantahun,
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
                                wfhWfo,
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
                                datangPulang,
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
                            Column(
                              children: [
                                SizedBox(
                                  child: Text(
                                    tanggalAbsen,
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
                                    jamAbsen,
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
  );
}

Widget buildRowInfoPribadi(String key, String value) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: SizeConfig.screenWidth * 0.15,
              child: Text(key, style: TextStyle(fontSize: 12))),
          Text(" : "),
          Expanded(
            child: Container(
              child: Text(
                value,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 4,
      )
    ],
  );
}
