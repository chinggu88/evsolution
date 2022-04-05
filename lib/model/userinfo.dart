class Userinfo {
  String? fmtoken;
  String? id;
  String? kind;
  String? loginTime;
  String? seq;
  String? token;

  Userinfo(
      {this.fmtoken, this.id, this.kind, this.loginTime, this.seq, this.token});

  Userinfo.fromJson(Map<String, dynamic> json) {
    fmtoken = json['fmtoken'];
    id = json['id'];
    kind = json['kind'];
    loginTime = json['login_time'];
    seq = json['seq'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fmtoken'] = this.fmtoken;
    data['id'] = this.id;
    data['kind'] = this.kind;
    data['login_time'] = this.loginTime;
    data['seq'] = this.seq;
    data['token'] = this.token;
    return data;
  }
}
