class GetchatuserListModel {
  List<GetUserResult>? result;
  int? status;
  String? msg;

  GetchatuserListModel({this.result, this.status, this.msg});

  GetchatuserListModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <GetUserResult>[];
      json['result'].forEach((v) {
        result!.add(new GetUserResult.fromJson(v));
      });
    }
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}

class GetUserResult {
  String? username;
  String? profilePic;
  String? masterId;
  String? fromUserId;
  String? toUserId;
  String? message;
  String? dateTime;

  GetUserResult(
      {this.username,
        this.profilePic,
        this.masterId,
        this.fromUserId,
        this.toUserId,
        this.message,
        this.dateTime});

  GetUserResult.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    profilePic = json['profile_pic'];
    masterId = json['master_id'];
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    message = json['message'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    data['master_id'] = this.masterId;
    data['from_user_id'] = this.fromUserId;
    data['to_user_id'] = this.toUserId;
    data['message'] = this.message;
    data['date_time'] = this.dateTime;
    return data;
  }
}
