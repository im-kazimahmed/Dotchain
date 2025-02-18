class ChatMessageListModel {
  List<ChatMassageList>? result;
  int? status;
  String? msg;

  ChatMessageListModel({this.result, this.status, this.msg});

  ChatMessageListModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <ChatMassageList>[];
      json['result'].forEach((v) {
        result!.add(new ChatMassageList.fromJson(v));
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

class ChatMassageList {
  String? profilePic;
  String? toProfilePic;
  String? userChatMasterId;
  String? fromUserId;
  String? toUserId;
  String? message;

  ChatMassageList(
      {this.profilePic,
        this.toProfilePic,
        this.userChatMasterId,
        this.fromUserId,
        this.toUserId,
        this.message});

  ChatMassageList.fromJson(Map<String, dynamic> json) {
    profilePic = json['profile_pic'];
    toProfilePic = json['to_profile_pic'];
    userChatMasterId = json['user_chat_master_id'];
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_pic'] = this.profilePic;
    data['to_profile_pic'] = this.toProfilePic;
    data['user_chat_master_id'] = this.userChatMasterId;
    data['from_user_id'] = this.fromUserId;
    data['to_user_id'] = this.toUserId;
    data['message'] = this.message;
    return data;
  }
}
