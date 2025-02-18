class ForgotPassword_OTPModel {
  int? status;
  String? msg;

  ForgotPassword_OTPModel({this.status, this.msg});

  ForgotPassword_OTPModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}
