import 'dart:ui';

class Api {
 // static const String base_url = "https://dotchain.network/portal/api/";
   static const String base_url = "https://dotchain.network/portal/apiV2/";
  static const String api_username = "admin";
  // static const String api_password = "test123456";
  static const String api_password = "4hwr#q4E5k(g";
  static const String forgotPassword = "forgot_password";
  static const String forgotPasswordOTP = "forgot_password_otp_verify";
  static const String login = 'login_validate';
  static const String register = 'user_signup';
  static const String verifyOTP = 'verify_email_otp';
  static const String startEarnCoin = "start_tapping";
  static const String referal_Team = "referal_team_list";
  static const String logout = "logout";
  static const String currentBalance = "get_current_rate";
  static const String checkLoginStatus = "check_social_login";
  static const String social_login = "social_login";
  static const String editProfile = "user_profile_update";
  static const String sendReminder = "send_reminder";
  static const String resendOTP = "resend_email_otp";
  static const String ClamReward = "claim_game_reward";
  static const String getTasks = "get_tasks";
  static const String updateUserTask = "update_user_task";
  static const String profile = "get_user_profile";
  static const String chatUserListUrl = "get_chat_user_listing";
  static const String chatMessageListUrl = "get_chat_msg_list";
  static const String changePassword = 'change_password';
  static const String sendMassage = "send_chat_msg";
  static const String deleteAccount = "delete_account";
  static const String ConfirmdeleteAccount = "delete_account_confirmation";
  static const String userGameBalance = "get_user_game_balance";
  static const String updateGameBalance = "update_user_game_balance";
  static const String getAppVersion = "get_mobile_app_version";
  static String lang  = Locale.fromSubtags(languageCode: 'en').toString();
}
