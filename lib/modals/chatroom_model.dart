class ChatroomModel {
  String? chatroomid;
  List<String>? participants;

  ChatroomModel({this.chatroomid, this.participants});

  ChatroomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
    };
  }
}
