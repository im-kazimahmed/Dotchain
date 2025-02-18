import 'dart:developer';

import 'package:coin_project/AppColors/appColors.dart';
import 'package:coin_project/Screens/ChatDetails.dart';
import 'package:coin_project/widgets/activeuser_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiConnection/Api.dart';
import '../ApiConnection/network.dart';
import '../Models/totalUser_count_Model.dart';

class InActiveUser extends StatefulWidget {
  const InActiveUser({Key? key}) : super(key: key);

  @override
  State<InActiveUser> createState() => _InActiveUserState();
}

class _InActiveUserState extends State<InActiveUser> {

  String fromUserId = "";
  String? UserId;
  @override
  void initState() {
    super.initState();
    _getInactiveTeamDetail();
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState((){
        onChange =! onChange;
      });
    });
  }
  bool loading = true;
  bool onChange = false;

  List<TotalRefererUsersList> inactiveteam_data = [];
  late Future<List<TotalRefererUsersList>> inactiveteam_Obj;
  _getInactiveTeamDetail() async {
    setState(() {
      loading = true;
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    UserId = preferences.getString('UserID');
    var  viLang = preferences.getString("vi");
    var  engLang = preferences.getString("en");
    var  zhLang = preferences.getString("zh");
    var  filLang = preferences.getString("fil");
    var  idLang = preferences.getString("id");
    var  koLang = preferences.getString("ko");
    var language;
    if(zhLang == "zh"){
      language = zhLang;
      preferences.remove('en');
      preferences.remove('id');
      preferences.remove('fil');
      preferences.remove('ko');
      preferences.remove('vi');
      log("if part lnag${language}");
      setState(() {});
    }
    else if(filLang == "fil"){
      language = filLang;
      preferences.remove('id');
      preferences.remove('en');
      preferences.remove('ko');
      preferences.remove('vi');
      preferences.remove('zh');
      log("if part lnag${language}");
      setState(() {});
    }
    else if(idLang == "id"){
      language = idLang;
      preferences.remove('en');
      preferences.remove('ko');
      preferences.remove('vi');
      preferences.remove('zh');
      preferences.remove('fil');
      log("if part lnag${language}");
      setState(() {});
    }
    else if(koLang == "ko"){
      language = koLang;
      preferences.remove('en');
      preferences.remove('vi');
      preferences.remove('zh');
      preferences.remove('fil');
      preferences.remove('id');
      log("if part lnag${language}");
      setState(() {});
    }
    else if(viLang == "vi"){
      language = viLang;
      preferences.remove('en');
      preferences.remove('zh');
      preferences.remove('fil');
      preferences.remove('id');
      preferences.remove('ko');
      log("if part lnag${language}");
      setState(() {});
    }
    else if(engLang == "en"){
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
      'id' : UserId.toString(),
      'api_username' : Api.api_username,
      'api_password' : Api.api_password,
    };
    Map<String,String> data = {
      "Accept-Language":language
    };
    String TeamUrl = Api.base_url + Api.referal_Team;
    log("my lan $data");
    inactiveteam_Obj =  ApiConnection().InactivereferalTeam(url: TeamUrl, body : request, hedData: data);
    await inactiveteam_Obj.then((response) async {
      inactiveteam_data = await inactiveteam_Obj;
      setState(() {});
    });
  }
  Future<void> _getInactiveDetails() async {
    setState(() {
      _getInactiveTeamDetail();
    });
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: inactiveteam_data.length != 0
          ? RefreshIndicator(
          onRefresh: _getInactiveDetails,
          child: ListView.builder(
            itemCount: inactiveteam_data.length,
            itemBuilder: (context, index){
              return  activeUser_widget(
                USerImage: inactiveteam_data[index].profilePic == null
                    ?"assets/images/profileimage.jpg"
                    : inactiveteam_data[index].profilePic.toString(),
                   activeColor: Colors.red,
                   nameText: inactiveteam_data[index].username.toString(),
                   image: 'assets/svg_images/userchat.svg',
                btnOnClick: ()async{
                    String MasterId =  inactiveteam_data[index].masterId.toString();
                    String UserName =  inactiveteam_data[index].username.toString();
                    String InActiveUserId =  inactiveteam_data[index].id.toString();
                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    fromUserId = UserId.toString();
                    sharedPreferences.setString("chatmasterID", MasterId);
                    sharedPreferences.setString("UserName", UserName);
                    sharedPreferences.setString("toUserId", InActiveUserId);
                    sharedPreferences.setString("fromUserId", fromUserId);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetails()));
              },
                 );
            },
          )
      )
          :  Container(
          child: onChange
              ?Center(child: Text("UserNoteFound".tr(),style: TextStyle(color: AppColors.black,fontSize: height * 0.02,fontFamily: "Montserrat",fontWeight: FontWeight.w600),))
              :SizedBox(
            width: width * 0.07,
            child: const LoadingIndicator(
              indicatorType: Indicator.ballBeat,
              colors: [
                AppColors.orange,
                AppColors.black,
                AppColors.lightGray
              ],
              strokeWidth: 1,
              pathBackgroundColor: Colors.black,
            ),
          )
      )
    );
  }
}
