class totalUser_count_Model {
  TotalUser_Count? result;
  int? status;
  String? msg;

  totalUser_count_Model({this.result, this.status, this.msg});

  totalUser_count_Model.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new TotalUser_Count.fromJson(json['result']) : null;
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

class TotalUser_Count {
  String? totalUsers;
  double? totalUsersPercentage;
  String? activeMiners;
  double? activeMinersPercentage;
  int? activeUsers;
  int? inactiveUsers;
  List<TotalRefererUsersList>? totalRefererUsersList;

  TotalUser_Count(
      {this.totalUsers,
        this.totalUsersPercentage,
        this.activeMiners,
        this.activeMinersPercentage,
        this.activeUsers,
        this.inactiveUsers,
        this.totalRefererUsersList});

  TotalUser_Count.fromJson(Map<String, dynamic> json) {
    totalUsers = json['total_users'];
    totalUsersPercentage = json['total_users_percentage'];
    activeMiners = json['active_miners'];
    activeMinersPercentage = json['active_miners_percentage'];
    activeUsers = json['active_users'];
    inactiveUsers = json['inactive_users'];
    if (json['total_referer_users_list'] != null) {
      totalRefererUsersList = <TotalRefererUsersList>[];
      json['total_referer_users_list'].forEach((v) {
        totalRefererUsersList!.add(new TotalRefererUsersList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_users'] = this.totalUsers;
    data['total_users_percentage'] = this.totalUsersPercentage;
    data['active_miners'] = this.activeMiners;
    data['active_miners_percentage'] = this.activeMinersPercentage;
    data['active_users'] = this.activeUsers;
    data['inactive_users'] = this.inactiveUsers;
    if (this.totalRefererUsersList != null) {
      data['total_referer_users_list'] =
          this.totalRefererUsersList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TotalRefererUsersList {
  String? id;
  String? username;
  String? profilePic;
  String? miningStatus;
  String? masterId;

  TotalRefererUsersList(
      {this.id,
        this.username,
        this.profilePic,
        this.miningStatus,
        this.masterId});

  TotalRefererUsersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    profilePic = json['profile_pic'];
    miningStatus = json['mining_status'];
    masterId = json['master_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    data['mining_status'] = this.miningStatus;
    data['master_id'] = this.masterId;
    return data;
  }
}
