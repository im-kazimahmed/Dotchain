class SpeedModel {
  int? currentMiningSpeed;
  String? msg;
  int? status;

  SpeedModel({this.currentMiningSpeed, this.msg, this.status});

  SpeedModel.fromJson(Map<String, dynamic> json) {
    currentMiningSpeed = json['current_mining_speed'];
    msg = json['msg'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_mining_speed'] = this.currentMiningSpeed;
    data['msg'] = this.msg;
    data['status'] = this.status;
    return data;
  }
}
