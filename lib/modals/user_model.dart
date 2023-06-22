class UserModel {
  String? uid;
  String? email;
  String? fullname;
  String? profilepic;

  UserModel({this.uid, this.email, this.fullname, this.profilepic});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    email = map["email"];
    fullname = map["fullname"];
    profilepic = map["profilepic"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "fullname": fullname,
      "profilepic": profilepic,
    };
  }
}
