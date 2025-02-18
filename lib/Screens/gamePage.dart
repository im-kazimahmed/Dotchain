import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'dart:ui';
import 'package:applovin_max/applovin_max.dart';
import 'package:coin_project/ApiConnection/Api.dart';
import 'package:coin_project/ApiConnection/network.dart';
import 'package:coin_project/Models/ClamRewardModel.dart';
import 'package:coin_project/Models/Speed_CurrentBalanceModel.dart';
import 'package:coin_project/Models/usergameBalanceModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppColors/appColors.dart';
import '../widgets/gameReward_btn.dart';
import '../widgets/gamebtn_widget.dart';
import '../widgets/games_widget.dart';
import 'Game/games.dart';
import 'Profile.dart';
import 'earnDotGold.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String? gameBalance, profileImage, UserId;
  int? gameCoin1, gameCoin2, gameCoin3, gameCoin4, gameCoin5;
  final String _rewarded_ad_unit_id1 = Platform.isAndroid ? "40b342303794ffa4" : "IOS_REWARDED_AD_UNIT_ID";
  var _rewardedAdRetryAttempt = 0;
  var getBtnValue2, getBtnValue3, getBtnValue4, getBtnValue5;
  SharedPreferences? preferences;

  initState() {
    super.initState();
    getbtnvalue();
    _getGameBalanceDetail();
    setUserProfile();
  }

  getbtnvalue() async {
    preferences = await SharedPreferences.getInstance();
    getBtnValue2 = preferences?.getBool("btn2");
    getBtnValue3 = preferences?.getBool("btn3");
    getBtnValue4 = preferences?.getBool("btn4");
    getBtnValue5 = preferences?.getBool("btn5");
  }

  /// Applovin Reworded Ads
  void loadApplovinRewordedAds(String gameId) {
    setState(() {
      loading = true;
    });
    Timer t = Timer(Duration(seconds: 25), () {
      setState(() {
        loading = false;
      });
      _ClamRewad(gameId);
    });
    AppLovinMAX.loadRewardedAd(_rewarded_ad_unit_id1);
    AppLovinMAX.setRewardedAdListener(RewardedAdListener(
        onAdLoadedCallback: (ad) {
          t.cancel();
          AppLovinMAX.showRewardedAd(_rewarded_ad_unit_id1);
        },
        onAdLoadFailedCallback: (String adUnitId, error) {
          setState(() {
            loading = false;
          });
        },
        onAdDisplayedCallback: (ad) {
          setState(() {
            loading = false;
          });
        },
        onAdDisplayFailedCallback: (ad, error) {
          setState(() {
            loading = false;
          });
        },
        onAdClickedCallback: (ad) {},
        onAdHiddenCallback: (ad) {
          _ClamRewad(gameId);
        },
        onAdReceivedRewardCallback: (ad, reward) {}));
  }

  bool loading = false;
  Future<ClamRewardModel>? rewadObj;

  _ClamRewad(String gameId) async {
    var UserID = preferences?.getString('UserID');
    var viLang = preferences?.getString("vi");
    var engLang = preferences?.getString("en");
    var zhLang = preferences?.getString("zh");
    var filLang = preferences?.getString("fil");
    var idLang = preferences?.getString("id");
    var koLang = preferences?.getString("ko");
    var language;
    if (zhLang == "zh") {
      language = zhLang;
      preferences?.remove('en');
      preferences?.remove('id');
      preferences?.remove('fil');
      preferences?.remove('ko');
      preferences?.remove('vi');
      log("if part lnag${language}");
      setState(() {});
    } else if (filLang == "fil") {
      language = filLang;
      preferences?.remove('id');
      preferences?.remove('en');
      preferences?.remove('ko');
      preferences?.remove('vi');
      preferences?.remove('zh');
      log("if part lnag${language}");
      setState(() {});
    } else if (idLang == "id") {
      language = idLang;
      preferences?.remove('en');
      preferences?.remove('ko');
      preferences?.remove('vi');
      preferences?.remove('zh');
      preferences?.remove('fil');
      log("if part lnag${language}");
      setState(() {});
    } else if (koLang == "ko") {
      language = koLang;
      preferences?.remove('en');
      preferences?.remove('vi');
      preferences?.remove('zh');
      preferences?.remove('fil');
      preferences?.remove('id');
      log("if part lnag${language}");
      setState(() {});
    } else if (viLang == "vi") {
      language = viLang;
      preferences?.remove('en');
      preferences?.remove('zh');
      preferences?.remove('fil');
      preferences?.remove('id');
      preferences?.remove('ko');
      log("if part lnag${language}");
      setState(() {});
    } else if (engLang == "en") {
      language = engLang;
      preferences?.remove('zh');
      preferences?.remove('fil');
      preferences?.remove('id');
      preferences?.remove('ko');
      preferences?.remove('vi');
      log("else part lnag${language}");
      setState(() {});
    }
    String url = Api.base_url + Api.ClamReward;

    int? coin = 0;
    if (gameId == "1") {
      coin = gameCoin1;
    } else if (gameId == "2") {
      coin = gameCoin2;
    } else if (gameId == "3") {
      coin = gameCoin3;
    } else if (gameId == "4") {
      coin = gameCoin4;
    } else if (gameId == "5") {
      coin = gameCoin5;
    }

    Map request = {
      'coin': "${coin}",
      "game_id": gameId,
      "id": UserID.toString(),
      'api_username': Api.api_username,
      'api_password': Api.api_password,
    };
    Map<String, String> data = {"Accept-Language": language};

    log(":::::::::::::::::::::::::::");
    log(request.toString());
    log("my lan $data");
    log(":::::::::::::::::::::::::::");
    rewadObj = ApiConnection().ClamReward(url, request, data);
    await rewadObj?.then((value) {
      if (value.status == 1) {
        _getGameBalanceDetail();
        setState(() {
          if (gameId == "1") {
            preferences?.remove("btn1");
          } else {}
          if (gameId == "2") {
            preferences?.remove("btn2");
          } else {}
          if (gameId == "3") {
            preferences?.remove("btn3");
          } else {}
          if (gameId == "4") {
            preferences?.remove("btn4");
          } else {}
          if (gameId == "5") {
            preferences?.remove("btn5");
          } else {}
        });
        Fluttertoast.showToast(msg: value.msg!);
      } else {
        Fluttertoast.showToast(msg: value.msg!);
      }
    });
  }

  Rewardbtn1(onTap()) {
    if (preferences?.getBool("btn1") == null || preferences?.getBool("btn1") == true) {
      return gameBtnWidget(
        ontap: () {
          onTap();
        },
        gamename: 'game_screen_game_name_1'.tr(),
        gamebalance: "${gameCoin1 ?? 0}",
      );
    } else {
      return InkWell(
          child: gameRewardWidget(
              btnText: "${gameCoin1 ?? 0}",
              btnOnClick: () async {
                loadApplovinRewordedAds("1");
              }));
    }
  }

  Rewardbtn2(onTap()) {
    if (preferences?.getBool("btn2") == null || preferences?.getBool("btn2") == true) {
      return gameBtnWidget(
          ontap: () {
            onTap();
          },
          gamename: "game_screen_game_name_2".tr(),
          gamebalance: "${gameCoin2 ?? 0}");
    } else {
      return InkWell(
          child: gameRewardWidget(
        btnText: "${gameCoin2 ?? 0}",
        btnOnClick: () async {
          loadApplovinRewordedAds("2");
        },
      ));
    }
  }

  Rewardbtn3(onTap()) {
    if (preferences?.getBool("btn3") == null || preferences?.getBool("btn3") == true) {
      return gameBtnWidget(
          ontap: () {
            onTap();
          },
          gamename: "game_screen_game_name_3".tr(),
          gamebalance: "${gameCoin3 ?? 0}");
    } else {
      setState(() {});
      return InkWell(
          child: gameRewardWidget(
        btnText: "${gameCoin3 ?? 0}",
        btnOnClick: () async {
          loadApplovinRewordedAds("3");
        },
      ));
    }
  }

  Rewardbtn4(onTap()) {
    if (preferences?.getBool("btn4") == null || preferences?.getBool("btn4") == true) {
      return gameBtnWidget(
          ontap: () {
            onTap();
          },
          gamename: "game_screen_game_name_4".tr(),
          gamebalance: "${gameCoin4 ?? 0}");
    } else {
      setState(() {});
      return InkWell(
          child: gameRewardWidget(
        btnText: "${gameCoin4 ?? 0}",
        btnOnClick: () async {
          log(":::::::::::::::::");
          loadApplovinRewordedAds("4");
        },
      ));
    }
  }

  Rewardbtn5(onTap()) {
    if (preferences?.getBool("btn5") == null || preferences?.getBool("btn5") == true) {
      setState(() {});
      return gameBtnWidget(
          ontap: () {
            onTap();
          },
          gamename: "game_screen_game_name_5".tr(),
          gamebalance: "${gameCoin5 ?? 0}");
    } else {
      setState(() {});
      return InkWell(
          child: gameRewardWidget(
        btnText: "${gameCoin5 ?? 0}",
        btnOnClick: () async {
          loadApplovinRewordedAds("5");
        },
      ));
    }
  }

  setUserProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    profileImage = pref.getString("profileImage");
  }

  List<GameBalance> gameBalance_data = [];
  Future<List<GameBalance>>? gameBalance_Obj;
  late Future<UserGameBalanceModel> game_obj;
  _getGameBalanceDetail() async {
    setState(() {
      loading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    UserId = preferences.getString('UserID');
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
    Map request = {
      'user_id': UserId.toString(),
      'api_username': Api.api_username,
      'api_password': Api.api_password,
    };
    Map<String, String> data = {"Accept-Language": language};
    log("my lan $data");
    String gamebalanceurl = Api.base_url + Api.userGameBalance;

    game_obj = ApiConnection().gamebalance(gamebalanceurl, request, data);

    game_obj.then((value) {
      if (value.status == 1) {
        gameBalance = value.gameBalance;
        setState(() {});
      }
    });

    gameBalance_Obj = ApiConnection().getUserGameBalance(url: gamebalanceurl, body: request, hedData: data);
    await gameBalance_Obj?.then((response) async {
      gameBalance_data = (await gameBalance_Obj)!;
      setState(() {
        for (var gameCoin in gameBalance_data) {
          if (gameCoin.gameId == 1) {
            gameCoin1 = gameCoin.gameBalance;
          } else if (gameCoin.gameId == 2) {
            gameCoin2 = gameCoin.gameBalance;
          } else if (gameCoin.gameId == 3) {
            gameCoin3 = gameCoin.gameBalance;
          } else if (gameCoin.gameId == 4) {
            gameCoin4 = gameCoin.gameBalance;
          } else if (gameCoin.gameId == 5) {
            gameCoin5 = gameCoin.gameBalance;
          }
          loading = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leadingWidth: width * 0.3,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0.0,
        leading: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const earnDotGoldScreen()));
          },
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.02, left: width * 0.05),
                height: height * 0.045,
                width: width * 0.24,
                decoration: BoxDecoration(
                    color: const Color(0xFF00E469).withOpacity(0.18), borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      gameBalance == null ? '0' : gameBalance.toString(),
                      style: TextStyle(
                          color: Color(0xFF2C2C2C),
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.017),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Image.asset(
                      'assets/images/20220803_194614_0000-removebg-preview (1).png',
                      height: 24,
                      width: 24,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.25, top: height * 0.01),
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFFFF7E2F),
                ),
                child: Container(
                    margin: EdgeInsets.only(bottom: height * 0.02, top: height * 0.003),
                    child: Icon(
                      Icons.add,
                      color: AppColors.black,
                      size: 15,
                    )),
              ),
            ],
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              var data = await Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
              setState(() {
                setUserProfile();
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: height * 0.02, right: width * 0.02),
              height: height * 0.050,
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
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(profileImage.toString(), fit: BoxFit.cover))),
            ),
          )
        ],
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  margin: EdgeInsets.only(left: width * 0.22, top: height * 0.02),
                  child: SvgPicture.asset('assets/images/dashboard.png'),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.01),
                    height: height * 0.2,
                    width: width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF00E469).withOpacity(0.18),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: height * 0.03, left: width * 0.06, right: width * 0.06),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              'game_screen_ace_blc'.tr(),
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.019),
                            ),
                            SizedBox(height: height * 0.015),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/images/20220803_194614_0000-removebg-preview (1).png',
                                  height: 35,
                                  width: 35,
                                ),
                                SizedBox(width: width * 0.013),
                                Text(
                                  gameBalance == null ? '0' : gameBalance.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-Bold',
                                      color: AppColors.black,
                                      fontSize: height * 0.032,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ]),
                          Column(
                            children: [
                              Container(
                                child:
                                    Image.asset('assets/images/coins 1.png', width: width * 0.3, fit: BoxFit.contain),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: width * 0.08, top: height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'game_screen_play_game_earn_Ace'.tr(),
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: height * 0.024,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat-Bold',
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text('game_screen_play_for_1_rewards'.tr(),
                          style: TextStyle(
                            color: AppColors.mainColor1,
                            fontSize: height * 0.015,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Montserrat',
                          )),
                    ],
                  ),
                ),
                const Divider(color: AppColors.lightGray),
                Container(
                  height: height * 0.6,
                  child: Column(
                    children: [
                      gamesWidget(
                        btnOnClick: () async {
                          InTimeGame1();
                          var data =
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => Game1Play()));
                          if (data != null) {
                            getGame1Time('1');
                          }
                          // showInterstitialAd1();
                        },
                        widget: Rewardbtn1(() async {
                          InTimeGame1();
                          var data =
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => Game1Play()));
                          if (data != null) {
                            getGame1Time('1');
                          }
                        }),
                        image: 'assets/images/game1.png',
                      ),
                      const Divider(color: AppColors.gray),
                      gamesWidget(
                        btnOnClick: () async {
                          InTimeGame1();
                          var data =
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => Game2Play()));
                          if (data != null) {
                            getGame1Time('2');
                          }
                        },
                        image: 'assets/images/game2.png',
                        widget: Rewardbtn2(() async {
                          InTimeGame1();
                          var data =
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => Game2Play()));
                          if (data != null) {
                            getGame1Time('2');
                          }
                        }),
                      ),
                      const Divider(color: AppColors.gray),
                      gamesWidget(
                        btnOnClick: () async {
                          InTimeGame1();
                          var data =
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => Game3Play()));
                          if (data != null) {
                            getGame1Time('3');
                          }
                        },
                        image: 'assets/images/game3.png',
                        widget: Rewardbtn3(() async {
                          InTimeGame1();
                          var data =
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => Game3Play()));
                          if (data != null) {
                            getGame1Time('3');
                          }
                        }),
                      ),
                      const Divider(color: AppColors.gray),
                      gamesWidget(
                        btnOnClick: () async {
                          InTimeGame1();
                          var data =
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => Game4Play()));
                          if (data != null) {
                            getGame1Time('4');
                          }
                        },
                        image: 'assets/images/game4.png',
                        widget: Rewardbtn4(() async {
                          InTimeGame1();
                          var data =
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => Game4Play()));
                          if (data != null) {
                            getGame1Time('4');
                          }
                        }),
                      ),
                      const Divider(color: AppColors.gray),
                      gamesWidget(
                        btnOnClick: () async {
                          InTimeGame1();
                          var data =
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => Game5Play()));
                          if (data != null) {
                            getGame1Time('5');
                          }
                        },
                        image: 'assets/images/game5.png',
                        widget: Rewardbtn5(() async {
                          InTimeGame1();
                          var data =
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => Game5Play()));
                          if (data != null) {
                            getGame1Time('5');
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ]),
              Container(
                child: loading
                    ? Center(
                        child: Stack(
                        children: [
                          Container(
                            height: height,
                            width: width,
                            decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.4, left: width * 0.35),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          ),
                          Container(
                            height: 33,
                            width: 33,
                            margin: EdgeInsets.only(left: width * 0.44, top: height * 0.44),
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
          ),
        ),
      ),
    );
  }

  InTimeGame1() async {
    preferences?.setString('InTime1', DateTime.now().toString());
  }

  getGame1Time(String gameID) async {
    var inTime = preferences?.getString("InTime1");
    var outTime = DateTime.now().toString();
    if (inTime != null && outTime != null) {
      var startTime = DateTime.parse(inTime.toString());
      var currentTime = DateTime.parse(outTime.toString());
      var differenceTime = currentTime.difference(startTime).inMinutes;
      if (differenceTime < 1) {
        if (gameID == '1') {
          preferences?.setBool("btn1", true);
        } else {}
        if (gameID == '2') {
          preferences?.setBool("btn2", true);
        } else {}
        if (gameID == '3') {
          preferences?.setBool("btn3", true);
        } else {}
        if (gameID == '4') {
          preferences?.setBool("btn4", true);
        } else {}
        if (gameID == '5') {
          preferences?.setBool("btn5", true);
        } else {}
      } else {
        if (gameID == '1') {
          preferences?.setBool("btn1", false);
        } else {}
        if (gameID == "2") {
          preferences?.setBool("btn2", false);
        } else {}
        if (gameID == "3") {
          preferences?.setBool("btn3", false);
        } else {}
        if (gameID == "4") {
          preferences?.setBool("btn4", false);
        } else {}
        if (gameID == "5") {
          preferences?.setBool("btn5", false);
        } else {}
      }
    }
    setState(() {});
  }
}
