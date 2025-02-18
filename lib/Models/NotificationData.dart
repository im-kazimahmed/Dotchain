
class NotificationData {
  String? masterId;
  String? miningId;

  NotificationData({this.masterId, this.miningId});

  NotificationData.fromJson(Map<String, dynamic> json) {
    masterId = json['master_id'];
    miningId = json['mining_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['master_id'] = this.masterId;
    data['mining_id'] = this.miningId;
    return data;
  }
}

class BodyNotificationModel {
  Body? body;

  BodyNotificationModel({this.body});

  BodyNotificationModel.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  String? en;
  String? ko;
  String? vi;

  Body({this.en, this.ko, this.vi});

  Body.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ko = json['ko'];
    vi = json['vi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ko'] = this.ko;
    data['vi'] = this.vi;
    return data;
  }
}

