class Speed_CurrentBalanceModel {
  String? currentMiningSpeed;
  String? maximumRate;
  String? miningBalance;
  String? gameBalance;
  String? miningStatus;
  String? miningStartAt;
  String? msg;
  int? status;

  Speed_CurrentBalanceModel(
      {this.currentMiningSpeed,
        this.maximumRate,
        this.miningBalance,
        this.gameBalance,
        this.miningStatus,
        this.miningStartAt,
        this.msg,
        this.status});

  Speed_CurrentBalanceModel.fromJson(Map<String, dynamic> json) {
    currentMiningSpeed = json['current_mining_speed'];
    maximumRate = json['maximum_rate'];
    miningBalance = json['mining_balance'];
    gameBalance = json['game_balance'];
    miningStatus = json['mining_status'];
    miningStartAt = json['mining_start_at'];
    msg = json['msg'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_mining_speed'] = this.currentMiningSpeed;
    data['maximum_rate'] = this.maximumRate;
    data['mining_balance'] = this.miningBalance;
    data['game_balance'] = this.gameBalance;
    data['mining_status'] = this.miningStatus;
    data['mining_start_at'] = this.miningStartAt;
    data['msg'] = this.msg;
    data['status'] = this.status;
    return data;
  }
}
