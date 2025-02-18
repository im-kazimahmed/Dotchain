class ChangLangModel {
  String? viTitle;
  String? enTitle;
  String? enBody;
  String? viBody;

  ChangLangModel({this.viTitle, this.enTitle, this.enBody, this.viBody});

  ChangLangModel.fromJson(Map<String, dynamic> json) {
    viTitle = json['vi_title'];
    enTitle = json['en_title'];
    enBody = json['en_body'];
    viBody = json['vi_body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vi_title'] = this.viTitle;
    data['en_title'] = this.enTitle;
    data['en_body'] = this.enBody;
    data['vi_body'] = this.viBody;
    return data;
  }
}
