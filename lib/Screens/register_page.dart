import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:coin_project/ApiConnection/Api.dart';
import 'package:coin_project/ApiConnection/network.dart';
import 'package:coin_project/Models/registerModel.dart';
import 'package:coin_project/Screens/login_page.dart';
import 'package:coin_project/Screens/refer_page.dart';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:local_captcha/local_captcha.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppColors/appColors.dart';
import '../Models/SocialloginStatusModel.dart';
import '../widgets/txtfield.dart';
import 'HomePage.dart';
import 'VerificationScreen.dart';
import 'register_otp_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  _checkPlatform() {
    if (Platform.isAndroid) {
      return InkWell(
        onTap: () {
          signInWithGoogle(context);
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.075,
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.018, bottom: MediaQuery.of(context).size.height * 0.018),
              child: SvgPicture.asset('assets/svg_images/google.svg')),
        ),
      );
    } else if (Platform.isIOS) {
      return InkWell(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height * 0.075,
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.015, bottom: MediaQuery.of(context).size.height * 0.015),
            child: SvgPicture.asset('assets/svg_images/apple.svg'),
          ),
        ),
      );
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController referCode = TextEditingController();
  TextEditingController captchaCode = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final _configFormKey = GlobalKey<FormState>();
  final _localCaptchaController = LocalCaptchaController();
  final _configFormData = ConfigFormData();
  final _refreshButtonEnableVN = ValueNotifier(true);

  Timer? _refreshTimer = null;

  @override
  void dispose() {
    _localCaptchaController.dispose();
    _refreshTimer?.cancel();
    _refreshTimer = null;

    super.dispose();
  }

  bool _autoValidate = false, loading = false, pwdHide = true, btnChange1 = false;
  String? SocialUserID, SocailUserName, socialEmail, userId, userEmail, profileImage;

  late Future<CheckLoginStatusModel> starusObj;
  signInWithGoogle(context) async {
    String? token = await FirebaseMessaging.instance.getToken();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential =
        GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      try {
        var viLang = preferences.getString("vi");
        var engLang = preferences.getString("en");
        var zhLang = preferences.getString("zh");
        var filLang = preferences.getString("fil");
        var idLang = preferences.getString("id");
        var koLang = preferences.getString("ko");
        SocialUserID = value.user?.uid;
        socialEmail = value.user?.email;
        preferences.setString('UserEmail', socialEmail!);
        preferences.setString('userId', SocialUserID!);
        preferences.setBool("seen", true);
        ShowLoadingIndicator();
        setState(() {
          btnChange1 = true;
        });
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
        String StatusUrl = Api.base_url + Api.checkLoginStatus;

        Map request = {
          "social_id": SocialUserID.toString(),
          "api_username": Api.api_username,
          "api_password": Api.api_password,
          "app_token": token,
        };
        Map<String, String> data = {"Accept-Language": language};
        log("my lan $data");
        starusObj = ApiConnection().CheckLoginStatus(StatusUrl, request, data);
        starusObj.then((value) {
          if (value.status == 1) {
            if (value.result?.status == 0) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ReferScreen()));
            } else if (value.result?.status == 1) {
              userId = value.result?.id.toString();

              preferences.setString('UserID', userId!);
              profileImage = value.result?.profilePic;
              preferences.setString('profileImage', profileImage!);
              log('user ID is :::::${value.result?.id}');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
            }
          } else {
            Fluttertoast.showToast(msg: value.msg.toString());
          }
        });
      } catch (error) {
        debugPrint("Login Failed");
      }
    });
  }

  ShowLoadingIndicator() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                child: btnChange1
                    ? Center(
                        child: Stack(
                        children: [
                          Container(
                            //margin: EdgeInsets.only(top: height * 0.25),
                            height: height, width: width,
                            decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)),
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
                            margin: EdgeInsets.only(left: width * 0.43, top: height * 0.435),
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
          );
        });
  }

  Future<registerModel>? registerObj;

  _register() async {
    setState(() {
      loading = true;
    });
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
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
      String RegisterUrl = Api.base_url + Api.register;
      log("Register Url  :::::::$RegisterUrl");
      Map resquest = {
        "username": username.text.trim(),
        "email": email.text.trim(),
        "password": password.text.trim(),
        "confirm_password": confirmPassword.text.trim(),
        "referal_code": referCode.text.trim(),
        "check_otp": 0.toString(),
        "api_username": Api.api_username,
        "api_password": Api.api_password,
      };
      Map<String, String> data = {"Accept-Language": language};
      log("my lan $data");
      registerObj = ApiConnection().registerClass(RegisterUrl, resquest, data);
      await registerObj!.then((value) {
        setState(() {
          loading = false;
        });
        if (value.status == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const VerificationScreen()));
          userId = value.result?.id;
          userEmail = value.result?.email;
          preferences.setString('UserID', userId!);
          preferences.setString('UserEmail', userEmail!);
          username.clear();
          email.clear();
          password.clear();
          confirmPassword.clear();
          referCode.clear();
        } else {
          Fluttertoast.showToast(msg: value.msg.toString());
        }
      });
      setState(() {
        loading = false;
      });
    } catch (e) {
      log("..........${e}...........");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [AppColors.mainColor, AppColors.mainColor1])),
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.06),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, true);
                              SystemNavigator.pop();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: height * 0.01, left: width * 0.05),
                              child: const Icon(Icons.arrow_back_ios_outlined, color: AppColors.black, size: 18),
                            ),
                          ),
                          SizedBox(width: width * 0.27),
                          Text(
                            'sign_up'.tr(),
                            style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: height * 0.032,
                                fontFamily: 'Montserrat-Bold'),
                          ),
                        ],
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: height * 0.03,
                          ),
                          child: Text(
                            'register_page_sign_up_one_option'.tr(),
                            style: TextStyle(
                                color: AppColors.black,
                                fontSize: height * 0.018,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.045, right: width * 0.03, left: width * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [_checkPlatform()],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08, top: height * 0.05),
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            obscureText: false,
                            textAlign: TextAlign.justify,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'login_validation_username'.tr();
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: height * 0.019),
                            controller: username,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.person_outline_outlined,
                                  color: AppColors.black,
                                ),
                                hintStyle: TextStyle(fontFamily: 'Montserrat', fontSize: height * 0.019),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.black, width: 1),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(color: AppColors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: 'username'.tr()),
                          )),
                      Container(
                        margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08, top: height * 0.03),
                        child: txtField_widget(
                            obscureText: false,
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email) ? 'enter_valid_email'.tr() : null,
                            textEditingController: email,
                            icon: const Icon(
                              Icons.email_outlined,
                              color: AppColors.black,
                            ),
                            text: 'register_page_enter_email'.tr(),
                            inputType: TextInputType.emailAddress),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08, top: height * 0.03),
                        child: txtField_widget(
                            obscureText: pwdHide,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'login_validation_password'.tr();
                              } else if (value.length < 8) {
                                return 'enter_minimum_8'.tr();
                              } else {
                                return null;
                              }
                            },
                            textEditingController: password,
                            icon: const Icon(
                              Icons.lock_outlined,
                              color: AppColors.black,
                            ),
                            text: 'password'.tr(),
                            inputType: TextInputType.emailAddress),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08, top: height * 0.03),
                        child: txtField_widget(
                            obscureText: pwdHide,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter_confirm_password'.tr();
                              } else if (confirmPassword.text != password.text) {
                                return "enter_valid_confirm_password".tr();
                              }
                              return null;
                            },
                            textEditingController: confirmPassword,
                            icon: const Icon(
                              Icons.lock_outlined,
                              color: AppColors.black,
                            ),
                            text: 'register_page_confirm_password'.tr(),
                            inputType: TextInputType.emailAddress),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08, top: height * 0.03),
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            obscureText: false,
                            textAlign: TextAlign.justify,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter_refer_code'.tr();
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: height * 0.019),
                            controller: referCode,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.person_outline_outlined,
                                  color: AppColors.black,
                                ),
                                hintStyle: TextStyle(fontFamily: 'Montserrat', fontSize: height * 0.019),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.black, width: 1),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(color: AppColors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: 'refer_code'.tr()),
                          )),
                      SizedBox(height: height * 0.05),
                      Stack(
                        children: [
                          Center(
                            child: LocalCaptcha(
                              key: ValueKey(_configFormData.toString()),
                              controller: _localCaptchaController,
                              height: 60,
                              width: 300,
                              backgroundColor: Colors.grey[100]!,
                              chars: _configFormData.chars,
                              length: _configFormData.length,
                              fontSize: _configFormData.fontSize > 0
                                  ? _configFormData.fontSize
                                  : null,
                              caseSensitive: _configFormData.caseSensitive,
                              codeExpireAfter: _configFormData.codeExpireAfter,
                              onCaptchaGenerated: (captcha) {
                                debugPrint('Generated captcha: $captcha');
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 40.0,
                            margin: EdgeInsets.only(right: 50, top: 10),
                            width: double.infinity,
                            child: ValueListenableBuilder(
                                valueListenable: _refreshButtonEnableVN,
                                builder: (context, enable, child) {
                                  final onPressed = enable != null
                                      ? () {
                                    if (_refreshTimer == null) {
                                      // Prevent spam pressing refresh button.
                                      _refreshTimer =
                                          Timer(const Duration(seconds: 1), () {
                                            _refreshButtonEnableVN.value = true;

                                            _refreshTimer?.cancel();
                                            _refreshTimer = null;
                                          });

                                      _refreshButtonEnableVN.value = false;
                                      _localCaptchaController.refresh();
                                    }
                                  }
                                      : null;

                                  return InkWell(
                                    onTap: onPressed,
                                    child: Container(
                                      child: Icon(Icons.refresh),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08, top: height * 0.03),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          obscureText: false,
                          textAlign: TextAlign.justify,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (value.length != _configFormData.length) {
                                return '* Code must be length of ${_configFormData.length}.';
                              }

                              final validation =
                              _localCaptchaController.validate(value);

                              switch (validation) {
                                case LocalCaptchaValidation.invalidCode:
                                  return '* Invalid code.'.tr();

                                case LocalCaptchaValidation.codeExpired:
                                  return '* Code expired.'.tr();
                                case LocalCaptchaValidation.valid:
                                default:
                                  return null;
                              }
                            }

                            return '* Required field.'.tr();
                          },
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: height * 0.019),
                          controller: captchaCode,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.numbers,
                              color: AppColors.black,
                            ),
                            hintStyle: TextStyle(fontFamily: 'Montserrat', fontSize: height * 0.019),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.black, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: AppColors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.black,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: 'enter_code'.tr(),
                          ),
                        ),
                      ),

                      // TextFormField(
                      //   decoration: const InputDecoration(
                      //     labelText: 'Enter code',
                      //     hintText: 'Enter code',
                      //     isDense: true,
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   validator: (value) {
                      //     if (value != null && value.isNotEmpty) {
                      //       if (value.length != _configFormData.length) {
                      //         return '* Code must be length of ${_configFormData.length}.';
                      //       }
                      //
                      //       final validation =
                      //       _localCaptchaController.validate(value);
                      //
                      //       switch (validation) {
                      //         case LocalCaptchaValidation.invalidCode:
                      //           return '* Invalid code.';
                      //         case LocalCaptchaValidation.codeExpired:
                      //           return '* Code expired.';
                      //         case LocalCaptchaValidation.valid:
                      //         default:
                      //           return null;
                      //       }
                      //     }
                      //
                      //     return '* Required field.';
                      //   },
                      //   onSaved: (value) => _inputCode = value ?? '',
                      // ),
                      SizedBox(height: height * 0.05),
                      Center(
                        child: Container(
                          height: height * 0.075,
                          width: width * 0.82,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  primary: AppColors.black,
                                  elevation: 0.0),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  var result = await (Connectivity().checkConnectivity());
                                  if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
                                    _register();
                                  } else {
                                    Fluttertoast.showToast(msg: 'enternet_error'.tr());
                                  }
                                } else {
                                  setState(() {
                                    _autoValidate = true;
                                  });
                                }
                              },
                              child: loading
                                  ? SizedBox(
                                      width: width * 0.1,
                                      child: LoadingIndicator(
                                        indicatorType: Indicator.ballBeat,
                                        colors: [AppColors.mainColor, AppColors.mainColor, AppColors.mainColor],
                                        strokeWidth: 1,
                                        pathBackgroundColor: Colors.black,
                                      ),
                                    )
                                  : Text("register_page_create_account".tr(),
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: height * 0.022,
                                          fontWeight: FontWeight.w500))),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('register_page_acc_already'.tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: height * 0.015, fontFamily: 'Montserrat')),
                          SizedBox(width: width * 0.015),
                          InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                              },
                              child: Text(
                                'login_in'.tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat-Bold',
                                    decoration: TextDecoration.underline,
                                    fontSize: height * 0.015),
                              )),
                        ],
                      ),
                      SizedBox(height: height * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _configForm(BuildContext context) {
    return Form(
      key: _configFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Basic Configs',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            initialValue: _configFormData.chars,
            decoration: const InputDecoration(
              labelText: 'Captcha chars',
              hintText: 'Captcha chars',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                return null;
              }

              return '* Required field.';
            },
            onSaved: (value) => _configFormData.chars = value?.trim() ?? '',
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            initialValue: '${_configFormData.length}',
            decoration: const InputDecoration(
              labelText: 'Captcha code length',
              hintText: 'Captcha code length',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final length = int.tryParse(value) ?? 0;

                if (length < 1) {
                  return '* Value must be greater than 0.';
                }

                return null;
              }

              return '* Required field.';
            },
            onSaved: (value) =>
            _configFormData.length = int.tryParse(value ?? '1') ?? 1,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            initialValue:
            '${_configFormData.fontSize > 0 ? _configFormData.fontSize : ''}',
            decoration: const InputDecoration(
              labelText: 'Font size (optional)',
              hintText: 'Font size (optional)',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => _configFormData.fontSize =
                double.tryParse(value ?? '0.0') ?? 0.0,
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<bool>(
            value: _configFormData.caseSensitive,
            isDense: true,
            decoration: const InputDecoration(
              labelText: 'Case sensitive',
              hintText: 'Case sensitive',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: false,
                child: Text('No'),
              ),
              DropdownMenuItem(
                value: true,
                child: Text('Yes'),
              ),
            ],
            onChanged: (value) =>
            _configFormData.caseSensitive = value ?? false,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            initialValue: '${_configFormData.codeExpireAfter.inMinutes}',
            decoration: const InputDecoration(
              labelText: 'Code expire after (minutes)',
              hintText: 'Code expire after (minutes)',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final length = int.tryParse(value) ?? 0;

                if (length < 1) {
                  return '* Value must be greater than 0.';
                }

                return null;
              }

              return '* Required field.';
            },
            onSaved: (value) => _configFormData.codeExpireAfter =
                Duration(minutes: int.tryParse(value ?? '1') ?? 1),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: 40.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_configFormKey.currentState?.validate() ?? false) {
                  _configFormKey.currentState!.save();

                  setState(() {});
                }
              },
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }

}

class ConfigFormData {
  String chars = 'abdefghnryABDEFGHNQRY3468';
  int length = 5;
  double fontSize = 0;
  bool caseSensitive = false;
  Duration codeExpireAfter = const Duration(minutes: 10);

  @override
  String toString() {
    return '$chars$length$caseSensitive${codeExpireAfter.inMinutes}';
  }
}
