class Userinfo {
  String? kind;
  int? seq;
  String? loginTime;
  String? token;
  String? id;
  String? fmtoken;

  Userinfo({this.kind, this.seq, this.loginTime, this.token, this.id, this.fmtoken});

  Userinfo.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    seq = json['seq'];
    loginTime = json['login_time'];
    token = json['token'];
    id = json['id'];
    fmtoken = json['fmtoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['seq'] = this.seq;
    data['login_time'] = this.loginTime;
    data['token'] = this.token;
    data['id'] = this.id;
    data['fmtoken']=this.fmtoken;
    return data;
  }
}