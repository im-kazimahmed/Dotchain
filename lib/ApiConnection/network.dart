import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:coin_project/Models/ClamRewardModel.dart';
import 'package:coin_project/Models/ForgotPasswordModel.dart';
import 'package:coin_project/Models/SocialloginStatusModel.dart';
import 'package:coin_project/Models/TaskModel.dart';
import 'package:coin_project/Models/deleteAccountModel.dart';
import 'package:coin_project/Models/loginModel.dart';
import 'package:coin_project/Models/logoutModel.dart';
import 'package:coin_project/Models/registerModel.dart';
import 'package:coin_project/Models/resendOTPModel.dart';
import 'package:coin_project/Models/usergameBalanceModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../Models/AppVersionModel.dart';
import '../Models/ChatMassageModelList.dart';
import '../Models/EditProfileModel.dart';
import '../Models/EmailOTPVerifyModel.dart';
import '../Models/GetchatuseListModel.dart';
import '../Models/ProfileModel.dart';
import '../Models/SendMassgeModel.dart';
import '../Models/SendReminderModel.dart';
import '../Models/Speed_CurrentBalanceModel.dart';
import '../Models/Start_M_Model.dart';
import '../Models/changePasswordModel.dart';
import '../Models/confirmdeleteAccountModel.dart';
import '../Models/forgot_password_OTPModel.dart';
import '../Models/socialLoginModel.dart';
import '../Models/totalUser_count_Model.dart';
import '../Models/usergameBalanceModel.dart';

class ApiConnection {
  Future<loginModel> loginClass(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);

