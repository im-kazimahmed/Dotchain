import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:coin_project/ApiConnection/Api.dart';
import 'package:coin_project/ApiConnection/network.dart';
import 'package:coin_project/Models/ProfileModel.dart';
import 'package:coin_project/Screens/settingPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppColors/appColors.dart';
import '../Models/EditProfileModel.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? Email, referCode, packageName, version, buildNumber, appName;
  String? subject = '', profileImage;
  int activeCount = 0, inactiveCount = 0;
  int? totalTeam;
  Timer? timer;
  File? imageFile;
  bool btnChange = false;

  @override
  void initState() {
    super.initState();
    getUserData();
    profile();
  }

  void _checkPermission(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<Permission, PermissionStatus> statues =
        await [Permission.camera, Permission.storage, Permission.photos].request();
    PermissionStatus? statusCamera = statues[Permission.camera];
    PermissionStatus? statusStorage = statues[Permission.storage];
    PermissionStatus? statusPhotos = statues[Permission.photos];
    bool isGranted = statusPhotos == PermissionStatus.granted &&
        statusStorage == PermissionStatus.granted &&
        statusPhotos == PermissionStatus.granted;
    if (isGranted) {
      _getFromGallery();
      //_openDialog(context);
      log("if isGranted part");
    } else {}
    bool isPermanentlyDenied = statusCamera == PermissionStatus.permanentlyDenied ||
        statusStorage == PermissionStatus.permanentlyDenied ||
        statusPhotos == PermissionStatus.permanentlyDenied;
    if (isPermanentlyDenied) {
      _getFromGallery();
    }
  }

  Future<UserProfileModel>? pro_obj;
  profile() async {
    setState(() {
      btnChange = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString("UserID");
    var viLang = preferences.getString("vi");
    var engLang = preferences.getString("en");
    var zhLang = preferences.getString("zh");
    var filLang = preferences.getString("fil");
    var idLang = preferences.getString("id");
    var koLang = preferences.getString("ko");
    String profileUrl = Api.base_url + Api.profile;
    var language;
    if (zhLang == "zh") {
      language = zhLang;
      preferences.remove('en');
      preferences.remove('id');
      preferences.remove('fil');
      preferences.remove('ko');
      preferences.remove('vi');
      log("if part lnag${language}");
      setState(() {});
    } else if (filLang == "fil") {
      language = filLang;
      preferences.remove('id');
      preferences.remove('en');
      preferences.remove('ko');
      preferences.remove('vi');
      preferences.remove('zh');
      log("if part lnag${language}");
      setState(() {});
    } else if (idLang == "id") {
      language = idLang;
      preferences.remove('en');
      preferences.remove('ko');
      preferences.remove('vi');
      preferences.remove('zh');
      preferences.remove('fil');
      log("if part lnag${language}");
      setState(() {});
    } else if (koLang == "ko") {
      language = koLang;
      preferences.remove('en');
      preferences.remove('vi');
      preferences.remove('zh');
      preferences.remove('fil');
      preferences.remove('id');
      log("if part lnag${language}");
      setState(() {});
    } else if (viLang == "vi") {
      language = viLang;
      preferences.remove('en');
      preferences.remove('zh');
      preferences.remove('fil');
      preferences.remove('id');
      preferences.remove('ko');
      log("if part lnag${language}");
      setState(() {});
    } else if (engLang == "en") {
      language = engLang;
      preferences.remove('zh');
      preferences.remove('fil');
      preferences.remove('id');
      preferences.remove('ko');
      preferences.remove('vi');
      log("else part lnag${language}");
      setState(() {});
    }
    Map profileBody = {
      "api_username": Api.api_username,
      "api_password": Api.api_password,
      "user_id": userId.toString(),
    };

    Map<String, String> data = {"Accept-Language": language};
    log(profileBody.toString());
    pro_obj = ApiConnection().profile(profileUrl, profileBody, data);
    log("my lan $data");
    await pro_obj!.then((value) {
      setState(() {
        btnChange = false;
      });
      if (value.status == 1) {
        Email = value.result?.email;
        referCode = value.result?.username;
        profileImage = value.result?.profilePic;
        preferences.setString('profileImage', profileImage!);
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: value.msg.toString());
      }
    });
  }

  late Future<EditProfileModel> edit_obj;
  editProfile() async {
    setState(() {
      btnChange = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString("UserID");
    var viLang = preferences.getString("vi");
    var engLang = preferences.getString("en");
    var zhLang = preferences.getString("zh");
    var filLang = preferences.getString("fil");
    var idLang = preferences.getString("id");
    var koLang = preferences.getString("ko");
    var language;
    if (zhLang == "zh") {
      language = zhLang;
      preferences.remove('en');
      preferences.remove('id');
      preferences.remove('fil');
      preferences.remove('ko');
      preferences.remove('vi');
      log("if part lnag${language}");
      setState(() {});
    } else if (filLang == "fil") {
      language = filLang;
      preferences.remove('id');
      preferences.remove('en');
      preferences.remove('ko');
      preferences.remove('vi');
      preferences.remove('zh');
      log("if part lnag${language}");
      setState(() {});
    } else if (idLang == "id") {
      language = idLang;
      preferences.remove('en');
      preferences.remove('ko');
      preferences.remove('vi');
      preferences.remove('zh');
      preferences.remove('fil');
      log("if part lnag${language}");
      setState(() {});
    } else if (koLang == "ko") {
      language = koLang;
      preferences.remove('en');
      preferences.remove('vi');
      preferences.remove('zh');
      preferences.remove('fil');
      preferences.remove('id');
      log("if part lnag${language}");
      setState(() {});
    } else if (viLang == "vi") {
      language = viLang;
      preferences.remove('en');
      preferences.remove('zh');
      preferences.remove('fil');
      preferences.remove('id');
      preferences.remove('ko');
      log("if part lnag${language}");
      setState(() {});
    } else if (engLang == "en") {
      language = engLang;
      preferences.remove('zh');
      preferences.remove('fil');
      preferences.remove('id');
      preferences.remove('ko');
      preferences.remove('vi');
      log("else part lnag${language}");
      setState(() {});
    }
    String editProfileUrl = Api.base_url + Api.editProfile;
    Map<String, String> editProfileBody = {
      "id": userId.toString(),
      "api_username": Api.api_username,
      "api_password": Api.api_password
    };
    Map<String, String> data = {"Accept-Language": language};
    log(":::::::::::::::::::::::::::::::::::::::::");
    log(editProfileBody.toString());
    log("edite time  $data");
    log(":::::::::::::::::::::::::::::::::::::::::");
    edit_obj = ApiConnection().editProfile(editProfileUrl, editProfileBody, imageFile!, data);
    log(":::::::::::::::::::::::::::::::::::::::::");
    log(imageFile.toString());
    log(":::::::::::::::::::::::::::::::::::::::::");
    await edit_obj.then((value) {
      setState(() {
        btnChange = false;
      });
      if (value.status == 1) {
        Fluttertoast.showToast(msg: 'Profile Updated!');
        profile();
      } else {
        Fluttertoast.showToast(msg: value.msg.toString());
      }
    });
  }

  getUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    inactiveCount = preferences.getInt('InactiveCount') ?? 0;
    activeCount = preferences.getInt('ActiveCount') ?? 0;
    totalTeam = activeCount + inactiveCount;
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    Share.share(
        "${"mining_invite_text_one".tr()}"
        "${"mining_invite_text_two".tr()}"
        "${"mining_invite_text_three".tr()}"
        "${"https://dotchain.network/refer/$referCode "}"
        "${"mining_invite_text_five".tr()}"
        "${"($referCode)"}"
        "${"mining_invite_text_six".tr()}"
        "${"mining_inactive_100_live_stats".tr()}",
        subject: subject,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        editProfile();
        imageFile = File(pickedFile.path);
      });
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        editProfile();
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: height * 0.1, left: width * 0.04, right: width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.black,
                                )),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingPage()));
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset('assets/svg_images/setting.svg'),
                                  SizedBox(height: height * 0.01),
                                  // Text(
                                  //   'Setting',
                                  //   style: TextStyle(
                                  //       fontFamily: 'Montserrat',
                                  //       fontSize: height * 0.013,
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2, left: width * 0.04, right: width * 0.05),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    openBottomSheet(context);
                                  },
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(top: height * 0.02, right: width * 0.02, left: width * 0.04),
                                      height: height * 0.090,
                                      width: width * 0.19,
                                      decoration: BoxDecoration(
                                        color: AppColors.lightGray.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: imageFile == null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: profileImage == null
                                                  ? Image.asset(
                                                      'assets/images/profileimage.jpg',
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(profileImage!.toString()))
                                          : Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  border: Border.all(color: AppColors.black)),
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(100),
                                                  child: Image.file(imageFile!, fit: BoxFit.fill)))),
                                ),
                                InkWell(
                                  onTap: () {
                                    openBottomSheet(context);
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(top: height * 0.08, left: width * 0.17),
                                      child: Container(
                                          height: 23,
                                          width: 23,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: AppColors.white,
                                              border: Border.all(color: AppColors.black)),
                                          child: Center(
                                              child: Icon(
                                            Icons.camera_alt,
                                            color: AppColors.black,
                                            size: height * 0.018,
                                          )))),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height * 0.02, right: width * 0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Text(
                                    referCode == null ? '-' : referCode.toString(),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: height * 0.02),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.06),
                      boxContainer(
                        'email'.tr(),
                        Icon(Icons.email),
                        Email == null ? '-' : Email.toString(),
                        Color(0xFFFDF2D6),
                      ),
                      SizedBox(height: height * 0.02),
                      boxContainer('refer_code'.tr(), Icon(Icons.person),
                          referCode == null ? '-' : referCode.toString(), Color(0xFFFDF2D6)),
                      SizedBox(height: height * 0.02),
                      boxContainer('profile_my_team'.tr(), Icon(Icons.people),
                          totalTeam == null ? '0' : totalTeam.toString(), Colors.greenAccent.withOpacity(0.1)),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.03),
                        height: height * 0.22,
                        width: width * 0.9,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomRight,
                                colors: [AppColors.mainColor, AppColors.mainColor1]),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            SizedBox(height: height * 0.02),
                            Text(
                              'profile_min_dot'.tr(),
                              style: TextStyle(
                                color: AppColors.gray,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat-Bold',
                                fontSize: height * 0.018,
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              'profile_increase_mining_rate_25'.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat-Bold',
                                  fontSize: height * 0.021,
                                  height: 1.2),
                            ),
                            SizedBox(height: height * 0.015),
                            Container(
                              width: width * 0.72,
                              height: height * 0.050,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    primary: AppColors.black,
                                    elevation: 0.0),
                                onPressed: () {
                                  _onShare(context);
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/svg_images/people.svg', color: AppColors.mainColor),
                                    SizedBox(
                                      width: width * 0.18,
                                    ),
                                    Text(
                                      'profile_increase_invite_now'.tr(),
                                      style: TextStyle(
                                          fontSize: height * 0.017,
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFFF9CA00),
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  // Container(
                  //     child: pro_obj == null
                  //     ?  Center(
                  //         child:   Stack(
                  //           children: [
                  //             Container(
                  //               //margin: EdgeInsets.only(top: height * 0.25),
                  //               height: height ,width: width,
                  //               decoration: BoxDecoration(
                  //                   color: Colors.black12,
                  //                   borderRadius: BorderRadius.circular(12)
                  //               ),
                  //             ),
                  //             Container(
                  //               margin: EdgeInsets.only(top: height * 0.4,left: width * 0.35),
                  //               height: 100 ,width: 100,
                  //               decoration: BoxDecoration(
                  //                   color: Color(0xFFFDF2D6),
                  //                   borderRadius: BorderRadius.circular(12)
                  //               ),
                  //             ),
                  //             Container(
                  //               height: 40, width: 40,
                  //               margin: EdgeInsets.only(left: width * 0.42,top: height * 0.435),
                  //               child:  LoadingIndicator(
                  //                 indicatorType: Indicator.ballBeat,
                  //                 colors: [
                  //                   AppColors.orange,
                  //                   AppColors.black,
                  //                   AppColors.gray
                  //                 ],
                  //                 strokeWidth: 1,
                  //                 pathBackgroundColor: Colors.black,
                  //               ),
                  //             ),
                  //
                  //           ],
                  //         )
                  //     )
                  //     : null,
                  // ),
                  Container(
                    child: btnChange
                        ? Center(
                            child: Stack(
                            children: [
                              Container(
                                //margin: EdgeInsets.only(top: height * 0.25),
                                height: height, width: width,
                                decoration:
                                    BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.4, left: width * 0.35),
                                height: 100,
                                width: 100,
                                decoration:
                                    BoxDecoration(color: Color(0xFFFDF2D6), borderRadius: BorderRadius.circular(12)),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(left: width * 0.42, top: height * 0.435),
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballBeat,
                                  colors: [AppColors.orange, AppColors.black, AppColors.gray],
                                  strokeWidth: 1,
                                  pathBackgroundColor: Colors.black,
                                ),
                              ),
                            ],
                          ))
                        : null,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget boxContainer(
    String text,
    final Icon icon,
    String emailtext,
    Color color,
  ) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: MediaQuery.of(context).size.width * 0.89,
      height: 60,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.02, right: MediaQuery.of(context).size.width * 0.04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(onPressed: () {}, icon: icon, color: Color(0xFF030D45)),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: height * 0.02,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat-Bold'),
                )
              ],
            ),
            Text(
              emailtext,
              style: TextStyle(fontSize: height * 0.015, fontFamily: 'Montserrat'),
            ),
          ],
        ),
      ),
    );
  }

  openBottomSheet(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (BuildContext context) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;
          return Container(
            height: height * 0.2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [AppColors.mainColor, AppColors.mainColor1]),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  height: height * 0.005,
                  decoration: BoxDecoration(color: AppColors.gray, borderRadius: BorderRadius.circular(12)),
                  width: width * 0.25,
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  width: width * 0.72,
                  height: height * 0.050,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      primary: AppColors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _getFromCamera();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt, color: Color(0xFFF9CA00), size: height * 0.03),
                        SizedBox(
                          width: width * 0.18,
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(
                              fontSize: height * 0.017,
                              fontFamily: 'Montserrat',
                              color: Color(0xFFF9CA00),
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  width: width * 0.72,
                  height: height * 0.050,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      primary: AppColors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _checkPermission(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.photo, color: Color(0xFFF9CA00), size: height * 0.03),
                        SizedBox(
                          width: width * 0.18,
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(
                              fontSize: height * 0.017,
                              fontFamily: 'Montserrat',
                              color: Color(0xFFF9CA00),
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
