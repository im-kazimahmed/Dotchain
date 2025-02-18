import 'dart:developer';

import 'package:coin_project/AppColors/appColors.dart';
import 'package:coin_project/Screens/settingPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/RadioButton_class.dart';

class MultiPleLanguage extends StatefulWidget {
  const MultiPleLanguage({Key? key}) : super(key: key);

  @override
  State<MultiPleLanguage> createState() => _MultiPleLanguageState();
}

class _MultiPleLanguageState extends State<MultiPleLanguage> {
  String? gender;
  String data = "";
  getValue() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    String? getValue6 = p.getString("zh");
    String? getValue5 = p.getString("fil");
    String? getValue4 = p.getString("id");
    String? getValue3 = p.getString("ko");
    String? getValue2 = p.getString("vi");
    String? getValue1 = p.getString("en");
    debugPrint("get my value $getValue2");
    debugPrint("get my value $getValue1");
    if (getValue6 == "zh") {
      setState(() {
        gender = "zh";
      });
      log("vallu :::::::::::::::$gender");
    } else if (getValue5 == "fil") {
      gender = "fil";
      setState(() {});
    } else if (getValue4 == "id") {
      gender = "id";
      setState(() {});
    } else if (getValue3 == "ko") {
      gender = "ko";
      setState(() {});
    } else if (getValue2 == "vi") {
      gender = "vi";
      setState(() {});
    } else if (getValue1 == "en") {
      gender = "en";
      setState(() {});
      log("vallu :::::::::::::::$gender");
    }
  }

  @override
  void initState() {
    getValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Container(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.06, left: width * 0.06),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        var data = Navigator.pop(context);
                        setState(() {});
                      },
                      child: Icon(Icons.arrow_back)),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Text(
                    'language'.tr(),
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: height * 0.022,
                        fontFamily: 'Montserrat-Bold',
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            RadioButtonClass(
                widget: RadioListTile(
              title: Text(
                'btn_lan_eng'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  fontSize: height * 0.018,
                ),
              ),
              value: 'en',
              groupValue: gender,
              onChanged: (String? value) async {
                SharedPreferences p = await SharedPreferences.getInstance();
                setState(() {
                  gender = value!;
                  p.remove("fil");
                  p.remove("vi");
                  p.remove("ko");
                  p.remove("id");
                  p.remove("zh");
                  p.setString("en", value);
                  context.setLocale(Locale.fromSubtags(languageCode: value));
                });
              },
            )),
            RadioButtonClass(
                widget: RadioListTile(
              title: Text(
                'btn_lan_vietnamese'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  fontSize: height * 0.018,
                ),
              ),
              value: "vi",
              groupValue: gender,
              onChanged: (String? value) async {
                SharedPreferences p = await SharedPreferences.getInstance();
                setState(() {
                  gender = value!;
                  p.remove("fil");
                  p.remove("en");
                  p.remove("ko");
                  p.remove("id");
                  p.remove("zh");
                  p.setString("vi", value);
                  context.setLocale(Locale.fromSubtags(languageCode: value));
                });
              },
            )),
            RadioButtonClass(
                widget: RadioListTile(
              title: Text(
                'btn_lan_korean'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  fontSize: height * 0.018,
                ),
              ),
              value: "ko",
              groupValue: gender,
              onChanged: (String? value) async {
                SharedPreferences p = await SharedPreferences.getInstance();
                setState(() {
                  gender = value!;
                  p.remove("fil");
                  p.remove("en");
                  p.remove("vi");
                  p.remove("id");
                  p.remove("zh");
                  p.setString("ko", value);
                  log(value);
                  context.setLocale(Locale.fromSubtags(languageCode: value));
                });
              },
            )),
            RadioButtonClass(
                widget: RadioListTile(
              title: Text(
                'btn_lan_indonesian'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  fontSize: height * 0.018,
                ),
              ),
              value: "id",
              groupValue: gender,
              onChanged: (String? value) async {
                SharedPreferences p = await SharedPreferences.getInstance();
                setState(() {
                  gender = value!;
                  p.remove("fil");
                  p.remove("en");
                  p.remove("vi");
                  p.remove("ko");
                  p.remove("zh");
                  p.setString("id", value);
                  log(value);
                  context.setLocale(Locale.fromSubtags(languageCode: value));
                });
              },
            )),
            RadioButtonClass(
                widget: RadioListTile(
              title: Text(
                'btn_lang_philippines'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  fontSize: height * 0.018,
                ),
              ),
              value: "fil",
              groupValue: gender,
              onChanged: (String? value) async {
                SharedPreferences p = await SharedPreferences.getInstance();
                setState(() {
                  gender = value!;
                  p.remove("en");
                  p.remove("vi");
                  p.remove("ko");
                  p.remove("id");
                  p.remove("zh");
                  p.setString("fil", value);
                  log(value);
                  context.setLocale(Locale.fromSubtags(languageCode: value));
                });
              },
            )),
            RadioButtonClass(
                widget: RadioListTile(
              title: Text(
                'btn_lan_chinese'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  fontSize: height * 0.018,
                ),
              ),
              value: "zh",
              groupValue: gender,
              onChanged: (String? value) async {
                SharedPreferences p = await SharedPreferences.getInstance();
                setState(() {
                  gender = value!;
                  p.remove("en");
                  p.remove("fil");
                  p.remove("vi");
                  p.remove("ko");
                  p.remove("id");
                  p.setString("zh", value);
                  log(value);
                  context.setLocale(Locale.fromSubtags(languageCode: value));
                });
              },
            )),
          ],
        )));
  }
}
