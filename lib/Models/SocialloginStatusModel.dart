class CheckLoginStatusModel {
  Result? result;
  int? status;
  String? msg;

  CheckLoginStatusModel({this.result, this.status, this.msg});

  CheckLoginStatusModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}

class Result {
  String? id;
  String? socialId;
  String? profilePic;
  String? username;
  String? email;
  String? appToken;
  int? status;
  String? msg;

  Result(
      {this.id,
        this.socialId,
        this.profilePic,
        this.username,
        this.email,
        this.appToken,
        this.status,
        this.msg});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    socialId = json['social_id'];
    profilePic = json['profile_pic'];
    username = json['username'];
    email = json['email'];
    appToken = json['app_token'];
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['social_id'] = this.socialId;
    data['profile_pic'] = this.profilePic;
    data['username'] = this.username;
    data['email'] = this.email;
    data['app_token'] = this.appToken;
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}
