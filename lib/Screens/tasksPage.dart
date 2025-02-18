import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:coin_project/ApiConnection/Api.dart';
import 'package:coin_project/ApiConnection/network.dart';
import 'package:coin_project/Models/TaskModel.dart';
import 'package:coin_project/Models/usergameBalanceModel.dart';
import 'package:coin_project/Screens/earnDotGold.dart';
import 'package:coin_project/widgets/gameReward_btn.dart';
import 'package:coin_project/widgets/task_widget.dart';
import 'package:coin_project/widgets/taskbtn_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AppColors/appColors.dart';
import 'Profile.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String? gameBalance, profileImage;
  final String _rewarded_ad_unit_id1 = Platform.isAndroid ? "40b342303794ffa4" : "IOS_REWARDED_AD_UNIT_ID";
  SharedPreferences? preferences;
  List<Task> tasks_list = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _getGameBalanceDetail();
    setUserProfile();
    _fetchTasksFromApi();
  }

  _initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<void> _fetchTasksFromApi() async {
    setState(() {
      loading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UserId = preferences.getString('UserID');
    log("user id ${UserId}");
    var language = "en";

    String url = Api.base_url + Api.getTasks;

    Map request = {
      "user_id": UserId.toString(),
      'api_username': Api.api_username,
      'api_password': Api.api_password,
    };

    Map<String, String> data = {"Accept-Language": language};

    List<Task> tasks = await ApiConnection().getTasks(url: url, body: request, hedData: data);
    if (tasks.isNotEmpty) {
      setState(() {
        tasks_list.clear();
        tasks_list.addAll(tasks);
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  _completeTask(String taskId) async {
    try {
      setState(() {
        loading = true;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var UserID = preferences.getString('UserID');
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
        setState(() {});
      } else if (engLang == "en") {
        language = engLang;
        preferences.remove('zh');
        preferences.remove('fil');
        preferences.remove('id');
        preferences.remove('ko');
        preferences.remove('vi');
        setState(() {});
      }
      Map request = {
        'user_id': UserID.toString(),
        'api_username': Api.api_username,
        'api_password': Api.api_password,
        'task_id': taskId.toString(),
      };
      Map<String, String> data = {"Accept-Language": language};
      String updateGameBalanceUrl = Api.base_url + Api.updateUserTask;

      dynamic result = await ApiConnection().updateUserTask(updateGameBalanceUrl, request, data);
      log("result ${result}");
      if(result != null) {
        if(result['status'] == 1) {
          setState(() {
            preferences.setBool("task_$taskId", true);
            Fluttertoast.showToast(msg: 'task_screen_reward_given'.tr());
            loading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  /// Applovin Reworded Ads
  // void loadApplovinRewordedAds(String gameId) {
  //   setState(() {
  //     loading = true;
  //   });
  //   Timer t = Timer(Duration(seconds: 25), () {
  //     setState(() {
  //       loading = false;
  //     });
  //     _ClamRewad(gameId);
  //   });
  //   AppLovinMAX.loadRewardedAd(_rewarded_ad_unit_id1);
  //   AppLovinMAX.setRewardedAdListener(RewardedAdListener(
  //       onAdLoadedCallback: (ad) {
  //         t.cancel();
  //         AppLovinMAX.showRewardedAd(_rewarded_ad_unit_id1);
  //       },
  //       onAdLoadFailedCallback: (String adUnitId, error) {
  //         setState(() {
  //           loading = false;
  //         });
  //       },
  //       onAdDisplayedCallback: (ad) {
  //         setState(() {
  //           loading = false;
  //         });
  //       },
  //       onAdDisplayFailedCallback: (ad, error) {
  //         setState(() {
  //           loading = false;
  //         });
  //       },
  //       onAdClickedCallback: (ad) {},
  //       onAdHiddenCallback: (ad) {
  //         _ClamRewad(gameId);
  //       },
  //       onAdReceivedRewardCallback: (ad, reward) {}));
  // }


  List<GameBalance> gameBalance_data = [];
  Future<List<GameBalance>>? gameBalance_Obj;
  late Future<UserGameBalanceModel> game_obj;
  _getGameBalanceDetail() async {
    setState(() {
      loading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UserId = preferences.getString('UserID');
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
        loading = false;
      });
    });
  }

  Widget _buildRewardButton(Task task) {
    bool isTaskCompleted = preferences?.getBool("task_${task.id}") ?? false;
    log("task ${task.isCompleted}");
    if(task.isCompleted) {
      return taskBtnWidget(
        gamebalance: task.rewardAmount.toString(),
        isCompleted: true,
      );
    }
    else if (!isTaskCompleted) {
      return taskBtnWidget(
        gamebalance: task.rewardAmount.toString(),
        isCompleted: false,
      );
    } else {
      return InkWell(
        child: gameRewardWidget(
          btnText: "${task.rewardAmount ?? 0}",
          btnOnClick: () async {
            // loadApplovinRewordedAds("5");
            preferences?.setBool("task_${task.id}", false);
            _fetchTasksFromApi();
            _updateGameBalance(task.rewardAmount);
            _getGameBalanceDetail();
          },
          // btnText: "Reward Claimed",
          // btnOnClick: () {},
        ),
      );
    }
  }

  _updateGameBalance(int newBalance) async {
    try {
      setState(() {
        loading = true;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? UserId = preferences.getString('UserID');
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
        setState(() {});
      } else if (engLang == "en") {
        language = engLang;
        preferences.remove('zh');
        preferences.remove('fil');
        preferences.remove('id');
        preferences.remove('ko');
        preferences.remove('vi');
        setState(() {});
      }
      Map request = {
        'user_id': UserId.toString(),
        'api_username': Api.api_username,
        'api_password': Api.api_password,
        'additional_coins': newBalance.toString(),
      };
      Map<String, String> data = {"Accept-Language": language};
      String updateGameBalanceUrl = Api.base_url + Api.updateGameBalance;

      game_obj = ApiConnection().gamebalance(updateGameBalanceUrl, request, data);

      game_obj.then((value) {
        if (value.status == 1) {
          gameBalance = value.gameBalance;
          setState(() {
            loading = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  setUserProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    profileImage = pref.getString("profileImage");
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
                      gameBalance ?? '0',
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
                  child: Image.network(profileImage.toString(), fit: BoxFit.cover)),
            ),
          )
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                  fontWeight: FontWeight.w600,
                                ),
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
                      'task_screen_complete_and_earn'.tr(),
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: height * 0.024,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat-Bold',
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    // Text('task_screen_visit_link_and_claim'.tr(),
                    //     style: TextStyle(
                    //       color: AppColors.mainColor1,
                    //       fontSize: height * 0.015,
                    //       fontWeight: FontWeight.w400,
                    //       fontFamily: 'Montserrat',
                    //     )),
                  ],
                ),
              ),
              const Divider(color: AppColors.lightGray),
              Container(
                height: height * 0.6,
                child: tasks_list.isEmpty ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:50.0),
                    child: Text(
                      'task_screen_no_tasks'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ): Column(
                  children: tasks_list.map((task) {
                    return Column(
                      children: [
                        TaskWidget(
                          btnOnClick:  () async {
                            if(!task.isCompleted) {
                              var taskURL = task.url;
                              // if (!task.url.contains('http') || !task.url.contains('https')) taskURL = 'https://${task.url}';
                              log(taskURL);
                              var url = Uri.parse(taskURL);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                                Future.delayed(Duration(seconds: 10), () {
                                  _completeTask(task.id);
                                });
                              } else {
                                  try {
                                    var taskURL = task.url;
                                    // if (!task.url.contains('http') || !task.url.contains('https')) taskURL = 'https://${task.url}';
                                    await launchUrl(Uri.parse(taskURL), mode: LaunchMode.externalApplication);
                                    Future.delayed(Duration(seconds: 10), () {
                                      _completeTask(task.id);
                                    });
                                  } catch (e) {
                                    final Uri fallbackUrl = Uri.parse('https://play.google.com/store/apps/details?id=org.telegram.messenger');
                                    if (await canLaunchUrl(fallbackUrl)) {
                                      await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
                                    } else {
                                      Fluttertoast.showToast(msg: "Could not open task link.");
                                    }
                                  }
                              }
                            } else {
                              var taskURL = task.url;
                              var url = Uri.parse(taskURL);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                try {
                                  var taskURL = task.url;
                                  // if (!task.url.contains('http') || !task.url.contains('https')) taskURL = 'https://${task.url}';
                                  await launchUrl(Uri.parse(taskURL), mode: LaunchMode.externalApplication);
                                } catch (e) {
                                  final Uri fallbackUrl = Uri.parse('https://play.google.com/store/apps/details?id=org.telegram.messenger');
                                  if (await canLaunchUrl(fallbackUrl)) {
                                    await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
                                  } else {
                                    Fluttertoast.showToast(msg: "Could not open task link.");
                                  }
                                }
                              }
                            }
                          },
                          widget: _buildRewardButton(task),
                          title: task.title,
                          content: task.content,
                        ),
                        const Divider(color: AppColors.gray),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