    http.post(Uri.parse(url), body: body, headers: hedData);
    if (res.statusCode == 200) {
      return loginModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return loginModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<registerModel> registerClass(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData).timeout(Duration(seconds: 15));
    if (res.statusCode == 200) {
      return registerModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return registerModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<VerifyOTPModel> verifyOTP(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return VerifyOTPModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return VerifyOTPModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<Start_M_Model> Start_m(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return Start_M_Model.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return Start_M_Model.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<totalUser_count_Model> referalTeamCount(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return totalUser_count_Model.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return totalUser_count_Model.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<List<TotalRefererUsersList>> ActivereferalTeam(
      {required String url, required Map body, required Map<String, String>? hedData}) async {
    List<TotalRefererUsersList> x = [];
    final response = await httpClient(url, body, hedData);
    if (response.statusCode == 200) {
      log("User  List is :: ${utf8.decoder.convert(response.bodyBytes)}");
      var res = json.decode(utf8.decoder.convert(response.bodyBytes));
      x.clear();
      for (var i = 0; i < res['result']["total_referer_users_list"].length; i++) {
        if (res['result']["total_referer_users_list"][i]['mining_status'] == "1") {
          x.add(TotalRefererUsersList(
            id: res['result']["total_referer_users_list"][i]["id"],
            miningStatus: res['result']["total_referer_users_list"][i]["mining_status"],
            profilePic: res['result']["total_referer_users_list"][i]["profile_pic"],
            username: res['result']["total_referer_users_list"][i]["username"],
            masterId: res['result']["total_referer_users_list"][i]["master_id"],
          ));
        }
      }
      log("User Details Length:- " + x.length.toString());
    } else {
      throw Exception('Failed to get USer Details response');
    }
    return x;
  }

  Future<List<TotalRefererUsersList>> InactivereferalTeam(
      {required String url, required Map body, required Map<String, String>? hedData}) async {
    List<TotalRefererUsersList> x = [];
    final response = await httpClient(url, body, hedData);
    if (response.statusCode == 200) {
      log("User  List is :: ${utf8.decoder.convert(response.bodyBytes)}");
      var res = json.decode(utf8.decoder.convert(response.bodyBytes));
      x.clear();
      for (var i = 0; i < res['result']["total_referer_users_list"].length; i++) {
        if (res['result']["total_referer_users_list"][i]['mining_status'] == "0") {
          x.add(TotalRefererUsersList(
              id: res['result']["total_referer_users_list"][i]["id"],
              miningStatus: res['result']["total_referer_users_list"][i]["mining_status"],
              profilePic: res['result']["total_referer_users_list"][i]["profile_pic"],
              username: res['result']["total_referer_users_list"][i]["username"],
              masterId: res["result"]["total_referer_users_list"][i]["master_id"]));
        }
      }
      log("User Details Length:- " + x.length.toString());
    } else {
      throw Exception('Failed to get USer Details response');
    }
    return x;
  }

  Future<List<GetUserResult>> GetUserChateListClass(String url, Map body, Map<String, String>? hedData) async {
    List<GetUserResult> x = [];
    final response = await httpClient(url, body, hedData);
    if (response.statusCode == 200) {
      var res = json.decode(utf8.decoder.convert(response.bodyBytes));
      x.clear();
      for (var i = 0; i < res["result"].length; i++) {
        x.add(GetUserResult(
          username: res["result"][i]["username"],
          masterId: res["result"][i]["master_id"],
          message: res["result"][i]["message"],
          profilePic: res["result"][i]["profile_pic"],
          dateTime: res["result"][i]["date_time"],
          fromUserId: res["result"][i]["from_user_id"],
          toUserId: res["result"][i]["to_user_id"],
        ));
      }
    } else {
      throw Exception("${utf8.decoder.convert(response.bodyBytes)}");
    }
    return x;
  }

  Future<List<ChatMassageList>> GetmessageChateListClass(String url, Map body, Map<String, String>? hedData) async {
    List<ChatMassageList> x = [];
    final response = await httpClient(url, body, hedData);
    if (response.statusCode == 200) {
      var res = json.decode(utf8.decoder.convert(response.bodyBytes));
      x.clear();
      for (var i = 0; i < res["result"].length; i++) {
        x.add(ChatMassageList(
          fromUserId: res["result"][i]["from_user_id"],
          message: res["result"][i]["message"],
          toUserId: res["result"][i]["to_user_id"],
          userChatMasterId: res["result"][i]["user_chat_master_id"],
          profilePic: res["result"][i]["profile_pic"],
          toProfilePic: res["result"][i]["to_profile_pic"],
        ));
      }
    } else {
      throw Exception("${utf8.decoder.convert(response.bodyBytes)}");
    }
    return x;
  }

  Future<Speed_CurrentBalanceModel> CurrentBalance(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return Speed_CurrentBalanceModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return Speed_CurrentBalanceModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<CheckLoginStatusModel> CheckLoginStatus(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return CheckLoginStatusModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return CheckLoginStatusModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<Social_loginModel> socailLogin(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return Social_loginModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return Social_loginModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<LogoutModel> logout(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return LogoutModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return LogoutModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<EditProfileModel> editProfile(
      url, Map<String, String> body, File Imagename, Map<String, String>? hedData) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    final request = await http.MultipartRequest(
      "POST",
      Uri.parse(url),
    );
    request.files.add(
      await http.MultipartFile.fromPath('profile_pic', Imagename.path),
    );
    request.fields.addAll(body);
    request.headers.addAll(hedData!);
    final res = await request.send();
    var response = await http.Response.fromStream(res);
    if (res.statusCode == 200) {
      return EditProfileModel.fromJson(jsonDecode(utf8.decoder.convert(response.bodyBytes)));
    } else {
      return EditProfileModel.fromJson(jsonDecode(utf8.decoder.convert(response.bodyBytes)));
    }
  }

  Future<ForgotPasswordModel> forgotPassword(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return ForgotPasswordModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return ForgotPasswordModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<reminderModel> sendReminder(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return reminderModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return reminderModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<ResendOTPModel> resendOTP(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return ResendOTPModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return ResendOTPModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<ClamRewardModel> ClamReward(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return ClamRewardModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return ClamRewardModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<UserProfileModel> profile(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return UserProfileModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return UserProfileModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<SendMassageModel> sendMessageClass(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return SendMassageModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return SendMassageModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<ChangePasswordModel> changePassword(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return ChangePasswordModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return ChangePasswordModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<deleteAccountModel> deleteAccount(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return deleteAccountModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return deleteAccountModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<ConfirmDeleteAccountModel> confirmdeleteAccount(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return ConfirmDeleteAccountModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return ConfirmDeleteAccountModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<List<GameBalance>> getUserGameBalance(
      {required String url, required Map body, required Map<String, String>? hedData}) async {
    List<GameBalance> x = [];
    final response = await httpClient(url, body, hedData);
    if (response.statusCode == 200) {
      var res = json.decode(utf8.decoder.convert(response.bodyBytes));
      x.clear();
      for (var i = 0; i < res['result'].length; i++) {
        x.add(GameBalance(
          gameId: res['result'][i]["game_id"],
          gameBalance: res['result'][i]["game_balance"],
        ));
      }
    } else {
      throw Exception('Failed to get User game balance Details response');
    }
    return x;
  }

  Future<dynamic> updateUserTask(String url, Map body, Map<String, String>? hedData) async {
    final res = await http.post(Uri.parse(url), body: body, headers: hedData);
    if (res.statusCode == 200) {
      return jsonDecode(utf8.decoder.convert(res.bodyBytes));
    } else {
      return jsonDecode(utf8.decoder.convert(res.bodyBytes));
    }
  }

  Future<UserGameBalanceModel> gamebalance(String url, Map body, Map<String, String>? hedData) async {
    final res = await http.post(Uri.parse(url), body: body, headers: hedData);
    if (res.statusCode == 200) {
      return UserGameBalanceModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return UserGameBalanceModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<List<Task>> getTasks({required String url, required Map body, required Map<String, String>? hedData}) async {
    List<Task> tasks = [];
    final response = await httpClient(url, body, hedData);

    if (response.statusCode == 200) {
      var res = json.decode(utf8.decoder.convert(response.bodyBytes));
      tasks.clear();
      for (var i = 0; i < res['result'].length; i++) {
        tasks.add(Task.fromJson(res['result'][i]));
      }
    } else {
      throw Exception('Failed to get Task Details response');
    }

    return tasks;
  }


  Future<UserGameBalanceModel> updateGameBalance(String url, Map body, Map<String, String>? hedData) async {
    final res = await http.post(Uri.parse(url), body: body, headers: hedData);
    if (res.statusCode == 200) {
      return UserGameBalanceModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return UserGameBalanceModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<getAppVersionModel> getAppVersion(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return getAppVersionModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return getAppVersionModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<ForgotPassword_OTPModel> forgotPassword_OTP(String url, Map body, Map<String, String>? hedData) async {
    final res = await httpClient(url, body, hedData);
    if (res.statusCode == 200) {
      return ForgotPassword_OTPModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    } else {
      return ForgotPassword_OTPModel.fromJson(jsonDecode(utf8.decoder.convert(res.bodyBytes)));
    }
  }

  Future<dynamic> httpClient(String url, Map body, Map<String, String>? headers) async {
    // final headers = {"Accept-language": locale.toString()};
    final res = await http.post(Uri.parse(url), body: body, headers: headers);
    var responseToReturn = res;
    log("===========================API call started===============================");
    log("URL : ${url}");
    log("Request : ${body.toString()}");
    log("Status Code : ${res.statusCode}");
    log("Response: ${jsonDecode(utf8.decoder.convert(res.bodyBytes))}");
    log("===========================API call end===============================");
    return responseToReturn;
  }
}
