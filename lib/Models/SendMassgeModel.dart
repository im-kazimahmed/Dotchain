class SendMassageModel {
  Result? result;
  int? status;
  String? msg;

  SendMassageModel({this.result, this.status, this.msg});

  SendMassageModel.fromJson(Map<String, dynamic> json) {
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
  String? userChatMasterId;
  ChatMessage? chatMessage;

  Result({this.userChatMasterId, this.chatMessage});

  Result.fromJson(Map<String, dynamic> json) {
    userChatMasterId = json['user_chat_master_id'];
    chatMessage = json['chat_message'] != null
        ? new ChatMessage.fromJson(json['chat_message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_chat_master_id'] = this.userChatMasterId;
    if (this.chatMessage != null) {
      data['chat_message'] = this.chatMessage!.toJson();
    }
    return data;
  }
}

class ChatMessage {
  String? profilePic;
  String? toProfilePic;
  String? fromUserId;
  String? toUserId;
  String? message;

  ChatMessage(
      {this.profilePic,
        this.toProfilePic,
        this.fromUserId,
        this.toUserId,
        this.message});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    profilePic = json['profile_pic'];
    toProfilePic = json['to_profile_pic'];
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_pic'] = this.profilePic;
    data['to_profile_pic'] = this.toProfilePic;
    data['from_user_id'] = this.fromUserId;
    data['to_user_id'] = this.toUserId;
    data['message'] = this.message;
    return data;
  }
}
