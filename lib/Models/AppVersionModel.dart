class getAppVersionModel {
  Result? result;
  int? status;
  String? msg;

  getAppVersionModel({this.result, this.status, this.msg});

  getAppVersionModel.fromJson(Map<String, dynamic> json) {
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
  String? androidAppVersion;
  String? iosAppVersion;

  Result({this.androidAppVersion, this.iosAppVersion});

  Result.fromJson(Map<String, dynamic> json) {
    androidAppVersion = json['android_app_version'];
    iosAppVersion = json['ios_app_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['android_app_version'] = this.androidAppVersion;
    data['ios_app_version'] = this.iosAppVersion;
    return data;
  }
}
