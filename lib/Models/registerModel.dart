class registerModel {
  Result? result;
  int? status;
  String? msg;

  registerModel({this.result, this.status, this.msg});

  registerModel.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? username;
  String? status;
  String? nonce;
  String? profilePic;

  Result(
      {this.id,
        this.email,
        this.username,
        this.status,
        this.nonce,
        this.profilePic});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    status = json['status'];
    nonce = json['nonce'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['status'] = this.status;
    data['nonce'] = this.nonce;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
