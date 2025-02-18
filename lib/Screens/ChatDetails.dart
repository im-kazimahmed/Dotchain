import 'dart:async';
import 'dart:developer';
import 'package:coin_project/ApiConnection/Api.dart';
import 'package:coin_project/ApiConnection/network.dart';
import 'package:coin_project/Models/ChatMassageModelList.dart';
import 'package:coin_project/Models/SendMassgeModel.dart';
import 'package:coin_project/Screens/login_page.dart';
import 'package:coin_project/Screens/register_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppColors/appColors.dart';

class ChatDetails extends StatefulWidget {
  const ChatDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  TextEditingController messageController = TextEditingController();
  bool isCurrentUser = true, loading = false, onChange = false;
  String? UserName, userId, profileImage, masterId;
  Timer? timer;
  final ScrollController _controller = ScrollController();

  void scrollToMaxExtent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
    });
  }

  final lastKey = GlobalKey();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  @override
  void initState() {
    getUserMassage();
    chatMessageList(masterId.toString());
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {
        onChange = !onChange;
      });
    });
  }

  getUserMassage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var image = sharedPreferences.getString('profileImage');
    profileImage = image.toString();
    UserName = sharedPreferences.getString("UserName");
    userId = sharedPreferences.getString("UserID");
    setState(() {});
  }

  List<ChatMassageList> chatlistData = [];
  late Future<List<ChatMassageList>> chat_obj;
  chatMessageList(String MasterId) async {
    setState(() {
      loading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var MasterId = preferences.getString("chatmasterID");
    var UserId = preferences.getString("UserID");
    var fromUserId = preferences.getString("fromUserId");
    var toUserId = preferences.getString("toUserId");
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

    String? toSendUserId = null;
    if (userId == fromUserId) {
      toSendUserId = toUserId;
    } else {
      toSendUserId = fromUserId;
    }
    String ChatMessageListUrl = Api.base_url + Api.chatMessageListUrl;

    Map ChatMessageListbody = {
      "api_username": Api.api_username,
      "api_password": Api.api_password,
      "master_id": MasterId.toString(),
      "from_user_id": UserId,
      "to_user_id": toSendUserId,
    };
    Map<String, String> data = {"Accept-Language": language};
    log("my lan $data");
    chat_obj = ApiConnection().GetmessageChateListClass(ChatMessageListUrl, ChatMessageListbody, data);
    await chat_obj.then((value) async {
      scrollToMaxExtent();
      chatlistData = await chat_obj;
      setState(() {});
    });
    setState(() {
      loading = false;
    });
  }

  Future<void> _getDetails() async {
    setState(() {
      chatMessageList(masterId.toString());
    });
  }

  late Future<SendMassageModel> send_massage_obj;
  sendMassage() async {
    setState(() {
      loading = false;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UserId = preferences.getString("UserID");
    var fromUserId = preferences.getString("fromUserId");
    var toUserId = preferences.getString("toUserId");
    var masterId = preferences.getString('chatmasterID');
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
    String? toSendUserId = null;
    if (userId == fromUserId) {
      toSendUserId = toUserId;
    } else {
      toSendUserId = fromUserId;
    }
    String sendMassageUrl = Api.base_url + Api.sendMassage;
    Map sendMassageBody = {
      "api_username": Api.api_username,
      "api_password": Api.api_password,
      "from_user_id": UserId,
      "to_user_id": toSendUserId,
      "master_id": masterId,
      "message": messageController.text.trim()
    };
    Map<String, String> data = {"Accept-Language": language};
    send_massage_obj = ApiConnection().sendMessageClass(sendMassageUrl, sendMassageBody, data);
    log("my lan $data");
    await send_massage_obj.then((value) {
      if (value.status == 1) {
        masterId = value.result!.userChatMasterId.toString();
        preferences.setString('chatmasterID', masterId!);
        messageController.clear();
        chatMessageList(masterId.toString());
        _controller.jumpTo(_controller.position.maxScrollExtent);
      } else {
        Fluttertoast.showToast(msg: value.msg.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          flexibleSpace: Stack(
            children: [
              Container(
                height: height * 0.15,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.mainColor1, AppColors.mainColor])),
                child: Container(
                  margin: EdgeInsets.only(top: height * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.03),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back),
                          ),
                          SizedBox(width: width * 0.12),
                          Text(
                            UserName ?? "",
                            style: TextStyle(
                                color: AppColors.black,
                                fontSize: 18,
                                fontFamily: 'Montserrat-ExtraBold.otf',
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: SingleChildScrollView(
            child: Stack(children: [
              Container(
                  height: height * 0.02,
                  width: width * 0.999,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.mainColor1, AppColors.mainColor]))),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                    color: AppColors.white,
                  ),
                  height: height * 0.77,
                  child: chatlistData.length != 0
                      ? RefreshIndicator(
                          onRefresh: _getDetails,
                          child: RefreshIndicator(
                            onRefresh: () {
                              return chatMessageList(masterId.toString());
                            },
                            child: ListView.builder(
                                controller: _controller,
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                itemCount: chatlistData.length,
                                itemBuilder: (context, index) {
                                  String fromUser = chatlistData[index].fromUserId.toString();
                                  String toUser = chatlistData[index].toUserId.toString();
                                  log("fromUser id ::::::::::::::::::${fromUser}");
                                  log("to user id ::::::::::::::::::${toUser}");
                                  return Container(
                                    margin: EdgeInsets.only(top: height * 0.02),
                                    child: Stack(
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: userId == fromUser ? width * 0.8 : width * 0.05),
                                          height: height * 0.055,
                                          width: width * 0.12,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              image: DecorationImage(
                                                image: NetworkImage(userId == fromUser
                                                    ? chatlistData[index].profilePic.toString()
                                                    : chatlistData[index].profilePic.toString()),
                                              )),
                                        ),
                                        Container(
                                          width: width * 0.55,
                                          margin: EdgeInsets.only(
                                              left: userId == fromUser ? width * 0.245 : width * 0.18,
                                              top: height * 0.033),
                                          child: Align(
                                            alignment:
                                                (userId == fromUser) ? Alignment.centerRight : Alignment.centerLeft,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: userId == fromUser
                                                    ? const Color(0xFF565CE3).withOpacity(0.12)
                                                    : const Color(0xFFDDDDDD),
                                                borderRadius: BorderRadius.only(
                                                    bottomRight: const Radius.circular(12),
                                                    bottomLeft: const Radius.circular(12),
                                                    topLeft: userId == fromUser
                                                        ? const Radius.circular(12)
                                                        : const Radius.circular(0),
                                                    topRight: userId == fromUser
                                                        ? const Radius.circular(0)
                                                        : const Radius.circular(12)),
                                              ),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: height * 0.01,
                                                    left: width * 0.035,
                                                    right: width * 0.035,
                                                    bottom: height * 0.02),
                                                child: Text(chatlistData[index].message.toString(),
                                                    style: TextStyle(
                                                      color: AppColors.black,
                                                      height: height * 0.002,
                                                      fontSize: height * 0.015,
                                                      fontFamily: "Montserrat",
                                                      fontWeight: FontWeight.w300,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: height * 0.02),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        )
                      : Container(
                          child: loading
                              ? Center(
                                  child: Container(
                                    width: width * 0.07,
                                    child: const LoadingIndicator(
                                      indicatorType: Indicator.ballBeat,
                                      colors: [AppColors.orange, AppColors.black, AppColors.lightGray],
                                      strokeWidth: 1,
                                      pathBackgroundColor: Colors.black,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                  "Nothing found",
                                  style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: height * 0.02,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600),
                                )))),
              Container(
                margin: EdgeInsets.only(top: height * 0.77),
                width: width * 0.999,
                height: height * 0.1,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  image: DecorationImage(image: AssetImage("assets/images/whitebackground.png"), fit: BoxFit.cover),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: height * 0.81, bottom: height * 0.012),
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: width * 0.04),
                        width: width * 0.7,
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F6F6),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(left: width * 0.05),
                          child: TextFormField(
                            decoration: InputDecoration(
                              counterStyle: TextStyle(
                                height: double.minPositive,
                              ),
                              hintText: 'type_a_message'.tr(),
                              border: InputBorder.none,
                            ),
                            controller: messageController,
                          ),
                        )),
                    SizedBox(width: width * 0.08),
                    InkWell(
                      onTap: () {
                        if (messageController.text.isEmpty == true) {
                          Fluttertoast.showToast(msg: "please enter some text");
                        } else {
                          if (masterId == null) {
                            sendMassage();
                          } else {
                            sendMassage();
                            chatMessageList(masterId.toString());
                          }
                        }
                      },
                      child: Container(
                        width: width * 0.13,
                        child: Image.asset(
                          'assets/images/sendchat.png',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
