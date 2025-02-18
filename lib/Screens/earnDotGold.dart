import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppColors/appColors.dart';
import 'Profile.dart';

class earnDotGoldScreen extends StatefulWidget {
  const earnDotGoldScreen({Key? key}) : super(key: key);

  @override
  State<earnDotGoldScreen> createState() => _earnDotGoldScreenState();
}

class _earnDotGoldScreenState extends State<earnDotGoldScreen> {

  String ?profileImage,gameBalance;

  @override
  void initState() {
    super.initState();
    getSpeedCount();
  }

  getSpeedCount()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    gameBalance = preferences.getString('GameBalance');
    var image = preferences.getString('profileImage');
    profileImage = image.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        decoration:  BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [AppColors.mainColor1, AppColors.mainColor])),
       child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top:height * 0.06, left: width * 0.05),
                              height: height * 0.044, width: width * 0.25,
                              decoration: BoxDecoration(
                                  color: const Color(0xFF00E469).withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //SizedBox(width: width * 0.01,),
                                  Text(
                                    gameBalance == null
                                        ? "0.0"
                                        : gameBalance.toString(),
                                    style: TextStyle(
                                        color: Color(0xFF2C2C2C),
                                        fontFamily: 'Montserrat-Bold',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(width: width * 0.02,),
                                  Container(
                                      height: height * 0.026,
                                      child: Image.asset('assets/images/dotgold.png'))
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: width * 0.25, top: height * 0.07),
                              child: Icon(Icons.add,color: AppColors.black,size: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            var data = await Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
                            getSpeedCount();
                          },
                          child: Stack(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      top: height * 0.06, right: width * 0.03),
                                  height: height * 0.055,
                                  width: width * 0.12,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGray.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: profileImage == null
                                      ? ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(100),
                                    child: Image.asset(
                                      'assets/images/profileimage.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(100),
                                      child: profileImage == null
                                          ? Image.asset(
                                        'assets/images/profileimage.jpg',
                                        fit: BoxFit.cover,
                                      )
                                          : Image.network(
                                          profileImage!.toString()))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Container(
                  height: height * 0.9,
                  decoration: const BoxDecoration(
                      color: AppColors.white,
                     borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.03,
                              left:MediaQuery.of(context).size.width * 0.03),
                          child: Row(
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                              Text('earn_dot_gold_screen_about_ace'.tr(),
                                style: TextStyle(fontSize: height * 0.024,fontWeight: FontWeight.w600,fontFamily: 'Montserrat-Bold'),
                              )
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                            height: MediaQuery.of(context).size.height * 0.13,
                            width:  MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color:Color(0xFFF6F6F6).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.035,
                                  left: MediaQuery.of(context).size.width * 0.04,
                                  right: MediaQuery.of(context).size.width * 0.01
                              ),
                              child:  Text('earn_dot_gold_screen_long_text_one'.tr() ,textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.w500,fontSize: height * 0.017,fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.03,
                                left:MediaQuery.of(context).size.width * 0.03),
                            child: Row(
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                                Text('earn_dot_gold_screen_uses_of_ace'.tr(),
                                  style: TextStyle(fontSize: height * 0.024,fontWeight: FontWeight.w600,fontFamily: 'Montserrat-Bold'),
                                )
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                            height: MediaQuery.of(context).size.height * 0.25,
                            width:  MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color:Color(0xFFF6F6F6).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: height * 0.02),
                                Row(
                                  children: [
                                    Container(


                                      width: width * 0.01,

                                        margin: EdgeInsets.only(right: width * 0.02,bottom: height * 0.1),
                                        child: Icon(Icons.arrow_right,color: AppColors.black,size: 45)),
                                    SizedBox(width: width * 0.07),
                                    Expanded(
                                      child: Text("earn_dot_gold_screen_long_text_two".tr(),
                                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: height * 0.017,fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                        width: width * 0.01,
                                        margin: EdgeInsets.only(right: width * 0.02),
                                        child: Icon(Icons.arrow_right,color: AppColors.black,size: 45)),
                                    Container(
                                      margin: EdgeInsets.only(left: width * 0.07),
                                      child: Text("earn_dot_gold_screen_more_ace".tr(),
                                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: height * 0.017,fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.03,
                                left:MediaQuery.of(context).size.width * 0.03),
                            child: Row(
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                                Text('earn_dot_gold_screen_ace_token'.tr(),
                                  style: TextStyle(fontSize: height * 0.024,fontWeight: FontWeight.w600,fontFamily: 'Montserrat-Bold'),
                                )
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                            height: MediaQuery.of(context).size.height * 0.085,
                              width:  MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color:Color(0xFFF6F6F6).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.035,
                                  left: MediaQuery.of(context).size.width * 0.04,
                                  right: MediaQuery.of(context).size.width * 0.01
                              ),
                              child:  Text('earnDotGoldScreen_available_trading'.tr() ,textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.w400,fontSize: height * 0.017,fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
