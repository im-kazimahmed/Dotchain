import 'dart:async';
import 'dart:developer';
import 'package:coin_project/ApiConnection/Api.dart';
import 'package:coin_project/ApiConnection/network.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppColors/appColors.dart';
import '../Models/GetchatuseListModel.dart';
import 'ChatDetails.dart';
import 'Profile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? username, timer, massage, profileImage, masterId;
  Timer? time;

  @override
  void initState() {
    getUseList();
    super.initState();
    profileImageGet();
  }

  bool loading = false;
  List<GetUserResult> getuserListData = [];
  late Future<List<GetUserResult>> get_userlistObj;
  getUseList() async {
    setState(() {
      loading = true;
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UserId = preferences.getString("UserID");
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
    String getchatuserlisuUrl = Api.base_url + Api.chatUserListUrl;
    Map getchatuserlistBody = {
      "api_username": Api.api_username,
      "api_password": Api.api_password,
      "user_id": UserId.toString()
    };
    Map<String, String> data = {"Accept-Language": language};
    log("my lan $data");
    get_userlistObj = ApiConnection().GetUserChateListClass(getchatuserlisuUrl, getchatuserlistBody, data);
    await get_userlistObj.then((value) async {
      getuserListData = await get_userlistObj;
      setState(() {
        loading = false;
      });
    });
  }

  Future<void> _getUserDetails() async {
    setState(() {
      getUseList();
    });
  }

  profileImageGet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var image = preferences.getString('profileImage');
    profileImage = image.toString();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: height * 0.06, left: width * 0.06),
                    height: height * 0.055,
                    width: width * 0.25,
                    child: Text(
                      'chat'.tr(),
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: height * 0.022,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          var data =
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
                          profileImageGet();
                        },
                        child: Stack(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: height * 0.06, right: width * 0.03),
                                height: height * 0.055,
                                width: width * 0.12,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGray.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: profileImage == null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: Image.asset(
                                          'assets/images/profileimage.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: profileImage != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child: Image.network(profileImage!.toString(), fit: BoxFit.cover))
                                            : Image.asset(
                                                'assets/images/profileimage.jpg',
                                                fit: BoxFit.cover,
                                              ))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.04),
              Container(
                height: height * 0.8,
                child: getuserListData.length != 0
                    ? RefreshIndicator(
                        onRefresh: _getUserDetails,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: getuserListData.length,
                          itemBuilder: (context, index) {
                            userSetMasterId() async {
                              SharedPreferences share = await SharedPreferences.getInstance();
                              String MasterId = getuserListData[index].masterId.toString();
                              String FromUserId = getuserListData[index].fromUserId.toString();
                              String ToUserId = getuserListData[index].toUserId.toString();
                              String UserName = getuserListData[index].username.toString();
                              share.setString("chatmasterID", MasterId);
                              share.setString("fromUserId", FromUserId);
                              share.setString("toUserId", ToUserId);
                              share.setString("UserName", UserName);
                              log("msterId ${MasterId}");
                            }

                            return InkWell(
                              onTap: () async {
                                userSetMasterId();
                                final data = await Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => ChatDetails()));
                                getUseList();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.only(left: width * 0.04),
                                                  height: height * 0.070,
                                                  width: width * 0.15,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: AppColors.lightGray,
                                                  ),
                                                  child: profileImage == null
                                                      ? ClipRRect(
                                                          borderRadius: BorderRadius.circular(100),
                                                          child: Image.asset('assets/images/profileimage.jpg',
                                                              fit: BoxFit.cover),
                                                        )
                                                      : ClipRRect(
                                                          borderRadius: BorderRadius.circular(100),
                                                          child: profileImage == null
                                                              ? Image.asset(
                                                                  'assets/images/profileimage.jpg',
                                                                  fit: BoxFit.cover,
                                                                )
                                                              : ClipRRect(
                                                                  borderRadius: BorderRadius.circular(100),
                                                                  child: Image.network(
                                                                    getuserListData[index].profilePic.toString(),
                                                                    fit: BoxFit.cover,
                                                                  )),
                                                        )),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: width * 0.04),
                                        width: width * 0.68,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    getuserListData[index].username == null
                                                        ? ""
                                                        : getuserListData[index].username.toString(),
                                                    style: TextStyle(
                                                        color: AppColors.black,
                                                        fontSize: height * 0.02,
                                                        fontFamily: 'Montserrat-Bold',
                                                        fontWeight: FontWeight.w700)),
                                                Text(getuserListData[index].dateTime.toString(),
                                                    style: TextStyle(
                                                      color: AppColors.black,
                                                      fontSize: height * 0.015,
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: 'Montserrat',
                                                    )),
                                              ],
                                            ),
                                            SizedBox(height: height * 0.01),
                                            Text(getuserListData[index].message.toString(),
                                                style: TextStyle(
                                                  color: AppColors.black,
                                                  fontSize: height * 0.017,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Montserrat',
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: AppColors.gray, endIndent: 30),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        child: loading
                            ? SizedBox(
                                width: width * 0.08,
                                child: const LoadingIndicator(
                                  indicatorType: Indicator.ballBeat,
                                  colors: [AppColors.orange, AppColors.black, AppColors.lightGray],
                                  strokeWidth: 1,
                                  pathBackgroundColor: Colors.black,
                                ),
                              )
                            : Stack(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      child: Image.asset("assets/images/chatnotfound.png")),
                                  Container(
                                      alignment: Alignment.topCenter,
                                      margin: EdgeInsets.only(top: height * 0.18),
                                      child: Text(
                                        "no_chat_found".tr(),
                                        style: TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w300,
                                            fontSize: height * 0.023,
                                            fontFamily: "Montserrat"),
                                      )),
                                ],
                              )),
              ),
              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
