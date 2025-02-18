import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppColors/appColors.dart';
import 'Profile.dart';

class IncreaseM_Screen extends StatefulWidget {
  const IncreaseM_Screen({Key? key}) : super(key: key);

  @override
  State<IncreaseM_Screen> createState() => _IncreaseM_ScreenState();
}

class _IncreaseM_ScreenState extends State<IncreaseM_Screen> {

  double? currentspeed = 1.5;
  String? profileImage;

  @override
  void initState() {
    super.initState();
    getSpeedCount();
  }

  getSpeedCount()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    currentspeed = preferences.getDouble('CurrentSpeed');
    profileImage = preferences.getString('profileImage');
    setState(() {

    });
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
                              margin: EdgeInsets.only(top: height * 0.06, left: width * 0.05),
                              height: height * 0.050, width: width * 0.21,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFDF9CA),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //SizedBox(width: width * 0.01,),
                                  Text(
                                    currentspeed == null
                                        ? "0.0"
                                        : currentspeed.toString(),
                                    style: TextStyle(
                                        color: Color(0xFF2C2C2C),
                                        fontFamily: 'Montserrat-Bold',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(width: width * 0.02,),
                                  Image.asset(
                                    'assets/images/CHECK.png',height: 24,width: 24,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: width * 0.22, top: height * 0.05),
                              height: 20,width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(0xFFFF7E2F),
                              ),
                              child: Container(
                                  margin: EdgeInsets.only(bottom: height * 0.02,top: height * 0.003),
                                  child: Icon(Icons.add,color: AppColors.black,size: 15,)),
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
                                  child:   profileImage == null ?
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset('assets/images/profileimage.jpg',fit: BoxFit.cover,),
                                  )
                                      : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: profileImage == null
                                          ?  Image.asset('assets/images/profileimage.jpg',fit: BoxFit.cover,)
                                          : Image.network(profileImage!.toString())
                                  )
                              ),

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
                  child:SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03, left:MediaQuery.of(context).size.width * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                                    Text('increase_mining_screen_mining_How_increase'.tr(), style: TextStyle(fontSize: height * 0.026,fontWeight: FontWeight.w600,fontFamily: 'Montserrat-Bold'),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                                    Text('increase_mining_screen_mining_rate'.tr(), style: TextStyle(fontSize: height * 0.026,fontWeight: FontWeight.w600,fontFamily: 'Montserrat-Bold'),),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                                    Text('increase_mining_screen_remote_mining'.tr(), style: TextStyle(fontSize: height * 0.018,fontWeight: FontWeight.w600,fontFamily: 'Montserrat-Bold'),),
                                  ],
                                )
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                            height: MediaQuery.of(context).size.height * 0.16,
                            width:  MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color:Colors.blueGrey.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.03,
                                  left: MediaQuery.of(context).size.width * 0.04,
                                  right: MediaQuery.of(context).size.width * 0.01
                              ),
                              child:  Text('increase_mining_screen_long_text'.tr()  ,textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.w500,fontSize: height *0.016,fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, top: MediaQuery.of(context).size.height * 0.03),
                            child: Row(
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                                Image.asset('assets/images/CHECK.png',height: height * 0.05,width: width * 0.09),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                                Text('increase_mining_screen_invite_users'.tr(),
                                  style:  TextStyle(color: AppColors.black,fontWeight: FontWeight.w600,fontSize:  height * 0.02,fontFamily: 'Montserrat'),)
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03,
                                top: MediaQuery.of(context).size.height * 0.02),
                            child: Row(
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                                Image.asset('assets/images/CHECK.png',height: height * 0.05,width: width * 0.09),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                                Text('increase_mining_screen_grow_referal_team'.tr(),
                                  style:  TextStyle(color: AppColors.black,fontWeight: FontWeight.w600,fontSize:  height * 0.02,fontFamily: 'Montserrat'),)
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03,
                                top: MediaQuery.of(context).size.height * 0.02),
                            child: Row(
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                                Image.asset('assets/images/CHECK.png',height: height * 0.05,width: width * 0.09),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                                Expanded(
                                  child: Text('increase_mining_screen_team_members'.tr(),
                                    style:  TextStyle(color: AppColors.black,fontWeight: FontWeight.w600,fontSize:  height * 0.02,fontFamily: 'Montserrat'),),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.08),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: width * 0.13),
                                    height: height * 0.023,width: width * 0.05,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: AppColors.green),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: width * 0.02),
                                      child: Text('increase_mining_screen_mining_rate_increased'.tr(),
                                        style:  TextStyle(color: AppColors.black,fontWeight: FontWeight.w600,fontSize:  height * 0.012,fontFamily: 'Montserrat'),),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: height * 0.02),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: width * 0.13),
                                    height: height * 0.023,width: width * 0.05,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Colors.red),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: width * 0.02,top: height * 0.012),
                                      child: Text("increase_mining_screen_mining_rate_decreased".tr(),
                                        style:  TextStyle(color: AppColors.black,fontWeight: FontWeight.w600,fontSize:  height * 0.012,fontFamily: 'Montserrat'),),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
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
