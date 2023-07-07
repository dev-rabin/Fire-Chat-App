// ignore_for_file: constant_identifier_names

const KEY_CHATROOMID = "chatroomId";
const KEY_PARTICIPANTS = "participants";
const KEY_LASTMESSAGE = "lastMessage";
const KEY_SENDTIME = "sendtime";

class ChatroomModel {
  String? chatroomId;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? sendTime;

  ChatroomModel(
      {required this.chatroomId,
      required this.participants,
      required this.lastMessage,
      required this.sendTime});

  ChatroomModel.fromMap(Map<String, dynamic> map) {
    chatroomId = map[KEY_CHATROOMID];
    participants = map[KEY_PARTICIPANTS];
    lastMessage = map[KEY_LASTMESSAGE];
    sendTime = map[KEY_SENDTIME].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      KEY_CHATROOMID: chatroomId,
      KEY_PARTICIPANTS: participants,
      KEY_LASTMESSAGE: lastMessage,
      KEY_SENDTIME: sendTime,
    };
  }
}
