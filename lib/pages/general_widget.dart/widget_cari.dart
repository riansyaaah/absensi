import 'package:absensi/style/colors.dart';
import 'package:absensi/style/sizes.dart';
import 'package:flutter/material.dart';

class WidgetCari extends StatelessWidget {
  const WidgetCari({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.075,
      color: ColorsTheme.primary1,
      child: SizedBox(
        height: SizeConfig.screenHeight * 0.08,
        child: Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.screenLeftRight0,
              right: SizeConfig.screenLeftRight0,
              top: SizeConfig.screenHeight * 0.0145,
              bottom: SizeConfig.screenHeight * 0.0145),
          child: Container(
            height: SizeConfig.screenHeight * 0.045,
            decoration: BoxDecoration(
              color: ColorsTheme.background2,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: SizeConfig.screenLeftRight1),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    color: ColorsTheme.primary1,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Cari ...")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
