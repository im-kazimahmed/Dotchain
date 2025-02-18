class UserGameBalanceModel {
  List<GameBalance>? result;
  String? gameBalance;
  int? status;
  String? msg;

  UserGameBalanceModel({this.result, this.gameBalance, this.status, this.msg});

  UserGameBalanceModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <GameBalance>[];
      json['result'].forEach((v) {
        result!.add(new GameBalance.fromJson(v));
      });
    }
    gameBalance = json['game_balance'];
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['game_balance'] = this.gameBalance;
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}

class GameBalance {
  int? gameId;
  int? gameBalance;

  GameBalance({this.gameId, this.gameBalance});

  GameBalance.fromJson(Map<String, dynamic> json) {
    gameId = json['game_id'];
    gameBalance = json['game_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['game_id'] = this.gameId;
    data['game_balance'] = this.gameBalance;
    return data;
  }
}
