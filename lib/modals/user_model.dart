const KEY_UID = "uid";
const KEY_EMAIL = "email";
const KEY_FULLNAME = "fullname";
const KEY_PROFILEPIC = "profilepic";
const KEY_LASTSEEN = "lastSeen";
const KEY_STATUS = "status";

class UserModel {
  String? uid;
  String? email;
  String? fullname;
  String? profilepic;
  DateTime? lastSeen;
  String? status;

  UserModel({
    this.uid,
    this.email,
    this.fullname,
    this.profilepic,
    this.lastSeen,
    this.status,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map[KEY_UID];
    email = map[KEY_EMAIL];
    fullname = map[KEY_FULLNAME];
    profilepic = map[KEY_PROFILEPIC];
    lastSeen = map[KEY_LASTSEEN].toDate();
    status = map[KEY_STATUS];
  }

  Map<String, dynamic> toMap() {
    return {
      KEY_UID: uid,
      KEY_EMAIL: email,
      KEY_FULLNAME: fullname,
      KEY_PROFILEPIC: profilepic,
      KEY_LASTSEEN: lastSeen,
      KEY_STATUS: status
    };
  }
}
