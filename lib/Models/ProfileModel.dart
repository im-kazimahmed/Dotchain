class UserProfileModel {
  Result? result;
  int? status;
  String? msg;

  UserProfileModel({this.result, this.status, this.msg});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? username;
  String? email;
  String? profilePic;

  Result({this.username, this.email, this.profilePic});

  Result.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
